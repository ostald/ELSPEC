%% Example-script for ElSpec_iqt usage
% This script should be possible to adapt for anyone with basic skills in
% matlab-usage. This test runs the ElSpec_iqt and ElSpec_qt functions
% testing the outlier-resilience with Pearson-type 6 statistics for the
% electron-density-estimates

%% 1, Setting up the matlab-path
% Simply modify the path below to point to the directory where ELSPEC-2022
% is installed. That should be it.
addpath /bigdata/Campaigns/ELSPEC-2022 -end

%% 2 Setup of parameters controlling ELSPEC

% Energy grid - between 10 ad 100 keV in 400 logarithmic/exponential steps
egrid = logspace(1,5,400);

% Data directories
% The paths to the directories with the ionospheric parameters and the
% power-profiles.
fitdirUM = '/media/bgu001/5f5e8978-a828-4fd4-aabf-2032a3fb895b/Data/EISCAT/Analysed/2006-12-12_arc1_4@uhf';
fitdir = '/mnt/data/bjorn/EISCAT/Analysed/2006-12-12_arc1_4@uhf';
ppdirUM = '/media/bgu001/5f5e8978-a828-4fd4-aabf-2032a3fb895b/Data/EISCAT/tmp-ionlines/2006-12-12_arc1_4@uhf-pp';
ppdir = '/mnt/data/bjorn/EISCAT/Analysed/2006-12-12_arc1_4@uhf-pp';
% Flag for specifying which EISCAT-experiment it is
experiment = 'arc1';
% Altitude-limits.
hmax = 150;
hmin = 95;
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

%% Pearson-type 6 statistics assumed
ErrType = 'l'; % L for Lorentzian.
Outname = sprintf('ElSpec-20061212-L-5-%02i.mat',i1);
disp(Outname)
i1 = 1;
ElSpecQT_20061212_L5{i1} = ElSpec_iqtcl('fitdir',fitdir,...
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
ElSpecPlot(ElSpecQT_20061212_L5{i1})
[fnm1,fnm2,fnm3] = fileparts(ElSpecQT_20061212_L5{i1}.Outfilename); 
print('-depsc','-vector',[fnm2,'-QT-l-5']);
%% Two modified plotting-functions
% In addition to ElSpecPlot, ElSpecPlot2 and ElSpecPlotSmall 2 new
% plotting-functions are added:
fig1 = figure;
ElSpecPlotIeNePpRes(ElSpecQT_20061212_L5{i1},fig1.Number)
fig2 = figure;
ElSpecPlotRes(ElSpecQT_20061212_L5{i1},fig2.Number)
ElSpecPlotIeNePpRes(ElSpecQT_20061212_L5{i1})
ph = ElSpecPlotTres(ElSpecQT_20061212_L5{i1});
set(ph,'color','r','linestyle','--','marker','.')