function temp_prediction(a)
% TEMP_PREDICTION Live temperature prediction and trend-based LED warning.
% This function reads capsule temperature (A0) every second.
% It calculates the rate of change (dT/dt) over a 5-second buffer 
% to smooth sensor noise, and predicts the temperature 5 minutes ahead.
% LEDs are activated based on rate: Red for >+4C/min, Yellow for <-4C/min,
% and Green for a stable temperature.

time_data = [];
    temp_data = [];
    start_time = tic;% Start the system timer for precise timestamping
    
    figure('Name', 'Task 3: Live Prediction Monitor');
    % Initialize the plot with empty data placeholders
    h_plot = plot(NaN, NaN, 'b-', 'LineWidth', 1.5);
    title('Real-time Temperature & Trend Prediction');
    xlabel('Time (s)');
    ylabel('Temperature (^{\circ}C)');
    grid on;
    
    disp('Prediction system started. Press Ctrl+C to stop.');

    while true
        pause(1); % Base loop frequency: 1 second per cycle
        
        % Read analog voltage from the sensor on pin A0
        v_out = readVoltage(a, 'A0');
        % Convert voltage to temperature using sensor specifications
        current_temp = (v_out - 0.5) / 0.01; 
        % Get the exact elapsed time since the loop started
        current_time = toc(start_time);
        
        % Append the newest data points to the historical arrays
        time_data = [time_data, current_time];
        temp_data = [temp_data, current_temp];
        
        
        set(h_plot, 'XData', time_data, 'YData', temp_data);
        % Dynamic X-axis: Scroll the graph to show the last 30 seconds
        if current_time > 30
            xlim([current_time - 30, current_time + 5]);
        else
            % Fixed axis for the initial startup phase
            xlim([0, 35]);
        end
        drawnow;% Force MATLAB to render the updated plot immediately
        if length(temp_data) > 5
            
            % Extract the most recent reading and the reading from 5 seconds ago
            T_current = temp_data(end);
            T_past_5s = temp_data(end - 5); 
            
            % Calculate the rate of change (slope) over the 5-second buffer in C/s
            rate_per_sec = (T_current - T_past_5s) / 5;
            
            % Predict the temperature 5 minutes (300 seconds) into the future
            T_predict = T_current + (rate_per_sec * 300);
            
            % Print the calculated rate and prediction to the Command Window
            fprintf('Rate: %+.3f C/s | Predicted (in 5 mins): %.2f C\n', rate_per_sec, T_predict);

            % Convert the required threshold of 4 C/minute to C/second (approx 0.0667)
  
            threshold = 4 / 60; 
            
            if rate_per_sec > threshold
                
                writeDigitalPin(a, 'D10', 0); % Green OFF
                writeDigitalPin(a, 'D11', 0); % Yellow OFF
                writeDigitalPin(a, 'D12', 1); % Red ON
                
            elseif rate_per_sec < -threshold
                
                writeDigitalPin(a, 'D10', 0); % Green OFF
                writeDigitalPin(a, 'D11', 1); % Yellow ON
                writeDigitalPin(a, 'D12', 0); % Red OFF
                
            else
                
                writeDigitalPin(a, 'D10', 1); % Green ON
                writeDigitalPin(a, 'D11', 0); % Yellow OFF
                writeDigitalPin(a, 'D12', 0); % Red OFF
            end
            
        else
            % Default State: While building the initial 5-second buffer, assume stable
            writeDigitalPin(a, 'D10', 1); 
            writeDigitalPin(a, 'D11', 0);
            writeDigitalPin(a, 'D12', 0);
        end
    end
end