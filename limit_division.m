function division_penalty = limit_division(dir, iter)

if iter <= 3
    division_penalty = 0;
else
    for i = 1:3
        res = load(fullfile(dir,["ElSpec-iqt_IC_" + string(iter-3+i) + ".mat"]));
        hist_ie{i} = res.ElSpecOut.q;
        hist_nsteps{i} = res.ElSpecOut.nSteps;
        dE = res.ElSpecOut.dE;
        ts = res.ElSpecOut.ts;
        if i == 3
            nstepmin = res.ElSpecOut.nstepmin;
            disp(fullfile(dir,["ElSpec-iqt_IC_" + string(iter-3+i) + ".mat"]))
        end
        %hist_ie{i} = hist_ie{i} .* repmat(dE', [1, numel(ts)])
    end
    
    ie_sum = hist_ie{1} + hist_ie{2} + hist_ie{3};
    fluc = abs((hist_ie{1} - 2.*hist_ie{2} + hist_ie{3}) ./ ie_sum ); %.* log10(ie_sum)
    %fluc = abs((hist_ie{2} - hist_ie{1})) %./ (hist_ie{1} + hist_ie{2} ))
    fluc(isnan(fluc)) = 0;
    
    %crit = sum(fluc, 1)/size(fluc, 1)
    division_penalty = (sum(fluc, 1)/size(fluc, 1)) .* 150;
    division_penalty = (division_penalty + 2*nstepmin) / 3;

    
    %nstepmin = min(min(hist_nsteps{1}, hist_nsteps{2}), hist_nsteps{3});
    
    %nstepmin(crit>0) = nstepmin(crit>0).*2;
    
    %nste = bsxfun(@plus, nstepmin', nstepmin_before) ./ 2
    
    %nstepmin_before = nste
end


if 0
ts = res.ElSpecOut.ts
ts = [1:numel(ts)]
EE = res.ElSpecOut.E(1:end-1)
h = res.ElSpecOut.h
%EE = h
ielim = [6 15]

figure
nplots = 6
h1=subplot(nplots,1,1);
pcolor(log10(hist_ie{1})),shading flat
set(h1,'yscale','log')
%ylim(p.Results.elim)
%xlim(datenum([datetime(p.Results.btime) datetime(p.Results.etime)]))
%caxis(p.Results.ielim)
caxis(ielim)
ylabel('Energy [keV]')
cbh3=colorbar;
%ylabel(cbh3,Ielabel)
%ylim([.5 20])


h2=subplot(nplots,1,2);
pcolor(log10(hist_ie{2})),shading flat
set(h2,'yscale','log')
%ylim(p.Results.elim)
%xlim(datenum([datetime(p.Results.btime) datetime(p.Results.etime)]))
%caxis(p.Results.ielim)
caxis(ielim)
ylabel('Energy [keV]')
cbh3=colorbar;
%ylabel(cbh3,Ielabel)
%ylim([.5 20])


h3=subplot(nplots,1,3);
pcolor(log10(hist_ie{3})),shading flat
set(h3,'yscale','log')
%ylim(p.Results.elim)
%xlim(datenum([datetime(p.Results.btime) datetime(p.Results.etime)]))
%caxis(p.Results.ielim)
caxis(ielim)
ylabel('Energy [keV]')
cbh3=colorbar;
%ylabel(cbh3,Ielabel)
%ylim([.5 20])


h4=subplot(nplots,1,4);
pcolor((fluc)),shading flat
set(h4,'yscale','log')
%ylim(p.Results.elim)
%xlim(datenum([datetime(p.Results.btime) datetime(p.Results.etime)]))
%caxis(p.Results.ielim)
caxis([-1, 3])
ylabel('Energy [keV]')
cbh3=colorbar;
%ylabel(cbh3,Ielabel)
%ylim([.5 20])


h5=subplot(nplots,1,5);
plot(ts, (sum(fluc, 1)/size(fluc, 1)))
hold on;
%set(h3,'yscale','log')
%ylim(p.Results.elim)
%xlim(datenum([datetime(p.Results.btime) datetime(p.Results.etime)]))
%caxis(p.Results.ielim)
ylabel('Energy [keV]')
cbh3=colorbar;
%ylabel(cbh3,Ielabel)
%ylim([.5 20])



h6=subplot(nplots,1,6);
plot(ts, min(min(hist_nsteps{1}, hist_nsteps{2}), hist_nsteps{3}))
hold on;
plot(ts, nstepmin)
%set(h3,'yscale','log')
%ylim(p.Results.elim)
%xlim(datenum([datetime(p.Results.btime) datetime(p.Results.etime)]))
%caxis(p.Results.ielim)
ylabel('Energy [keV]')
cbh3=colorbar;

linkaxes([h1, h2, h3, h4, h5, h6],'x')
end