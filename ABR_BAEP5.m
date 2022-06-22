clear
deviceWriter = audioDeviceWriter('Driver', 'ASIO', 'SampleRate', 44100);
devices = getAudioDevices(deviceWriter);
devices_temp=devices(find(strcmp(devices,'ASIO Fireface USB')));
[sig1, sig2, sig3]=generate_BAEP();
Data=[sig1;sig2;sig3];

scope=dsp.TimeScope('SampleRate',44100,'TimeSpan',2);
% reverb=reverberator()
for i=1:2:180
    deviceWriter(Data(:,(i-1)*44100+1:(i+1)*44100)')
end

release(deviceWriter)
release(Data)

% find more info to write this code on
% https://uk.mathworks.com/help/audio/gs/real-time-audio-in-matlab.html