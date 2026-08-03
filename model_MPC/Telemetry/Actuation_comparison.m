options = {'ACC_CROAZIA_1', 'ACC_CROAZIA_2', 'ACC_CROAZIA_3', 'ACC_CROAZIA_4'};

test_set = menu('Select the run to compare:', options);

switch test_set

    case 1
        car_data;
        simout = sim("longitunal_DynamicModel.slx");
        simout_2 = sim("steering_pad_test_dual.slx");
        Comp_1;
    case 2
        car_data;
        simout = sim("longitunal_DynamicModel.slx");
        simout_2 = sim("steering_pad_test_dual.slx");
        Comp_2;
    case 3
        car_data;
        simout = sim("longitunal_DynamicModel.slx");
        simout_2 = sim("steering_pad_test_dual.slx");
        Comp_3;
    case 4
        car_data;
        simout = sim("longitunal_DynamicModel.slx");
        simout_2 = sim("steering_pad_test_dual.slx");
        Comp_4;
end

clear options