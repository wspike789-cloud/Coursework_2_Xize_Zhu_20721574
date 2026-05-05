% Insert name here
% Insert email address here


%% PRELIMINARY TASK - ARDUINO AND GIT INSTALLATION [5 MARKS]
% Check if the Arduino object 'a' already exists in the workspace
% This prevents MATLAB from reconnecting and throwing an error if it's already connected
if ~exist('a', 'var')
    % Initialize the connection to the Arduino Uno on port COM3
    a = arduino('COM3', 'Uno'); 
end
% Assign the digital pin connected to the test LED
led_pin = 'D13'; 

% Print a status message to the Command Window
disp('Arduino connection established. Starting LED blink test...');
% Create a loop to make the LED blink 10 times
for i = 1:10
writeDigitalPin(a, led_pin, 1);
pause(0.5);
writeDigitalPin(a, led_pin, 0);
pause(0.5); 
    
end
% Notify the user that the loop has finished
disp('Preliminary task completed successfully!');

%% TASK 1 - READ TEMPERATURE DATA, PLOT, AND WRITE TO A LOG FILE [20 MARKS]

duration = 600; % Set total recording time to 10 minutes (600 seconds)
% Preallocate arrays for speed and memory efficiency
time_data = zeros(1, duration); 
temp_data = zeros(1, duration); 

% Define MCP9700A sensor characteristics from datasheet
v_0 = 0.5;  
t_c = 0.01; 
sensor_pin = 'A0';
disp('Data logging started. Please wait for 10 minutes...');


for t = 1:duration
    
    voltage = readVoltage(a, sensor_pin);% Read voltage from the Arduino analog pin
    
    % Convert the raw voltage to temperature in Celsius
    temperature = (voltage - v_0) / t_c;

    % Store the current time and calculated temperature in the arrays
    time_data(t) = t;
    temp_data(t) = temperature;
    
    pause(1);
    
    % Print a progress update to the console every 60 seconds (1 minute)
    if mod(t, 60) == 0
        fprintf('Progress: Logged %d minute(s)...\n', t/60);
    end
end

disp('Data acquisition completed.');

disp('Performing statistical calculations and generating plot...');

% Calculate the minimum, maximum, and average temperature over the 10 minute
min_temp = min(temp_data);
max_temp = max(temp_data);
avg_temp = mean(temp_data);

fprintf('\n--- Statistical Results Preview ---\n');
fprintf('Minimum Temperature: %.2f C\n', min_temp);
fprintf('Maximum Temperature: %.2f C\n', max_temp);
fprintf('Average Temperature: %.2f C\n', avg_temp);

figure; % Open a new figure window
% Plot the data with a blue line of thickness 1.5
plot(time_data, temp_data, 'b-', 'LineWidth', 1.5); 
title('Capsule Temperature Monitoring over 10 Minutes'); 

xlabel('Time (s)'); 

ylabel('Temperature (^{\circ}C)'); 

grid on; % Turn on the grid for better readability

disp('Plot generated successfully! Please save this plot as an image and include it in your Word template.');

disp('Formatting data and creating log file...');

current_date = datestr(now, '04/05/2026'); 
location = 'Nottingham'; 

log_text = sprintf('Data logging initiated - %s\n\nLocation - %s\n\n', current_date, location);

% Extract and format the temperature for every minute (0 to 10)
for m = 0:10
    if m == 0
        idx = 1; % Minute 0 refers to the 1st second (index 1)
    else
        idx = m * 60; % Minute 1 is 60s, Minute 2 is 120s, etc.
    end
    current_temp = temp_data(idx);
    % Append the formatted minute and temperature data to the log string
    log_text = [log_text, sprintf('Minute\t%d\tTemperature\t%.2f C\n\n', m, current_temp)];
end

% Append the statistical data to the bottom of the log string
log_text = [log_text, sprintf('Max temp\t\t%.2f C\n\n', max_temp)];
log_text = [log_text, sprintf('Min temp\t\t%.2f C\n\n', min_temp)];
log_text = [log_text, sprintf('Average temp\t%.2f C\n\n', avg_temp)];
log_text = [log_text, sprintf('Data logging terminated\n')];

% Display the final formatted string in the Command Window
disp(log_text);

% Open (or create) the text file with 'w' (write) permission
fileID = fopen('capsule_temperature.txt', 'w');

% Write the entire formatted string into the file
fprintf(fileID, '%s', log_text);

% Close the file to safely save the data
fclose(fileID);

disp('Log file "capsule_temperature.txt" created and saved successfully!');

% Re-open the file with 'r' (read) permission to check if it exists
check_fileID = fopen('capsule_temperature.txt', 'r');
if check_fileID ~= -1
    disp('File check passed: Matlab successfully opened the generated log file.');
    fclose(check_fileID); % Close it again after checking
else
    disp('Error: Could not open the log file for checking.');
end

%% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]

temp_monitor(a);


%% TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION [30 MARKS]

temp_prediction(a);

%% TASK 4 - REFLECTIVE STATEMENT [5 MARKS]

% Insert answers here