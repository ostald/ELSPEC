function [h,ts,te,pp,ppstd,azel,loc,I] = guisdap_beata_pp_reader(matfiles,time_limits)
% [h,t1,t2,pp,pp_err] = guisdap_beata_pp_reader(mat_files)

%
% Example,
%   q = dir('/dir/Dir/*.mat');
%   q = dir('./*.mat');
%   q = dir('../dir/05*.mat');
%   OK = guisdap_param2ascii_thne(q([1 3 6:8]),'test.dat');
%   

% if time_limits given then sort out the guisdap-mat-files that have data
% inside the start and end-times. This works with multiple time-periods,
% perhaps even with overlapping in time.
if isstruct(matfiles)
  mat_files = {matfiles.name};
else
  mat_files = listGUISDAPfiles(matfiles);
end
if nargin > 1
  
  %StrMat_w_t = char(mat_files);
  %StrMat_w_t = StrMat_w_t(:,1:end-4);
  for i1 = numel(mat_files):-1:1
    [~,StrMat_w_t(i1,:)] = fileparts(mat_files{i1});   
  end
  data_times = str2num(StrMat_w_t);
  [t_start_stop] = tosecs(time_limits);
  idxInRange = [];
  for iR = 1:2:length(t_start_stop)
    idxInRange = [idxInRange(:);...
                  find(t_start_stop(iR) <= data_times & ...
                                           data_times <= t_start_stop(iR+1))];
  end
  mat_files = mat_files(idxInRange);
end



%pp = [];
%pp_err = [];
%t = [];
%t1 = [];
%t2 = [];
%h = [];
i1 = 1;

n_files = numel(mat_files);

% load(mat_files(i1).name,'r_time','r_pp','r_pperr','r_pprange','r_h','r_range');
%load(mat_files(i1).name,'r_pprange','r_XMITloc');
load(mat_files{i1},'r_pprange','r_XMITloc');
loc = r_XMITloc;


i_ends = [find(diff(r_pprange)<0);numel(r_pprange)];
i_starts = [1;i_ends(1:end-1)+1];

%di_s2e = diff(unique(i_ends-i_starts));
%i_lims = min(unique(i_ends-i_starts)) - di_s2e(1)/2 + ...
%         cumsum([0;di_s2e;di_s2e(end)]);
i_lims = sort([unique(i_ends-i_starts)-0.1;unique(i_ends-i_starts)+0.1]);
[h1,~,h3] = histcounts(i_ends-i_starts,i_lims);
[n_pp_profs,idx_max] = max(h1);
idx2use = find(h3==idx_max);
n_z = i_ends(idx2use(1)) - i_starts(idx2use(1)) + 1;

pp = zeros(n_z,n_pp_profs*n_files);
ppstd = pp;
h = pp;
ts = zeros(n_pp_profs*n_files,1);
te = ts;
azel = NaN(n_pp_profs*n_files,2);
%T1 = r_time(1,:);
%T2 = r_time(2,:);
%T1 = T1(4) + T1(5)/60 + T1(6)/3600;
%T2 = T2(4) + T2(5)/60 + T2(6)/3600;

for i1 = 1:length(mat_files)
  
  % load(mat_files(i1).name,...
  load(mat_files{i1},...
       'r_time','r_pp','r_pperr','r_pprange','r_h','r_range','r_az','r_el')
  
  i_ends = [find(diff(r_pprange)<0);numel(r_pprange)];
  i_starts = [1;i_ends(1:end-1)+1];
  
  %di_s2e = diff(unique(i_ends-i_starts));
  %i_lims = min(unique(i_ends-i_starts)) - di_s2e(1)/2 + ...
  %         cumsum([0;di_s2e;di_s2e(end)]);
  i_lims = sort([unique(i_ends-i_starts)-0.1;unique(i_ends-i_starts)+0.1]);
  [h1,~,h3] = histcounts(i_ends-i_starts,i_lims);
  [n_pp_profs,idx_max] = max(h1);
  idx2use = find(h3==idx_max);
  %T1 = r_time(1,:);
  %T2 = r_time(2,:);
  %T1 = T1(4) + T1(5)/60 + T1(6)/3600;
  %T2 = T2(4) + T2(5)/60 + T2(6)/3600;
  T1 = date2unixtime(r_time(1,:));
  T2 = date2unixtime(r_time(2,:));
  t_curr = linspace(T1,T2,n_pp_profs+1);
  t1_c = t_curr(1:end-1);
  t2_c = t_curr(2:end);
  %keyboard
  for i_pp = 1:numel(idx2use)
    i4rhs = idx2use(i_pp);
    pp(:,i_pp + n_pp_profs*(i1-1)) = r_pp(i_starts(i4rhs):i_ends(i4rhs));
    try
      ppstd(:,i_pp + n_pp_profs*(i1-1)) = r_pperr(i_starts(i4rhs):i_ends(i4rhs));
    catch
    end
    h(:,i_pp + n_pp_profs*(i1-1)) = r_pprange(i_starts(i4rhs):i_ends(i4rhs)).*sind(r_el); %...
                                    %interp1(r_range,...
                                    %        r_h./r_range,...
                                    %        r_pprange(i_starts(i4rhs):i_ends(i4rhs)),...
                                    %        'linear','extrap');
                               
    %t1(i_pp + n_pp_profs*(i1-1)) = t1_c(i4rhs-idx2use(1)+1);
    %t2(i_pp + n_pp_profs*(i1-1)) = t2_c(i4rhs-idx2use(1)+1);
    ts(i_pp + n_pp_profs*(i1-1)) = t1_c(i_pp);
    te(i_pp + n_pp_profs*(i1-1)) = t2_c(i_pp);
    azel(i_pp + n_pp_profs*(i1-1),:) = [r_az r_el];
  end
  
end
I = [];
function [fpaths] = listGUISDAPfiles( ddir )
% Return list of .mat-files profduced by GUISDAP
% 
% Copyright I Virtanen <ilkka.i.virtanen@oulu.fi> and B Gustavsson <bjorn.gustavsson@uit.no>
% This is free software, licensed under GNU GPL version 2 or later


% list mat files
ff = dir( fullfile( ddir , '*.mat') );
% GUISDAP output files have 8 digits and '.mat' in file name.
% The digits are seconds since beginning of year, so they are
% necessarily between 0 and 366*24*60*60=31622400
for k=length(ff):-1:1 % we will be removing elements, must go backwards
    if length(ff(k).name)~=12
        ff(k) = [];
    % str2num returns an empty matrix if its argument does not
    % represent a number
    elseif isempty( str2num(ff(k).name(1:8)) )
        ff(k) = [];
    % the number is seconds from beginning of the year and must
    % thus be larger than zero and smaller than 366*24*60*60
    elseif ( str2num(ff(k).name(1:8)) < 0 ) || ...
           ( str2num(ff(k).name(1:8)) > 31622400 )
        ff(k) = [];
    end
end

fpaths=cell(0);
% if nothing was left
if isempty(ff)
    return;
end

% full paths to data files
for k=1:length(ff)
    fpaths{k} = fullfile( ddir , ff(k).name );
end


function [unix_time] = date2unixtime(utc_date)
%
% date2unixtime convert utc date into unix time 
% (seconds since 1970-01-01 00:00:00 UTC)
%
% unix_time = date2unixtime(utc_date)
%
% IV 2016
%
% Copyright I Virtanen <ilkka.i.virtanen@oulu.fi>
% This is free software, licensed under GNU GPL version 2 or later

unix0 = datenum(1970,01,01); %Start time of unix time as matlab datenum
unixday = datenum(utc_date(1),utc_date(2),utc_date(3)); % matlab datenum of utc_date

unix_time = 60 * ( 60 * ( 24 * ( unixday - unix0 ) + utc_date(4) ) ...
                   + utc_date(5) ) + utc_date(6);



function [unix_time]=date2unix0(utc_date)

year = utc_date(1);
month = utc_date(2);
day = utc_date(3);
hour = utc_date(4);
minute = utc_date(5);
second = utc_date(6);
Specify day 0 
number_of_day_before_day_one=datenum(1970,01,00); %Start time of
                                                  %unix time
absolute_number_of_day=datenum(year,month,day); %Default day one for datenum is january 1st of year 0
julian_day=absolute_number_of_day - number_of_day_before_day_one; %Number of day since day one

seconds_of_day = 3600*hour+60*minute+second;
unix_time = seconds_of_day + 24*3600*julian_day;
