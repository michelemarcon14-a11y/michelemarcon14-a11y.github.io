

options = {'ACC_CROAZIA_1', 'ACC_CROAZIA_2', 'ACC_CROAZIA_3', 'ACC_CROAZIA_4', 'COMPARISON'};

test_set = menu('Select one option:', options);

switch test_set

    case 1 
        TelPlot__1;
    case 2
        TelPlot__2;
    case 3
        TelPlot__3;
    case 4
        TelPlot__4;
    case 5
        Actuation_comparison;
end

clear options