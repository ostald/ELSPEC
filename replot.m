function replot(dir)
for i = 0:42
    load(fullfile(dir, ["ElSpec-iqt_IC_" + i]))
    ElSpecPlot(ElSpecOut, ...
               elim = [1, 500], ...
               ieelim = [10, 14], ...
               faclim = [0, 10], ...
               nelim = [10 13], ...
               plim = [0 100], ...
               chisqrlim = [0 50]);
    [fnm1,fnm2,fnm3] = fileparts(ElSpecOut.Outfilename) ;
    print('-dpng',[ElSpecOut.Outfilename]);
    % disp(sprintf(datestr(now,'HH:MM:SS')+ " PNG figure done"))
    % print('-depsc','-vector',[Outname]);
    % disp(sprintf(datestr(now,'HH:MM:SS')+ " EPS figure done"))
    % print('-dpdf', '-painters', [Outname]);
    % disp(sprintf(datestr(now,'HH:MM:SS')+ " PDF figure done"))
    close(gcf)
end 
end
