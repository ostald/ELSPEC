%% Script for ElSpec_iqt usage for the 20061022 event

%% 1, Setting up the matlab-path
% Simply modify the path below to point to the directory where ELSPEC-2022
% is installed. That should be it.
addpath '.' %/home/bgu001/matlab/ELSPEC-recursive/ -end
%addpath /home/bgu001/matlab/ELSPEC-master -end    

%% 2 Setup of parameters controlling ELSPEC

% Energy grid - between 10 ad 100 keV in 400 logarithmic/exponential steps
egrid = logspace(1,5,400);

% Data directories
% The paths to the directories with the ionospheric parameters and the
% power-profiles.
% fitdir = '/urdr/data/guisdap_processed_data/arc1/bjorn/2006-10-22_arc1_1@uhf';
fitdir = '/Users/ost051/Documents/PhD/Data/2006-12-12_arc1_4@uhf'; %'/mnt/data/bjorn/EISCAT/Analysed/2006-10-22_arc1_4@uhf';
ppdir = '/Users/ost051/Documents/PhD/Data/2006-12-12_arc1_4@uhf-pp';
% Flag for specifying which EISCAT-experiment it is
experiment = 'arc1';
% Altitude-limits.
hmax = 150;
hmin = 90;
% Time-limits
btime = [2006, 12, 12, 19, 30, 0];
etime = [2006, 12, 12, 19, 35, 0];
% Selection of which ionisation-profile method to use
ionomodel = 'Sergienko';
% and which type of continuity-integration-method to use
integtype = 'integrate';
% Time-resolution to use
tres = 'best';
% Maximum order of polynomial to try. The electron-flux is calculated as an
% the product of the energy with an exponential of an n-th order polynomial:
% Ie(E) = E*exp(p_n(E))
maxorder = 5;
% ninteg set to 5, here that only means that this is the number of
% time-steps to integrate for the initial condition
ninteg = 5;
% For additional settings see the help of ElSpec, ElSpec_iqt and ElSpec_qt
%%

% Pearson-type 6 statistics assumed
ErrType = 'l'; % L for Lorentzian.
Outname = 'ElSpec-Pulsating-Aurora-L-20061022-02.mat';
disp(Outname)
ElSpecQT_20061022_L = ElSpec_iqtcl('fitdir',fitdir,...
                                   'ppdir',ppdir,...
                                   'experiment',experiment,...
                                   'hmax',hmax,'hmin',hmin,...
                                   'btime',btime,'etime',etime,...
                                   'ionomodel',ionomodel,...
                                   'integtype',integtype,...
                                   'egrid',egrid,...
                                   'tres',tres,...
                                   'ErrType',ErrType,...
                                   'MaxOrder',maxorder,...
                                   'ninteg',ninteg,... 
                                   'Outfilename',Outname);

% ElSpecPlot(ElSpecQT_20061022_L)
ElSpecPlotIeNePpRes(ElSpecQT_20061022_L)
[fnm1,fnm2,fnm3] = fileparts(ElSpecQT_20061022_L.Outfilename); 
print('-depsc','-painters',[fnm2,'-QT-l-5']);
dstr = sprintf('Done with loop S i1: %i at %s',i1,datestr(now,'HH:MM:SS'));
disp(dstr)
close(gcf)

%% Two modified plotting-functions
% In addition to ElSpecPlot, ElSpecPlot2 and ElSpecPlotSmall 2 new
% plotting-functions are added:
fig1 = figure;
ElSpecPlotIeNePpRes(ElSpecQT_iqtOutliers_L5{2},fig1.Number)
fig2 = figure;
ElSpecPlotRes(ElSpecQT_iqtOutliers_L5{2},fig2.Number)
ElSpecPlotIeNePpRes(ElSpecQT_iqtOutliers_L5{2})
ph = ElSpecPlotTres(ElSpecQT_iqtOutliers_L5{4});
set(ph,'color','r','linestyle','--','marker','.')
