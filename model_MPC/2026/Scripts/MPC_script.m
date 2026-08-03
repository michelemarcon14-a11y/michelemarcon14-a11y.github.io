%% Creaione script per utilizzo del simulink con MPC + tracciato
% Primo script: Creazione dei punti per la pista di riferimento (skidpad in questo caso)

R = 9; % Raggio dei cerchi in metri (Nota: in FSAE il raggio in mezzeria è circa 9.125m)
L_straight = 15; % Lunghezza dei rettilinei in metri
pts_per_circle = 150; % Punti di risoluzione per i cerchi

% 1. Rettilineo di Ingresso (lungo l'asse X, da -15 a 0)
x_in = linspace(-L_straight, 0, 20)';
y_in = zeros(size(x_in)); 

% 2. Due giri a Destra (Centro del cerchio: x = 0, y = -R)
% Partiamo da pi/2 e scendiamo (senso orario) per 2 giri (4*pi)
theta_right = linspace(pi/2, pi/2 - 4*pi, 2*pts_per_circle)';
x_right = R * cos(theta_right);
y_right = -R + R * sin(theta_right);

% 3. Due giri a Sinistra (Centro del cerchio: x = 0, y = R)
% Partiamo da -pi/2 e saliamo (senso antiorario) per 2 giri (4*pi)
theta_left = linspace(-pi/2, -pi/2 + 4*pi, 2*pts_per_circle)';
x_left = R * cos(theta_left);
y_left = R + R * sin(theta_left);

% 4. Rettilineo di Uscita (lungo l'asse X, da 0 a 15)
x_out = linspace(0, L_straight, 20)';
y_out = zeros(size(x_out)); 

% --- Assemblaggio dei Waypoint ---
% Rimuoviamo il primo elemento dei segmenti successivi per evitare punti doppi
X = [x_in; x_right(2:end); x_left(2:end); x_out(2:end)];
Y = [y_in; y_right(2:end); y_left(2:end); y_out(2:end)];

% Aggiungiamo la coordinata Z (0) richiesta dal Driving Scenario Toolbox
waypoints = [X, Y, zeros(size(X))];

% --- Esportazione nel Driving Scenario Designer ---
scenario = drivingScenario;

% Aggiungi la strada usando direttamente i waypoint 3D
road(scenario, waypoints, 'lanes', lanespec(1));

% Aggiungi un unico Ego Vehicle posizionato sul primo punto della strada
egoCar = vehicle(scenario, ...
    'ClassID', 1, ...
    'Length', 3, ...
    'Width', 1.5, ...
    'Position', waypoints(1,:)); 

% Assegniamo la traiettoria al veicolo (velocità costante)
speed = 8; 
smoothTrajectory(egoCar, waypoints, speed); 

% Apriamo l'app con lo scenario precaricato
%drivingScenarioDesigner(scenario);
%% Inserimento funzione che crea gli array nel workspace di matlab
% Necessari per fornire la reference del tracciato
% 2. Registra l'intera simulazione
recordedData = record(scenario);

% 3. Conta quanti "fotogrammi" (istanti di tempo) sono stati registrati
N = length(recordedData);

% 4. Prepara le variabili vuote
t = zeros(N, 1);
posRef = zeros(N, 2);
yawRef = zeros(N, 1);

% 5. Estrai i dati fotogramma per fotogramma
for i = 1:N
    % Salva il tempo
    t(i) = recordedData(i).SimulationTime;
    
    % ActorPoses(1) corrisponde alla tua Ego Car. Estraiamo X, Y e lo Yaw
    posRef(i, :) = recordedData(i).ActorPoses(1).Position(1:2); 
    yawRef(i) = recordedData(i).ActorPoses(1).Yaw;
end
% Trasla l'intera pista in modo che il primo punto sia esattamente (0,0)
posRef(:,1) = posRef(:,1) - posRef(1,1); 
posRef(:,2) = posRef(:,2) - posRef(1,2);

%% Inserimento script per definizione dell'MPC
% Matrici A_dyn, B, B1, B2, C_dyn, D_dyn per descrivere comportamento auto
% e disturbo 

% Parametri matrici

V = 34/3.6; % Velocità costante in m/s (es. 42 km/h).
L = 1.54;   % Passo in metri (Wheelbase). 
Cr = 25210; % Cornering stiffness rear [Nm/rad]
Cf = Cr;    % Cornering stiffness rear [Nm/rad]
m = 298;    % Massa veicolo [Kg]
lr = 0.722; % Rear wheelbase [m]
lf = 0.818; % Front wheelbase [m]
Iz = 134.3; % Yaw inertia [Kg*m^2]
phi = 0;    % Angolo inclinazione strada [deg]
g = 9.81;   % Accelerazione di gravità [m/s^2]

% 2. Creazione del Modello Matematico Interno (Plant LTI)
% Le equazioni sono: dot_ey = V * e_psi  |  dot_epsi = (V/L) * delta

A_dyn = [0,         1,              0,                      0                                   ;
         0, -(2*Cf + 2*Cr)/(m*V), (2*Cf + 2*Cr)/m, (2*Cr*lr - 2*Cf*lf)/(m*V)                    ;
         0,             0,                  0,                      1                           ;
         0, (2*Cr*lr - 2*Cf*lf)/(Iz*V), (2*Cf*lf - 2*Cr*lr)/Iz, -(2*Cf*lf^2 + 2*Cr*lr^2)/(Iz*V)];

B1 = [      0       ;
          2*Cf/m    ;
            0       ;
     2*(Cf*lf)/Iz]  ;

B2 = [              0                 ;
      -(2*Cf*lf - 2*Cr*lr)/(m*V) - V  ;
                    0                 ;
      -(2*Cf*lf^2 + 2*Cr*lr^2)/(Iz*V)];

B3 = [  0    ;
        0    ;
        0    ;
      1/Iz]  ;

% Scrittura delle matrici B in una singola 

%B_dyn = [ B1 , B2 ]; % Senza influenza dell'inclinazione
%stradale/differenziale

B_dyn = [ B1 , B2 , B3 ]; % Con influenza del differenziale

C_dyn = eye(4);   % Ora misuriamo 4 stati!
D_dyn = zeros(4,3);

% Creiamo il sistema State-Space
plant_errore = ss(A_dyn, B_dyn, C_dyn, D_dyn);
plant_errore.InputName = {'steering_angle','psi_dot_des','Mz_lsd'};
plant_errore.OutputName = {'e_y', 'e_y_dot', 'e_psi', 'e_psi_dot'};

% Definisco i parametri per l'MPC 
% MV = maniluated variables => ingresso 1, (steering_angle)
% MD = measured Disturbances => ingresso 2, (psi_dot_res)
plant_errore = setmpcsignals(plant_errore, 'MV' , 1 , 'MD', [2, 3]);

%% 3. Inizializzazione del Controllore MPC
Ts = 0.005;  % Tempo di campionamento. NOTA: Deve coincidere col "Sample time" del tuo modello Simulink!
mpcobj_dyn = mpc(plant_errore, Ts);

%% 4. Tuning dell'MPC (Orizzonti e Pesi)
mpcobj_dyn.PredictionHorizon = 100; % Guarda 18 passi nel futuro (circa 1.5 secondi)
mpcobj_dyn.ControlHorizon = 20;     % Pianifica le prime 3 mosse di sterzo

% Pesi sugli errori (Quanto vogliamo che stiano a zero)
% Il primo valore è per l'errore laterale (e_y), il secondo per lo yaw (e_psi)
mpcobj_dyn.Weights.OutputVariables = [100, 1, 10, 0.5]; % Diamo molta più importanza alla curva che all'orientamento

% Peso sullo sforzo di sterzata (Quanto vogliamo che il volante sia "pigro")
mpcobj_dyn.Weights.ManipulatedVariablesRate = 0.5; % Un valore basso permette allo sterzo di essere reattivo

%% 5. Limiti Fisici (Constraint) 
% Diciamo all'MPC che lo sterzo non può girare all'infinito (es. massimo +/- 160 gradi)
mpcobj_dyn.MV.Min = -deg2rad(160); 
mpcobj_dyn.MV.Max = deg2rad(160);

disp('Oggetto mpcobj creato con successo! Ora puoi aprire Simulink.');