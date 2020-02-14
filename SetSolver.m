function SetSolver()
    global Domain
    
    Solutionsystem.max_iter          =20;
    Solutionsystem.transient         =1;        %1:transient, 0:steady
    Solutionsystem.max_solutiontime  =5;        %time[s], set 0 for steady!
    Solutionsystem.timestep          =0.25;     %dt[s]
    Solutionsystem.relax_velocity    =0.7;
    Solutionsystem.relax_pressure    =0.3;
    Solutionsystem.tolerance         =1e-3;     %convergence criterion
    
    Solutionsystem.iterationnumber   =0;
    Solutionsystem.timelevel         =0;
    Solutionsystem.solutiontime      =0;
    
    Domain.Solutionsystem=Solutionsystem;
end