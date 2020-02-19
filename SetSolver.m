function SetSolver()
    global Domain
    
    Solutionsystem.max_iter          =40;
    Solutionsystem.transient         =0;        %1:transient, 0:steady
    Solutionsystem.max_solutiontime  =4;        %time[s], set 0 for steady!
    Solutionsystem.timestep          =0.75;     %dt[s]
    Solutionsystem.relax_velocity    =0.7;
    Solutionsystem.relax_pressure    =0.3;
    Solutionsystem.tolerance         =1e-3;     %convergence criterion
    
    Solutionsystem.scalarmode        =0;        %additional scalar. 1:on, 0:off
    
    Solutionsystem.iterationnumber   =0;
    Solutionsystem.timelevel         =0;
    Solutionsystem.solutiontime      =0;
    
    if Solutionsystem.transient==0
        disp('Steady mode');
        Solutionsystem.max_solutiontime=0;
    elseif Solutionsystem.transient==1
        disp('Transient mode');
    end
    
    Domain.Solutionsystem=Solutionsystem;
end