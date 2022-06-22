% run BAEP experiment
% find more info to write this code on
% https://uk.mathworks.com/help/audio/gs/real-time-audio-in-matlab.html
%%% Written by Mansoureh Fahimi Hnazaee (University College London)

clear
deviceWriter = audioDeviceWriter('Driver', 'ASIO', 'SampleRate', 44100);
devices = getAudioDevices(deviceWriter);
devices_temp=devices(find(strcmp(devices,'ASIO Fireface USB')));
[BAEP_signal, trigger_signal]=generate_BAEP();
Data=zeros(2, ceil(numel(BAEP_signal)/44100)*44100);
Data(:,1:numel(BAEP_signal))=[BAEP_signal; trigger_signal];

scope=dsp.TimeScope('SampleRate',44100,'TimeSpan',2);
% reverb=reverberator()
for i=1:2:ceil(numel(BAEP_signal)/44100)
    deviceWriter(Data(:,(i-1)*44100+1:(i+1)*44100)');
end

release(deviceWriter)
release(Data)

