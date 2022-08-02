function [BAEP_signal, trigger_signal]=generate_BAEP(click_rate,  click_duration, sweeps, intensity_db, samplingFrequency, polarity)
    % Function to generate Brainstem Auditory Evoked Potentials for use in
    % Auditory experiments. Inputs can be user-defined or default values
    % can be used. Best used with an external audio card for best sound
    % quality
    % Inputs: click rate, click tone duration, number of trials (sweeps),
    % sound amplitude (intensity_db), internal sampling frequency of the
    % sound card (samplingFrequency), type of click tone (either alternating polarity, rarefaction or condensation)
    % Outputs: audio signal (BAEP_signal), signal to send triggers to EEG
    % acquisition system (trigger_signal)
    % Parameters taken from: Recommended Procedure Auditory Brainstem Response (ABR) testing for post Newborn and Adult
    % By British Society of Audiology (kindly provided by Dr. Guy Lightfoot)
    %%%% Written by Mansoureh Fahimi Hnazaee (University College London)
    %%%%

    if nargin<1
       click_rate=11.1; 
    end

    % around 1.5 minutes per 1000 sweeps with a click rate of 11.1
    % around 24 minutes per 1000 sweeps with a click rate of 0.7
    if nargin<2
        click_duration=0.0001;
        sweeps=4000;
        intensity_db=1;
        samplingFrequency=44100; % This sampling rate means our click duration will not be exaclty 100us, but that is not a big problem
        polarity='alternate'; 
    
    end
    
    time_total=0: 1/samplingFrequency : ((sweeps+10)/click_rate); % add in enough time for a few extra sweeps so you can start the sweeps later
    time_click=0: 1/samplingFrequency : 1/click_rate;
    MyClick=zeros(1, numel(time_click));
    MyClick(1:round(click_duration*samplingFrequency))=intensity_db;

    BAEP_signal=zeros(1,numel(time_total));
    trigger_signal=BAEP_signal;

    switch polarity
        case 'alternate'
            for i=1:sweeps
               if mod(i,2)==1
                   BAEP_signal((i+1)*numel(time_click)+1:(i+2)*numel(time_click))= MyClick;
%                BAEP_signal((i+1)*numel(time_click)+1+round(click_duration*samplingFrequency):(i+2)*numel(time_click)+round(click_duration*samplingFrequency))= -MyClick;
               else
                   BAEP_signal((i+1)*numel(time_click)+1:(i+2)*numel(time_click))= -MyClick;
               end
            end
            BAEP_signal=BAEP_signal(1:numel(time_total));
        case 'condensation'
            for i=1:sweeps 
               BAEP_signal((i+1)*numel(time_click)+1:(i+2)*numel(time_click))= -MyClick;
            end
            BAEP_signal=BAEP_signal(1:numel(time_total));
        case 'rarefaction' 
            for i=1:sweeps
               BAEP_signal((i+1)*numel(time_click)+1:(i+2)*numel(time_click))= MyClick;
            end
            BAEP_signal=BAEP_signal(1:numel(time_total));
    end
    
    % On Jonas's suggestion, triggers happen 50ms before trial onset
    % question: will one single value be enough to trigger the EEG
    % aquisition system?
    for i=1:sweeps
        trigger_signal((i+1)*numel(time_click)+1-0.05*samplingFrequency)=1;
    end

   

    % lot's of extra stuff in there that I wrote for debugging purposes,
    % not relevant for our paradigm
%     trigger_onset_samples=abs(BAEP_signal);
%     trigger_onset_samples=zeros(1,numel(time_total));
%     for i=1:2:sweeps
%        trigger_onset_samples((i-1)*numel(time_click)+1:i*numel(time_click))= -MyClick;
%     end
%     trigger_onset_samples=trigger_onset_samples(1:numel(time_total));
%     BAEP_signal=trigger_onset_samples;
% 
%     trigger_onset_samples=zeros(1,numel(time_total));
%     for i=1:3:sweeps
%        trigger_onset_samples((i-1)*numel(time_click)+1:i*numel(time_click))= -MyClick;
%     end
%     trigger_onset_samples=trigger_onset_samples(1:numel(time_total));
% 
% 
%     trigger_onset_samples2=zeros(1,numel(time_total));
%     for i=1:11:sweeps
%        trigger_onset_samples2((i-1)*numel(time_click)+1:i*numel(time_click))= -MyClick;
%     end
%     trigger_onset_samples2=trigger_onset_samples2(1:numel(time_total));
    
    
    

end