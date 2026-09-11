% Data trasnfer optimization between Motec and Matlab/Simulink
% This script and the Excel files must be on the same folder

%% 1. Initial configuration
% Insert the exact name of your Excel file
nome_file = "Brake_2_from_workspace.xlsx"; 

% Define which are the sheets you want to extract all the columns from from 
fogli_da_importare = ["Foglio2", "Foglio3"]; 

% Structure initialization
DatiCorsa = struct();

%% 2. Automated Lecture Cicle
for i = 1:length(fogli_da_importare)
    nome_foglio = fogli_da_importare(i);
    fprintf('Elaborazione dei dati dal %s...\n', nome_foglio);
    
   
    % Read the name from the first row to assign a name to the variables
    Intestazioni = readcell(nome_file, 'Sheet', nome_foglio, 'Range', '1:1');
    
    % Read numerical values
    % readmatrix xommand will ignore the first two rows
    
    Dati = readmatrix(nome_file, 'Sheet', nome_foglio, 'TreatAsMissing', {'NaN', '', '--'});
    Dati = fillmissing(Dati, 'previous');
    
    % The first row is always the Time Vector (Column A)
    Tempo = Dati(:, 1);
    
    % Automatically determines how many columns there are in the sheet
    num_colonne = size(Dati, 2);
    
    % Name of the sheet 
    nome_campo_foglio = matlab.lang.makeValidName(nome_foglio);
    
    %% 3. Column by Column determination for Simulink
    for col = 2:num_colonne
        % Array N x 2 ready for the "From Workspace"
        array_simulink = [Tempo, Dati(:, col)];
        
        % Variable's name determined
        if col <= length(Intestazioni) && ~any(ismissing(Intestazioni{col}))
            nome_grezzo = string(Intestazioni{col});
        else
            % If there isn't a heading (es. Foglio3), it uses a generic
            % name
            nome_grezzo = sprintf('Segnale_Colonna_%d', col);
        end
        
        % Changes the name into the MATLAB language (es: "Brake Pressure Front" -> "BrakePressureFront")
        nome_pulito = matlab.lang.makeValidName(nome_grezzo);
        
        % The array is saved into the structure
        DatiCorsa.(nome_campo_foglio).(nome_pulito) = array_simulink;
    end
end

%% 4. Save
save("DatiMotec_Simulink.mat", "DatiCorsa", "-v7.3");
disp('Importazione completata con successo!');