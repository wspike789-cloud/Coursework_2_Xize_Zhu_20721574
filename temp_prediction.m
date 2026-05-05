function temp_prediction(a)
% TEMP_PREDICTION Live temperature prediction and trend-based LED warning.
% This function reads capsule temperature (A0) every second.
% It calculates the rate of change (dT/dt) over a 5-second buffer 
% to smooth sensor noise, and predicts the temperature 5 minutes ahead.
% LEDs are activated based on rate: Red for >+4C/min, Yellow for <-4C/min,
% and Green for a stable temperature.

time_data = [];
    temp_data = [];
    start_time = tic;
    
    figure('Name', 'Task 3: Live Prediction Monitor');
    h_plot = plot(NaN, NaN, 'b-', 'LineWidth', 1.5);
    title('Real-time Temperature & Trend Prediction');
    xlabel('Time (s)');
    ylabel('Temperature (^{\circ}C)');
    grid on;
    
    disp('Prediction system started. Press Ctrl+C to stop.');

    while true
        pause(1); 
        
       
        v_out = readVoltage(a, 'A0');
        current_temp = (v_out - 0.5) / 0.01; 
        current_time = toc(start_time);
        
        
        time_data = [time_data, current_time];
        temp_data = [temp_data, current_temp];
        
        
        set(h_plot, 'XData', time_data, 'YData', temp_data);
        if current_time > 30
            xlim([current_time - 30, current_time + 5]);
        else
            xlim([0, 35]);
        end
        drawnow;
        