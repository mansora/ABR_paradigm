function t2=run_BAEP(nrchannels, clickrate)
% run BAEP experiment
% find more info to write this code on
% https://uk.mathworks.com/help/audio/gs/real-time-audio-in-matlab.html
%%% Written by Mansoureh Fahimi Hnazaee (University College London)

%     clear
    deviceWriter = audioDeviceWriter('Driver', 'ASIO', 'SampleRate', 44100);
    devices = getAudioDevices(deviceWriter);
    devices_temp=devices(find(strcmp(devices,'ASIO Fireface USB')));
    [BAEP_signal, trigger_signal]=generate_BAEP(clickrate);
    
    if nrchannels==2
        Data=zeros(2, ceil(numel(BAEP_signal)/44100)*44100);
        Data(:,1:numel(BAEP_signal))=[BAEP_signal; trigger_signal];
    elseif nrchannels==3
        Data=zeros(3, ceil(numel(BAEP_signal)/44100)*44100);
        Data(:,1:numel(BAEP_signal))=[BAEP_signal; BAEP_signal; trigger_signal];
    end
        
%     scope=dsp.TimeScope('SampleRate',44100,'TimeSpan',2);
    % reverb=reverberator()
    
    disp('Starting Audio...')
    disp(['Brainstem Auditory Evoked Response Task. Click rate=', num2str(clickrate)])
    tic
    if mod(ceil(numel(BAEP_signal)/44100),2)==1
        for i=[1:2:ceil(numel(BAEP_signal)/44100)-1, ceil(numel(BAEP_signal)/44100)-1]
            deviceWriter(Data(:,(i-1)*44100+1:(i+1)*44100)');
        end
    else
        for i=1:2:ceil(numel(BAEP_signal)/44100)-1
            deviceWriter(Data(:,(i-1)*44100+1:(i+1)*44100)');
        end
    end
    disp('Audio stopped')
    t2=toc; 
    
    release(deviceWriter)
    % release(Data)

end

