clear; close all; clc;
Fs          = 512;                %Sampling rate.
freq        = 1:0.1:40 ;                              % Frequencies (Hz).
window      = 0.5 * Fs;                               %Window size.                 
overlap     = floor(25/50 * window);                  %Overlap size.
num_class = 3;
%elec_names = {'oz', 'o1', 'o2', 'poz', 'p7', 'p8', 'tp7', 'tp8', 'po7', 'po8'};
%elec_names = {'O1', 'Oz', 'O2','POz'};
% plot propertiesc
plot_pos =  [1, 2, 14, 8];
Fontsize = 12;
title_Fontsize = 14;
colors = 'rgbm';

eeg_data1 = load('Sub1\EEG.mat').EEG(15,:,:);
eeg_data2 = load('Sub2\EEG.mat').EEG(15,:,:);
eeg_data3 = load('Sub3\EEG.mat').EEG(15,:,:);
classes1 = load('Sub1\trainingVec.mat').trainingVec;
classes2 = load('Sub2\trainingVec.mat').trainingVec;
classes3 = load('Sub3\trainingVec.mat').trainingVec;

eeg_data = cat(3, eeg_data1, eeg_data2, eeg_data3);
classes = cat(2, classes1, classes2, classes3);

% class_ind = arrayfun(@(i) find(classes == i), 1:num_class, 'UniformOutput', false);
% eeg_labeled = arrayfun(@(i) eeg_data(:,:,class_ind{i}), 1:num_class, 'UniformOutput', false);
% eeg_labeled = random_trials(eeg_labeled, 50, Fs, 2);
% elec_num = size(eeg_data,1);
% trials_per_class = size(eeg_labeled{1}, 3);
% [~, f] =  myFFT(squeeze(eeg_labeled{1}(1,:,1)), freq, Fs);
%           

figure('name', 'power spectrum POz', 'NumberTitle', 'off', 'units', 'centimeters',...
'Position', plot_pos);
sgtitle('POz PSD & FFT: ', 'FontSize', title_Fontsize);
subplot(2,2,1)
exec_fft(classes, num_class, eeg_data, Fs, freq, window, overlap);
hold on
title('All subjects, FFT', 'FontSize', Fontsize);

subplot(2,2,2)
exec_pwelch(classes, num_class, eeg_data, Fs, freq);
hold on
title('All subjects, PSD', 'FontSize', Fontsize);

subplot(2,2,3)
exec_fft(classes1, num_class, eeg_data1, Fs, freq, window, overlap);
hold on
title('Subject 1, FFT', 'FontSize', Fontsize);
xlabel('Frequency [Hz]' ,'FontSize', Fontsize, 'Position', [45,-1])
ylabel('Power [dB]' ,'FontSize', Fontsize, 'Position', [-2,12]);

subplot(2,2,4)
exec_pwelch(classes1, num_class, eeg_data1, Fs, freq);
hold on
title('Subject 1, PSD', 'FontSize', Fontsize);

legend({'15 Hz', '0 Hz', '8 Hz'});
 


