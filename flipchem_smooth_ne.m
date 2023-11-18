%set variables
egrid = logspace(1,5,200);
fitdir = '../Data/Eiscat/fit';
ppdir = '../Data/Eiscat/pp';
experiment = 'arc1';
hmax = 150;
hmin = 95;
btime = [ 2006 12 12 19 30 0];
etime = [ 2006 12 12 19 35 0];
ionomodel = 'Sergienko';
integtype = 'integrate';
tres = 'best';
maxorder = 5;
ninteg = 20;
ErrType = 'l';
recombmodel = ['SheehanGrFlipchem'];

%run ElSpec to generate smooth ne
ElSpecQT_iqtOutliers_L5 = ElSpec('fitdir',fitdir,...
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
'recombmodel', recombmodel);

c = ElSpecQT_iqtOutliers_L5

%use smooth ne to recalculate flipchem composition
[modelout, photoprod] = calculateFlipchemComposition(c.ts,c.h,c.par,c.ne,c.loc,c.iri)

%plot
plot_ions(c.ts, c.h, c.ne, modelout, 'O2+')
plot_ions(c.ts, c.h, c.ne, modelout, 'O+')