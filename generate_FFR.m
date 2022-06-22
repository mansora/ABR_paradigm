function [FFR_wave, trial_onset_samples]=generate_FFR(freq_modulate, polarity, intensity_db, trial_duration, rise_fall_time, n_trials, samplingFrequency)

    if nargin<3
        intensity_db=      1;
        trial_duration=    0.2;
        rise_fall_time=    0.05;   %0.05
        SOA_time_mean=     0.253;
        samplingFrequency= 44100;
        n_trials=          475;  %475
    end

    % r = a + (b-a).*rand(N,1)
    jitter=round(-12 + (12-(-12)).*rand(1,n_trials))/1000;
    SOA_jittered=SOA_time_mean+jitter;
    trial_onset_times=cumsum(SOA_jittered);


    Fs=samplingFrequency;
    fa=freq_modulate; % Frequency of modulating signal
    t = 0: 1/Fs : trial_duration; 
   
    y=polarity*intensity_db*sin(2*pi*fa*t); % Equation of Amplitude
    y(1:dsearchn(t',rise_fall_time))=linspace(0,1,dsearchn(t',rise_fall_time));
    y(dsearchn(t',trial_duration)-dsearchn(t',rise_fall_time)+1:end)=linspace(1,0,dsearchn(t',rise_fall_time));

%     figure, plot(t,y)
    t_total = 0: 1/Fs : trial_onset_times(end)+2*trial_duration;
    temp_samples=dsearchn(t_total',trial_onset_times');
    FFR_wave=zeros(1,length(t_total));
    trial_onset_samples=FFR_wave;
    trial_onset_samples(temp_samples)=1;

    for i=1:length(temp_samples)
        FFR_wave(temp_samples(i):temp_samples(i)+length(y)-1)=y;
    end
    
%     figure, plot(t_total,FFR_wave)


end