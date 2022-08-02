function [FFR_signal, trigger_signal]=generate_FFR(freq_modulate, intensity_db, trial_duration, rise_fall_time, n_trials, samplingFrequency)
    % Function to generate Frequency Following Responses for use in
    % Auditory experiments. Inputs can be user-defined or default values
    % can be used. Best used with an external audio card for best sound
    % quality
    % Inputs: 
    % sound amplitude (intensity_db), duration of each trial, rise and fall
    % time per trial, mean value of stimulus onset asynchrony (SOA_time_mean)
    % internal sampling frequency of the
    % sound card (samplingFrequency), number of trials
    % Outputs: audio signal (FFR_signal), signal to send triggers to EEG
    % acquisition system (trigger_signal)
    % parameters are taken from publication: 
    % "Neural generators of the frequency following response elicited to stimuli of low and high frequency: A magnetoencephalographic study"
    % By Gorina-Careta et al.
    %%%% Written by Mansoureh Fahimi Hnazaee (University College London)
    %%%%

    % 1500 sweeps total takes about 8 minutes for a modulation frequency of
    % 333Hz
    if nargin<3
        intensity_db=      1;
        trial_duration=    0.2;
        rise_fall_time=    0.05;   %0.05
        SOA_time_mean=     0.253;
        samplingFrequency= 44100;
        n_trials=          1500;  %950 in each polarity
    end

    % r = a + (b-a).*rand(N,1)
    jitter=round(-12 + (12-(-12)).*rand(1,n_trials))/1000; % create random jitter between -12 and 12ms
    SOA_jittered=SOA_time_mean+jitter; % SOA of trials varies between 241 and 265ms, which give a mean of 253ms SOA and +-12ms jitter
    trial_onset_times=cumsum(SOA_jittered); % onset of each trial defined in ms


    Fs=samplingFrequency; % internal sampling rate of the audio card, defaults to 44100Hz 
    fa=freq_modulate; % Frequency of modulating signal
    t = 0: 1/Fs : trial_duration; 
   
    % generate first half of trials with postivive polarity
    polarity=1;
    y1=polarity*intensity_db*sin(2*pi*fa*t); % Equation of Amplitude
    y1(1:dsearchn(t',rise_fall_time))=linspace(0,1,dsearchn(t',rise_fall_time));
    y1(dsearchn(t',trial_duration)-dsearchn(t',rise_fall_time)+1:end)=linspace(1,0,dsearchn(t',rise_fall_time));

    % generate second half of trials with negative polarity
    polarity=-1;
    y2=polarity*intensity_db*sin(2*pi*fa*t); % Equation of Amplitude
    y2(1:dsearchn(t',rise_fall_time))=linspace(0,1,dsearchn(t',rise_fall_time));
    y2(dsearchn(t',trial_duration)-dsearchn(t',rise_fall_time)+1:end)=linspace(1,0,dsearchn(t',rise_fall_time));

%     figure, plot(t,y)
    t_total = 0: 1/Fs : trial_onset_times(end)+2*trial_duration;
    temp_samples=dsearchn(t_total',trial_onset_times');
    FFR_signal=zeros(1,length(t_total));

    % this signal indicates onset of each trial defined in samples, could be useful at some point (for debugging purposes)
%     trial_onset_samples=FFR_signal;
%     trial_onset_samples(temp_samples)=1; 

    % On Jonas's suggestion, triggers happen 50ms before trial onset
    % question: will one single value be enough to trigger the EEG
    % aquisition system?
    trigger_signal=FFR_signal;
    trigger_signal(temp_samples-0.05*samplingFrequency)=1;


    for i=1:length(temp_samples)
        if i<=length(temp_samples)/2
            FFR_signal(temp_samples(i):temp_samples(i)+length(y1)-1)=y1;
        else
            FFR_signal(temp_samples(i):temp_samples(i)+length(y2)-1)=y2;
        end
    end
    
%     figure, plot(t_total,FFR_wave)


end