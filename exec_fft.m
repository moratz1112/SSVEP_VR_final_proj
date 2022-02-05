function [signal_fft , f] = exec_fft(classes, num_class, eeg_data, Fs, freq, window, overlap)
    colors = 'rgbm';

    class_ind = arrayfun(@(i) find(classes == i), 1:num_class, 'UniformOutput', false);
    eeg_labeled = arrayfun(@(i) eeg_data(:,:,class_ind{i}), 1:num_class, 'UniformOutput', false);
    eeg_labeled = random_trials(eeg_labeled, 50, Fs, 2);
    % trigger_start = 512;                  % timestep to start analyzing
    % trigger_end =  size(eeg_data,2)-512;    % timestep to start analyzing
    trials_per_class = size(eeg_labeled{1}, 3);
    [~, f] =  myFFT(squeeze(eeg_labeled{1}(1,:,1)), freq, Fs);
    
    for class = 1:num_class
        for tr = 1:trials_per_class
        %  [signal_fft(tr,:), f] =  myFFT(squeeze(eeg_labeled{class}(elec,:,tr)), [1,40], Fs);
           [signal_fft(tr,:)] =  pwelch(squeeze(eeg_labeled{class}(1,:,tr)), window, overlap, freq, Fs);
        end 
        pwelch_mean = arrayfun(@(class) mean(signal_fft,1), 1:num_class, 'UniformOutput', false);
        %pwelch_std = arrayfun(@(class) std(signal_fft,0,1), 1:num_class, 'UniformOutput', false);
        plot(freq, pwelch_mean{class}, 'color', colors(class));
        %plot(f, pwelch_mean{class}, 'color', colors(class));
        hold on
    end