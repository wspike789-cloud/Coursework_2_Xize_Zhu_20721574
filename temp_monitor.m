function temp_monitor(a)
% TEMP_MONITOR Live temperature tracking and LED warning system.
% This function continuously reads capsule temperature from Arduino (A0).
% It updates a live graph every 1s. It also controls 3 LEDs: 
% Green (constant) for 18-24 C, Yellow (blinking 0.5s) for <18 C, 
% and Red (blinking 0.25s) for >24 C.


    time_data = [];% Array to store time stamps
    temp_data = [];% Array to store temperature readings
    start_time = tic;% Start the system timer
    counter = 0;   % Counter to manage loop execution cycles   
    led_state = 0; % Variable to track the ON/OFF state of blinking LEDs 
    
    figure('Name', 'Live Temperature Monitor');
    % Initialize an empty plot line; we will update its data dynamically
    h_plot = plot(NaN, NaN, 'b-', 'LineWidth', 1.5);
    title('Real-time Capsule Temperature');
    xlabel('Time (s)');
    ylabel('Temperature (^{\circ}C)');
    grid on;
    
    disp('Monitoring started. Press Ctrl+C in Command Window to stop.');

    while true
       
        pause(0.25); 
        counter = counter + 1;
        % Only read and plot data when counter is a multiple of 4 (4 * 0.25s = 1s)
        if mod(counter, 4) == 0
            % Read analog voltage from the sensor on pin A0
            v_out = readVoltage(a, 'A0');
            % Convert voltage to temperature using sensor characteristics
            current_temp = (v_out - 0.5) / 0.01; 
            % Record the exact elapsed time since the loop started
            current_time = toc(start_time); 
            
            
            time_data = [time_data, current_time];
            temp_data = [temp_data, current_temp];
            
            % Update the live plot dynamically without closing/reopening the figure
            set(h_plot, 'XData', time_data, 'YData', temp_data);
            
            % Dynamic X-axis: Create a scrolling effect to show the last 20 seconds
            if current_time > 20
                xlim([current_time - 20, current_time + 5]);
            else
                % Keep X-axis fixed at 0-25s for the initial phase
                xlim([0, 25]);
            end
            % Force MATLAB to refresh the figure window immediately
            drawnow; 
        end
        % Prevent errors during the very first cycle if arrays are still empty
        if isempty(temp_data)
            continue; 
        end
        % Extract the most recent temperature reading for LED logic evaluation
        latest_temp = temp_data(end); 
        
        
        if latest_temp >= 18 && latest_temp <= 24
            % Condition 1: Temperature is within the comfort range (18-24 C)
            % Turn ON the Green LED (D10) constantly, and ensure others are OFF
            writeDigitalPin(a, 'D10', 1); 
            writeDigitalPin(a, 'D11', 0);
            writeDigitalPin(a, 'D12', 0);
            
        elseif latest_temp < 18
            % Condition 2: Temperature is below the comfort range (< 18 C)
            % Turn OFF Green and Red LEDs
            writeDigitalPin(a, 'D10', 0);
            writeDigitalPin(a, 'D12', 0);
            % The Yellow LED (D11) needs to blink every 0.5s.
            if mod(counter, 2) == 0
                led_state = ~led_state; 
                writeDigitalPin(a, 'D11', led_state); 
            end
            elseif latest_temp > 24
            % Condition 3: Temperature is above the comfort range (> 24 C)
            % Turn OFF Green and Yellow LEDs
            writeDigitalPin(a, 'D10', 0);
            writeDigitalPin(a, 'D11', 0);
            % The Red LED (D12) needs to blink every 0.25s.
            % Since our base loop is exactly 0.25s, we toggle the state every single cycle
            led_state = ~led_state;
            writeDigitalPin(a, 'D12', led_state); 
        end
    end
end
        
    
    
        