%clear
%clc
%% ricerca e caricamento file .tir
% 1. Trova path del file .tir relativo al progetto
filePath = fileparts(mfilename('fullpath'));

% Use .tir file of Hoosier 18x6x10 R20 rim7 (only longitudinal)
tirFile  = fullfile(filePath,'tir_files','Hoosier_18x6x10_R20_7_in_rim.tir');

% Use .tir file of Hoosier 16x7.5x10 LCO rim7 (only lateral)
%tirFile  = fullfile(filePath,'tir_files','Hoosier_16x75x10_LC0_7_in_rim.tir');

% Use .tir file of Hoosier Zombie (zombie, 18x6 R20 longitudinal, 16x7.5 LC0 lateral)
%tirFile  = fullfile(filePath,'tir_files','Hoosier_zombie_tire.tir');

%%  Lettura del .tir
p = readTirParameters(tirFile);

%% estrazione coefficienti longitudinali

tyre.Cx1 = getParam(p,'PCX1',1);

tyre.Dx1 = getParam(p,'PDX1',1);
tyre.Dx2 = getParam(p,'PDX2',0);
tyre.Dx3 = getParam(p,'PDX3',0);

tyre.Ex1 = getParam(p,'PEX1',0);
tyre.Ex2 = getParam(p,'PEX2',0);
tyre.Ex3 = getParam(p,'PEX3',0);
tyre.Ex4 = getParam(p,'PEX4',0);

tyre.Kx1 = getParam(p,'PKX1',10);
tyre.Kx2 = getParam(p,'PKX2',0);
tyre.Kx3 = getParam(p,'PKX3',0);

tyre.Hx1 = getParam(p,'PHX1',0);
tyre.Hx2 = getParam(p,'PHX2',0);

tyre.Vx1 = getParam(p,'PVX1',0);
tyre.Vx2 = getParam(p,'PVX2',0);

tyre.px1 = getParam(p,'PPX1',0);
tyre.px2 = getParam(p,'PPX2',0);
tyre.px3 = getParam(p,'PPX3',0);
tyre.px4 = getParam(p,'PPX4',0);

tyre.lmux = getParam (p,'LMUX',1);

% % se manca lmux/mettiamo 1 per sicurezza
% if ~isfield(tyre,'lmux') || isempty(tyre.lmux)
%     tyre.lmux = 1;
% end
% 
% % 4. Esporta come Simulink.Parameter globale chiamato TYRE
% TYRE = Simulink.Parameter(tyre);
% TYRE.CoderInfo.StorageClass = 'Auto';  % va bene così
% 
% % metti TYRE in base workspace (così il modello lo vede)
% assignin('base','TYRE',TYRE);
% 
% fprintf('TYRE pronto nel base workspace.\n');
% 

%% estrazione coefficienti laterali
  tyre.Cy1 = getParam(p,'PCY1',1.1);

  tyre.Dy1 = getParam(p,'PDY1',1);
  tyre.Dy2 = getParam(p,'PDY2',0);
  tyre.Dy3 = getParam(p,'PDY3',0);

  tyre.Ey1 = getParam(p,'PEY1',0);
  tyre.Ey2 = getParam(p,'PEY2',0);
  tyre.Ey3 = getParam(p,'PEY3',0);
  tyre.Ey4 = getParam(p,'PEY4',0);

  tyre.Ky1 = getParam(p,'PKY1',20);
  tyre.Ky2 = getParam(p,'PKY2',0);
  tyre.Ky3 = getParam(p,'PKY3',0);

  tyre.Hy1 = getParam(p,'PHY1',0);
  tyre.Hy2 = getParam(p,'PHY2',0);
  tyre.Hy3 = getParam(p,'PHY3',0);

  tyre.Vy1 = getParam(p,'PVY1',0);
  tyre.Vy2 = getParam(p,'PVY2',0);
  tyre.Vy3 = getParam(p,'PVY3',0);
  tyre.Vy4 = getParam(p,'PVY4',0);

  tyre.py1 = getParam(p,'PPY1',0);
  tyre.py2 = getParam(p,'PPY2',0);
  tyre.py3 = getParam(p,'PPY3',0);
  tyre.py4 = getParam(p,'PPY4',0);

  tyre.lmuy = getParam(p,'LMUY',1);

%% ------- FUNZIONI LOCALI -------
function params = readTirParameters(tirFilename)
    fid = fopen(tirFilename,'r');
    if fid < 0, error('Impossibile aprire il file: %s',tirFilename); end
    cleaner = onCleanup(@() fclose(fid));
    params = struct();
    while ~feof(fid)
        line = fgetl(fid);
        if ~ischar(line), break; end
        % leggo righe tipo "PCX1 = 1.5"
        tokensNum = regexp(line,'^\s*(\S+)\s*=\s*([-+]?\d+(\.\d+)?([eE][+-]?\d+)?)','tokens');
        if ~isempty(tokensNum)
            name = tokensNum{1}{1};
            val  = str2double(tokensNum{1}{2});
            if ~isnan(val), params.(name) = val; end
        end
    end
end

% la funzione getParam prende i valori letti "p" ed estrae il valore con il
% nome del relativo coefficiente. l'ultimo numero è il valore di default
% nel caso non riesca a trovare o mancasse il valore vero nel file .tir

function val = getParam(s,field,def)
    if isfield(s,field), val = s.(field); else, val = def; end
end

%% TYRES PRESSURE
tyre.pressure.front = 83000; % Front Tyre Pressure [Pa]
tyre.pressure.rear = 83000; % Rear Tyre Pressure [Pa]
tyre.pi0 = getParam(p,'IP_NOM',2e5);  % Pa nominale

%% Forza verticale nominale
tyre.Fz0 = getParam(p,'FNOMIN',0);

%% Unloaded Radius
tyre.UR = getParam(p,'UNLOADED_RADIUS',0.2286);

%% BUS che si collega al blocco Simulink come input costante
tyresBus = Simulink.Bus.createObject(tyre);
