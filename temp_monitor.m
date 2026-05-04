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

    
    