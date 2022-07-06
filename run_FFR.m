function t2=run_FFR(nrchannels, freq_modulate)
% run FFR experiment
% find more info to write this code on
% https://uk.mathworks.com/help/audio/gs/real-time-audio-in-matlab.html
%%% Written by Mansoureh Fahimi Hnazaee (University College London)


%     clear
    deviceWriter = audioDeviceWriter('Driver', 'ASIO', 'SampleRate', 44100);
    devices = getAudioDevices(deviceWriter);
    devices_temp=devices(find(strcmp(devices,'ASIO Fireface USB')));
    [FFR_signal, trigger_signal]=generate_FFR(freq_modulate);
    
    if nrchannels==2
        Data=zeros(2, ceil(numel(FFR_signal)/44100)*44100);
        Data(:,1:numel(FFR_signal))=[FFR_signal; trigger_signal];
    elseif nrchannels==3
        Data=zeros(3, ceil(numel(FFR_signal)/44100)*44100);
        Data(:,1:numel(FFR_signal))=[FFR_signal; FFR_signal; trigger_signal];
    end
    
    
%     scope=dsp.TimeScope('SampleRate',44100,'TimeSpan',2);
    % reverb=reverberator()
    
    disp('Starting Audio...')
    disp(['Frequency Following Responses Task. Modulation Frequency=', num2str(freq_modulate)])
    tic
    if mod(ceil(numel(FFR_signal)/44100),2)==1
        for i=[1:2:ceil(numel(FFR_signal)/44100)-1, ceil(numel(FFR_signal)/44100)-1]
            deviceWriter(Data(:,(i-1)*44100+1:(i+1)*44100)');
        end
    else
        for i=1:2:ceil(numel(FFR_signal)/44100)-1
            deviceWriter(Data(:,(i-1)*44100+1:(i+1)*44100)');
        end
    end
    disp('Audio stopped')
    t2=toc; 

    release(deviceWriter)
    % release(Data)

end