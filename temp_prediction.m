function temp_prediction(a)
% TEMP_PREDICTION Live temperature prediction and trend-based LED warning.
% This function reads capsule temperature (A0) every second.
% It calculates the rate of change (dT/dt) over a 5-second buffer 
% to smooth sensor noise, and predicts the temperature 5 minutes ahead.
% LEDs are activated based on rate: Red for >+4C/min, Yellow for <-4C/min,
% and Green for a stable temperature.