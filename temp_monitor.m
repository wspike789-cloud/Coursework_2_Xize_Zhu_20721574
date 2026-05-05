function temp_monitor(a)



    time_data = [];
    temp_data = [];
    start_time = tic;
    counter = 0;      
    led_state = 0;   
    
    figure('Name', 'Live Temperature Monitor');
    h_plot = plot(NaN, NaN, 'b-', 'LineWidth', 1.5);
    title('Real-time Capsule Temperature');
    xlabel('Time (s)');
    ylabel('Temperature (^{\circ}C)');
    grid on;
    
    disp('Monitoring started. Press Ctrl+C in Command Window to stop.');

    while true
       
        pause(0.25); 
        counter = counter + 1;
        if mod(counter, 4) == 0
            
            v_out = readVoltage(a, 'A0');
            
            current_temp = (v_out - 0.5) / 0.01; 
            
            current_time = toc(start_time); 
            
            
            time_data = [time_data, current_time];
            temp_data = [temp_data, current_temp];
            
           
            set(h_plot, 'XData', time_data, 'YData', temp_data);
            
            
            if current_time > 20
                xlim([current_time - 20, current_time + 5]);
            else
                xlim([0, 25]);
            end
            drawnow; 
        end
        
        if isempty(temp_data)
            continue; 
        end
        
        latest_temp = temp_data(end); 
        
        
        if latest_temp >= 18 && latest_temp <= 24
            
            writeDigitalPin(a, 'D10', 1); 
            writeDigitalPin(a, 'D11', 0);
            writeDigitalPin(a, 'D12', 0);
            
        elseif latest_temp < 18
            
            writeDigitalPin(a, 'D10', 0);
            writeDigitalPin(a, 'D12', 0);
            
            if mod(counter, 2) == 0
                led_state = ~led_state; 
                writeDigitalPin(a, 'D11', led_state); 
            end
            elseif latest_temp > 24
            
            writeDigitalPin(a, 'D10', 0);
            writeDigitalPin(a, 'D11', 0);
            
            led_state = ~led_state;
            writeDigitalPin(a, 'D12', led_state); 
        end
    end
end
        
    
    
        