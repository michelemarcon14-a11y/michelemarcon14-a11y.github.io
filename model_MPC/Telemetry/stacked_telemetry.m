

options = {'DYNAMICS', 'SUSPENSIONS', 'WHEEL SPEED'};

test_set_1 = menu('Select one option:', options);

switch test_set_1

    case 1 
        stack_figure_1 = figure('Name', 'Dynamics', 'WindowState', 'maximized');
        stack_1 = stackedplot(Corr_Dist.Time, [telemetry_1.Corr_Dist.Value', telemetry_1.Engine_Speed.Value', telemetry_1.Friction_Slip.Value', telemetry_1.Gear.Value', telemetry_1.GPS_Speed.Value', telemetry_1.Throttle_Pedal.Value']);
        stack_1.Parent = stack_figure_1;
        stack_1.GridVisible = 'on';

        % Abbellisci con etichettature personalizzate
        stack_1.Title = 'Dynamic Telemetry';  % Titolo generale del plot
        stack_1.XLabel = 'Time [s]';  % Etichetta asse X

       
        % Modifica l'aspetto delle etichette per le colonne
        stack_1.DisplayLabels = {'Corr Dist', 'Engine Speed', 'Friction Slip', 'Gear', 'GPS Speed', 'Throttle Pedal'};
        stack_1.Color = 'b';
        stack_1.LineWidth = 1.5;

        % Forza il rendering per visualizzare correttamente
        drawnow;

    case 2
        stack_figure_2 = figure('Name', 'Suspensions', 'WindowState', 'maximized');
        stack_2 = stackedplot(Corr_Dist.Time, [telemetry_1.Pitch_Susp.Value', telemetry_1.Suspension_Front_Left.Value', telemetry_1.Suspension_Front_Right.Value', telemetry_1.Suspension_Rear_Left.Value', telemetry_1.Suspension_Rear_Right.Value']);
        stack_2.Parent = stack_figure_2;
        stack_2.GridVisible = 'on';

        % Abbellisci con etichettature personalizzate
        stack_2.Title = 'Suspensions Telemetry';  % Titolo generale del plot
        stack_2.XLabel = 'Time [s]';  % Etichetta asse X

       
        % Modifica l'aspetto delle etichette per le colonne
        stack_2.DisplayLabels = {'Pitch Suspension', 'Front Left Suspension', 'Front Right Suspension', ...
                       'Rear Left Suspension', 'Rear Right Suspension'};
        stack_2.Color = 'b';
        stack_2.LineWidth = 1.5;

        % Forza il rendering per visualizzare correttamente
        drawnow;

    case 3
        stack_figure_3 = figure('Name', 'Wheel Speed', 'WindowState', 'maximized');
        stack_3 = stackedplot(Corr_Dist.Time, [telemetry_1.Wheel_Speed_Front_Left.Value', telemetry_1.Wheel_Speed_Front_Right.Value', telemetry_1.Wheel_Speed_Rear_Left.Value', telemetry_1.Wheel_Speed_Rear_Right.Value']);
        stack_3.Parent = stack_figure_3;
        stack_3.GridVisible = 'on';

        % Abbellisci con etichettature personalizzate
        stack_3.Title = 'Wheel Speed Telemetry';  % Titolo generale del plot
        stack_3.XLabel = 'Time [s]';  % Etichetta asse X

       
        % Modifica l'aspetto delle etichette per le colonne
        stack_3.DisplayLabels = {'Front Left Wheel Speed', 'Front Right Wheel Speed', ...
                       'Rear Left Wheel Speed', 'Rear Right Wheel Speed'};
        stack_3.Color = 'b';
        stack_3.LineWidth = 1.5;

        % Forza il rendering per visualizzare correttamente
        drawnow;

end

clear options