clear; close all; clc;
Fs          = 512;                %Sampling rate.
freq        = [1,40] ;                              % Frequencies (Hz).
%window      = 0.5 * Fs;                               %Window size.                 
%overlap     = floor(25/50 * window);                  %Overlap size.
num_class = 4;
elec_names = {'oz', 'o1', 'o2', 'poz', 'p7', 'p8', 'tp7', 'tp8', 'po7', 'po8'};

% plot propertiesc
plot_pos =  [1, 2, 16, 10];
Fontsize = 15;
title_Fontsize = 20;
colors = 'rgbm';

eeg_data1 = load('EEG.mat').EEG(1:10,:,:);
eeg_data2 = load('EEG1.mat').EEG(1:10,:,:);
classes1 = load('trainingVec.mat').trainingVec;
classes2 = load('trainingVec1.mat').trainingVec;

eeg_data = cat(3, eeg_data1,eeg_data2);
classes = cat(2, classes1, classes2);


class_ind = arrayfun(@(i) find(classes == i), 1:num_class, 'UniformOutput', false);
eeg_labeled = arrayfun(@(i) eeg_data(:,:,class_ind{i}), 1:num_class, 'UniformOutput', false);
eeg_labeled = random_trials(eeg_labeled, 50, Fs, 2);
% trigger_start = 512;                  % timestep to start analyzing
% trigger_end =  size(eeg_data,2)-512;    % timestep to start analyzing
elec_num = size(eeg_data,1);
trials_per_class = size(eeg_labeled{1}, 3);
[~, f] =  myFFT(squeeze(eeg_labeled{1}(1,:,1)), freq, Fs);
          
for elec = 1:elec_num
    figure('name', ['power spectrum ', elec_names{elec}], 'NumberTitle', 'off', 'units', 'centimeters',...
       'Position', plot_pos);
       sgtitle(['power spectrum density: ', elec_names{elec}], 'FontSize', title_Fontsize);
    for class = 1:num_class
       signal_fft = zeros(num_class, length(f));
       for tr = 1:trials_per_class
          [signal_fft(tr,:), f] =  myFFT(squeeze(eeg_labeled{class}(elec,:,tr)), freq, Fs);
       end 
       pwelch_mean = arrayfun(@(class) mean(signal_fft,1), 1:num_class, 'UniformOutput', false);
       pwelch_std = arrayfun(@(class) std(signal_fft,0,1), 1:num_class, 'UniformOutput', false);
    
    plot(f, pwelch_mean{class}, 'color', colors(class));
    hold on
%     fill([f'; flipud(freq')], [pwelch_mean{class}' + pwelch_std{class}';...
%        flipud(pwelch_mean{class} - pwelch_std{class})], colors(class), 'FaceAlpha', 0.5)

        
    end
    xlabel('Frequency [Hz]' ,'FontSize', Fontsize)
    ylabel('Power [dB]' ,'FontSize', Fontsize);
    legend({'15 Hz', '0 Hz', '12 Hz', '8Hz'});
end 


