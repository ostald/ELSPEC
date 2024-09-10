function ElSpec_IC_iter(iter, log_dir, ppdir)
%% ElSpec extended with Ion Chemitry
%% Based on Example-script for ElSpec_iqt usage
% This script should be possible to adapt for anyone with basic skills in
% matlab-usage. This test runs the ElSpec_iqt and ElSpec_qt functions
% testing the outlier-resilience with Pearson-type 6 statistics for the
% electron-density-estimates

%% 1, Setting up the matlab-path
% Simply modify the path below to point to the directory where ELSPEC-2022
% is installed. That should be it.
%addpath /bigdata/Campaigns/ELSPEC-2022 -end
%addpath 'ELSPEC-2022' -end

%% 2 Setup of parameters controlling ELSPEC

% Energy grid - between 10 ad 100 keV in 400 logarithmic/exponential steps
egrid = logspace(1,5,200);

% Data directories
% The paths to the directories with the ionospheric parameters and the
% power-profiles.
%fitdirUM = '/media/bgu001/5f5e8978-a828-4fd4-aabf-2032a3fb895b/Data/EISCAT/Analysed/2006-12-12_arc1_4@uhf';
%fitdir = '/mnt/data/bjorn/EISCAT/Analysed/2006-12-12_arc1_4@uhf';
fitdir = '../Data/Eiscat/fit';
%fitdir = ppdir
%ppdir = strcat(ppdir, '-pp')
%ppdirUM = '/media/bgu001/5f5e8978-a828-4fd4-aabf-2032a3fb895b/Data/EISCAT/tmp-ionlines/2006-12-12_arc1_4@uhf-pp';
%ppdir = '/mnt/data/bjorn/EISCAT/Analysed/2006-12-12_arc1_4@uhf-pp';
ppdir = '../Data/Eiscat/pp';
% Flag for specifying which EISCAT-experiment it is
experiment = 'arc1';
% Altitude-limits.
hmax = 150;
hmin = 95;
% Time-limits
%btime = [2012, 12, 11, 20, 00, 0];
%etime = [2012, 12, 11, 21, 55, 0];

btime = [ 2006 12 12 19 30 0];
etime = [ 2006 12 12 22 00 0];
% Selection of which ionisation-profile method to use
ionomodel = 'Sergienko';
recombmodel = ['SheehanGr'];
%recombmodel = ['SheehanGrFlipchem'];
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
ninteg = 20;
% For additional settings see the help of ElSpec, ElSpec_iqt and ElSpec_qt


% Pearson-type 6 statistics assumed
ErrType = 'l'; % L for Lorentzian.

%try soemthing with same partitioning:
% if iter > 1
%     m2 = iter - 2;
%     nStepsm2 = load(fullfile('..', log_dir, ["/ElSpec-iqt_IC_" + m2 + ".mat"])).ElSpecOut.nSteps;
%     m1 = iter - 1;
%     nStepsm1 = load(fullfile('..', log_dir, ["/ElSpec-iqt_IC_" + m1 + ".mat"])).ElSpecOut.nSteps;
%     if nStepsm2 == nStepsm1
%         nstep = nStepsm2;
%         disp('nstep copied')
%     else
%         nstep = 1;
%     end
% else
%     nstep = 1;
% end

if iter > 0
    j = iter - 1;
    icdir = fullfile(log_dir,["IC_" + j + ".mat"]);
    icdata = load(icdir);
    customIRI = icdata.elspec_iri_sorted;
    customAlpha = icdata.eff_rr;
    neinit = false

    elspec_m1 = fullfile(log_dir,["ElSpec-iqt_IC_" + j + ".mat"]);
    nsteps_old = load(elspec_m1).ElSpecOut.nSteps;
    %ninteg = nsteps_old(1); did not result in converging behaviour
else
    customIRI = false;
    customAlpha = false;
    neinit = false;
end

Outname = fullfile(log_dir, ["ElSpec-iqt_IC_" + iter]);
disp(Outname)


ElSpecQT_iqtOutliers_L5 = ElSpec_iqt_ic('fitdir',fitdir,...
                                       'ppdir',ppdir,...
                                       'experiment',experiment,...
                                       'hmax',hmax,'hmin',hmin,...
                                       'btime',btime,'etime',etime,...
                                       'ionomodel',ionomodel,...
                                       'integtype',integtype,...
                                       'egrid',egrid,...
                                       'tres',tres,...
                                       'MaxOrder',maxorder,...
                                       'ninteg',ninteg,...
                                       'Outfilename',Outname,...
                                       'customIRI', customIRI, ...
                                       'customAlpha', customAlpha, ...
                                       'neinit', neinit, ...
                                       'recombmodel', recombmodel);
%                                       'ErrType',ErrType,...



ElSpecPlot(ElSpecQT_iqtOutliers_L5, ieelim = [10, 14], faclim = [0, 10], plim = [0, 60]);
[fnm1,fnm2,fnm3] = fileparts(ElSpecQT_iqtOutliers_L5.Outfilename) ;
disp(sprintf(datestr(now,'HH:MM:SS')+ " Calculations done, starting figures"))
% print('-dpng',[Outname]);
% disp(sprintf(datestr(now,'HH:MM:SS')+ " PNG figure done"))
% print('-depsc','-vector',[Outname]);
% disp(sprintf(datestr(now,'HH:MM:SS')+ " EPS figure done"))
print('-dpdf', '-painters', [Outname]);
disp(sprintf(datestr(now,'HH:MM:SS')+ " PDF figure done"))
dstr = sprintf('Done with loop S i1: 0 at %s',datestr(now,'HH:MM:SS'));
disp(dstr)
close(gcf)
  
end
