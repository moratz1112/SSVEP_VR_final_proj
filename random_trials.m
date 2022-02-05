function [newsig] = random_trials(signal, num_new_trails, Fs, duration)
    num_class = length(signal);
    duration = Fs * duration;
    signal_len = size(signal{1}, 2);
    trials_per_class = size(signal{1},3);
    sec_to_take = randperm(signal_len-duration, num_new_trails);
    elec_num = size(signal{1},1);
    newsig = cellfun(@(x) zeros(elec_num, duration, trials_per_class* num_new_trails), cell(1,num_class), 'un', 0);    
    
    for class = 1:num_class
        for trial = 1:trials_per_class
            for time = 1:num_new_trails
                index = (trial-1) * num_new_trails + time;
                newsig{class}(:,:,index) = signal{class}(:, sec_to_take(time):sec_to_take(time) + duration-1, trial);
            end
        end
    end
    
end