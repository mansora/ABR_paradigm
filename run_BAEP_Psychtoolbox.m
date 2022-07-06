function t2=run_BAEP_Psychtoolbox(click_rate)
    % PsychPortAudio('GetDevices')

    AssertOpenGL;
    defaultPriority = Priority(1);
    
	try

        
                  
        %---------------
        % Sound Setup
        %---------------
    
        % Initialize Sounddriver
        InitializePsychSound(1);
    
        % Number of channels and Frequency of the sound
        samplingFrequency = 44100;
    
        % How many times to we wish to play the sound
        repetitions = 1  ;
    
        % Start immediately (0 = immediately)
        startCue = 0;
    
        % Should we wait for the device to really start (1 = yes)
        % INFO: See help PsychPortAudio
        waitForDeviceStart =  1;
    
        % Open Psych-Audio port, with the follow arguements
        % (1) [] = default sound device
        % (2) 1 = sound playback only
        % (3) 1 = default level of latency
        % (4) Requested frequency in samples per second
        % (5) 2 = stereo putput
        devId =61; %6; %28; %50;%44;
        latencyClass = 3; % Aggressive
        mode=9;
        nrchannels=2;
        audioDevice = PsychPortAudio('Open', devId, mode, latencyClass, samplingFrequency, nrchannels);
        
    
        % Set the volume to half for this demo
        PsychPortAudio('Volume', audioDevice, 1);
    
       
        % Start the device immediately -> the slave will handle audio start
        PsychPortAudio('Start', audioDevice);
        audioSlave = PsychPortAudio('OpenSlave', audioDevice, 1);

        [BAEP_signal, trigger_signal]=generate_BAEP(click_rate);

        stimulus=[BAEP_signal;trigger_signal];
        PsychPortAudio('Volume', audioSlave, 1, [0.1, 0.1]);

        % Create the next buffer
        currentBuffer = PsychPortAudio('CreateBuffer', audioSlave, stimulus);
            
        % Fill the buffer
        PsychPortAudio('FillBuffer', audioSlave, currentBuffer);

        tic
        disp('Starting Audio...')
        disp(['Brainstem Auditory Evoked Response Task. Click rate=', num2str(clickrate)])
        % Start audio playback #1
        PsychPortAudio('Start', audioSlave, repetitions, startCue, waitForDeviceStart);
    
        % Wait for audio end
           s = PsychPortAudio('GetStatus', audioSlave);
        while s.Active
            s = PsychPortAudio('GetStatus', audioSlave);
    %             if mod(s.ElapsedOutSamples,samplingFrequency*epochLength)==0
    %                logThis( '%s, \r\n  epoch index ->',s.ElapsedOutSamples/(samplingFrequency*epochLength));
    %                disp(num2str(s.ElapsedOutSamples))
    %             end
        end
        disp('Audio stopped')   
                               
        t2=toc; 

        PsychPortAudio('Close')
        Priority(defaultPriority);
   
    catch
        Priority(defaultPriority);
		psychrethrow( psychlasterror );
    end

end




