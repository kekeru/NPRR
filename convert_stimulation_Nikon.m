
% Import stimulation profile from Nikon Microscope (See details in
% Materials and Methods)

basepath = '';
filename_stim = '';
rawdata_stim  = readtable(filename_stim);

start_matrix = [];
end_matrix = [];
for i = 1:size(rawdata_stim,1)
    if (isequal(rawdata_stim.Events(i),{'User 1 : Pulse'})==1 && isequal(rawdata_stim.Events(i+1),{'User 1 : Pulse'})==0 && isequal(rawdata_stim.Events(i+2),{'User 1 : Pulse'})==0 && isequal(rawdata_stim.Events(i+3),{'User 1 : Pulse'})==0)
        end_matrix = [end_matrix,i];      
    end
    if (isequal(rawdata_stim.Events(i),{'User 1 : Pulse'})==1 && isequal(rawdata_stim.Events(i-1),{'User 1 : Pulse'})==0 && isequal(rawdata_stim.Events(i-2),{'User 1 : Pulse'})==0 && isequal(rawdata_stim.Events(i-3),{'User 1 : Pulse'})==0)
         start_matrix = [start_matrix,i]; 
    end
end

stim_matrix = [start_matrix; end_matrix];
stim_time_matrix = rawdata_stim.Time_s_(stim_matrix)';
     
