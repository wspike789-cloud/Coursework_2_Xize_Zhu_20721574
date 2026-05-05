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
            
            
    
    