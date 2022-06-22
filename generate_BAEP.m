function [BAEP_signal, trigger_onset_samples, trigger_onset_samples2]=generate_BAEP(click_rate,  click_duration, sweeps, intensity_db, samplingFrequency, polarity)
    
    if nargin<1
        click_rate=11.1;
        click_duration=0.0001;
        sweeps=2000;
        intensity_db=1;
        samplingFrequency=44100; % not a problem yay!
        polarity='alternate'; 
    
    end
    
    time_total=0: 1/samplingFrequency : (sweeps/click_rate);
    time_click=0: 1/samplingFrequency : 1/click_rate;
    MyClick=zeros(1, numel(time_click));
    MyClick(1:round(click_duration*samplingFrequency))=intensity_db;

    BAEP_signal=zeros(1,numel(time_total));

    switch polarity
        case 'alternate'
            for i=1:sweeps % not this! one after the other
               BAEP_signal((i-1)*numel(time_click)+1:i*numel(time_click))= MyClick;
               BAEP_signal((i-1)*numel(time_click)+1+round(click_duration*samplingFrequency):(i)*numel(time_click)+round(click_duration*samplingFrequency))= -MyClick;
            end
            BAEP_signal=BAEP_signal(1:numel(time_total));
        case 'condensation'
            for i=1:sweeps
               BAEP_signal((i-1)*numel(time_click)+1:i*numel(time_click))= -MyClick;
            end
            BAEP_signal=BAEP_signal(1:numel(time_total));
        case 'rarefaction' 
            for i=1:sweeps
               BAEP_signal((i-1)*numel(time_click)+1:i*numel(time_click))= MyClick;
            end
            BAEP_signal=BAEP_signal(1:numel(time_total));
    end

   
%     trigger_onset_samples=abs(BAEP_signal);
    trigger_onset_samples=zeros(1,numel(time_total));
    for i=1:2:sweeps
       trigger_onset_samples((i-1)*numel(time_click)+1:i*numel(time_click))= -MyClick;
    end
    trigger_onset_samples=trigger_onset_samples(1:numel(time_total));
    BAEP_signal=trigger_onset_samples;

    trigger_onset_samples=zeros(1,numel(time_total));
    for i=1:3:sweeps
       trigger_onset_samples((i-1)*numel(time_click)+1:i*numel(time_click))= -MyClick;
    end
    trigger_onset_samples=trigger_onset_samples(1:numel(time_total));


    trigger_onset_samples2=zeros(1,numel(time_total));
    for i=1:11:sweeps
       trigger_onset_samples2((i-1)*numel(time_click)+1:i*numel(time_click))= -MyClick;
    end
    trigger_onset_samples2=trigger_onset_samples2(1:numel(time_total));
    
    
    

end