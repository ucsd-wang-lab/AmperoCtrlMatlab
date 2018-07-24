%%%%%	General Settings
COM10	% COM port
btspp://544A165E2B9F	%device ID (not used)
flex01	% device ID (ring01, ring02, flex01, etc.)
-----	-----------------------
%%%%%	SWV
50	% Initial wait time (10ms) (max 0xFFFF)
10	% Frequency (Hz)
-400	% Initial voltage (mV)
-1200	% Final voltage (mV)
25	% Amplitude (mV)
4	% Step (mV)
1800	% Offset voltage (mV)
-----	-----------------------
%%%%%	Chronoamperometry
15	% measurement points
200	% period (ms)
1000	% offset voltage (mV)
-200	% potential (mV)
10	% running average points (set 1 for raw data without averaging)
-----	-----------------------
%%%%%	Hardware paremeters
4300	% Vref (mV)
12	% ADC resolution (bits)
468	% Transimpedance gain (kOhm) (ring=18kOhm, flex01=100kOhm)
-----	-----------------------
