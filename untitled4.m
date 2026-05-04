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

v_0 = 0.5;  
t_c = 0.01; 
sensor_pin = 'A0';
disp('Data logging started. Please wait for 10 minutes...');


for t = 1:duration
    
    voltage = readVoltage(a, sensor_pin);
    
    temperature = (voltage - v_0) / t_c;
    
    time_data(t) = t;
    temp_data(t) = temperature;
    
    pause(1);
    
    if mod(t, 60) == 0
        fprintf('Progress: Logged %d minute(s)...\n', t/60);
    end
end

disp('Data acquisition completed.');


%% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]

% Insert answers here


%% TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION [30 MARKS]

% Insert answers here


%% TASK 4 - REFLECTIVE STATEMENT [5 MARKS]

% Insert answers here