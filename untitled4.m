% Insert name here
% Insert email address here


%% PRELIMINARY TASK - ARDUINO AND GIT INSTALLATION [5 MARKS]

if ~exist('a', 'var')
    a = arduino('COM3', 'Uno'); 
end
led_pin = 'A0'; 

disp('Arduino connection established. Starting LED blink test...');
for i = 1:10
writeDigitalPin(a, led_pin, 1);
pause(0.5);
writeDigitalPin(a, led_pin, 0);
pause(0.5); 
    
end

disp('Preliminary task completed successfully!');


%% TASK 1 - READ TEMPERATURE DATA, PLOT, AND WRITE TO A LOG FILE [20 MARKS]

%% TASK 1 - READ TEMPERATURE DATA, PLOT, AND WRITE TO A LOG FILE [20 MARKS]

duration = 600; 
time_data = zeros(1, duration); 
temp_data = zeros(1, duration); 

%% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]

% Insert answers here


%% TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION [30 MARKS]

% Insert answers here


%% TASK 4 - REFLECTIVE STATEMENT [5 MARKS]

% Insert answers here