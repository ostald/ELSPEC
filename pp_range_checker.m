function [h_starts,h_ends] = pp_range_checker(data_files)

for i_file = numel(data_files):-1:1
  load(data_files{i_file});
  i_end = [find(diff(r_pprange)<0);numel(r_pprange)];% Should give all ends also the last one? BG-20221004
  i_start = [0; i_end(1:end-1)]+1;
  h_starts(i_file,1:numel(i_start)) = r_pprange(i_start);
  h_ends(i_file,1:numel(i_end)) = r_pprange(i_end);
end