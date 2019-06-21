%NPRR processing
%Kekeru

%Import consolidated imaging file (xlsx)
basepath = '';
filename = '';
sheetname = '';


rawdata  = xlsread(filename, sheetname);

convert_stimulation;
stim = stim_time_matrix;



% Define timestamp stepsize
num_of_frame = size(rawdata,1);
time_total = rawdata(size(rawdata,1),1);
stepsize = time_total/num_of_frame;

% Create sample data as column vectors.
time = [];
time = rawdata(: , 1);
Fdata = rawdata(:, 2:size(rawdata,2));


% Reshape to get the background matrix
size_BG_1 = floor(stim(1,1)/stepsize);
size_BG_2 = size(Fdata,2);

BG = mean(Fdata(1:size_BG_1,1:size_BG_2));

BG = repmat(BG, [size(Fdata,1) 1]);


data = (Fdata-BG)./BG;

data_average = mean(data,2);
data_sem = std(data,[],2)/sqrt(size(data,2)); 

data_upper = data_average  + data_sem;
data_lower = data_average  - data_sem;

smooth_data_average = smooth(data_average);

%acquisition of peak heights within each stimulation period
max_matrix = [];
for i = 1:size(stim_time_matrix,1)
    stim_idx = find(time<stim_time_matrix(i,2) & time >stim_time_matrix(i,1))
    in_stim_max = max(data_average(stim_idx))
    max_matrix = [max_matrix; in_stim_max];
end

%half_life_recovery calculation by invoking function "half_recovery_time"
 half_life_calculation (data_average);

% Plot 
figure(1);

%Set parameters for plotting. 
UP_BOUND =  2;
LOW_BOUND  = -0.4; 
edg = min(data_average)*0.01;

plot(time,data_upper, 'color',[1,0.4,0.4,0.], 'LineWidth', 1);

xlim([0,max(time)]);
ylim([LOW_BOUND, UP_BOUND]);
hold on;
for i = 1:size(stim,1)
    if i >1
        rectangle('Position',[stim(i,1),LOW_BOUND+3*edg, stim(i,2)-stim(i,1),UP_BOUND - LOW_BOUND-edg*2], 'FaceColor',[1,0.6,0.6,0.1*i], 'Edgecolor', [1,0.8,0.4,0.],'LineWidth', 0.01);
    else
        rectangle('Position',[stim(i,1),LOW_BOUND+3*edg, stim(i,2)-stim(i,1),UP_BOUND - LOW_BOUND-edg*2], 'FaceColor',[1,0.6,0.6,0.1], 'Edgecolor', [1,0.8,0.4,0.],'LineWidth', 0.01);
    end
end
plot(time,data_upper, 'color',[1,0.4,0.4,0.], 'LineWidth', 1);

plot(time, data_lower, 'color',[1,0.4,0.4,0.],'LineWidth', 1);

patch([time;flipud(time)],[data_upper; flipud(data_lower)],'k','FaceA',.3,'EdgeA',0);

plot(time, data_average, 'g', 'LineWidth', 1.5);
plot(time,0*ones(size(time)),'--','color', [.15,.15,.15])
%title ([genotype '  GCaMP6s Region ' sheetname]);
%title ([genotype]) % '  Rep #' num_rep]);
xlabel('Time (s)');
ylabel('\DeltaF/F');
%ylim([-0.4 1]);
box off;
hold off;

