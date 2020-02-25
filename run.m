%{
- (^ _ ^)v
%}
clear, clc, close all;
global Domain;

Domain.Mesh=GmshFileRead('Cavity_400.msh',2);

SetSolver();
SetFluid();
preallocate();
SetBoundary();
SetInitial();
SetInitialBoundaryscalar1();
figure(1),clf;
Plotresults(Domain.Mesh, Domain.Field,Domain.Solutionsystem);
tic
while(1)
    Domain.Solutionsystem.solutiontime=Domain.Solutionsystem.solutiontime+Domain.Solutionsystem.timestep;
    Domain.Solutionsystem.timelevel=Domain.Solutionsystem.timelevel+1;
    disp(['solution time = ', num2str(Domain.Solutionsystem.solutiontime)]);
    while(1)    %iterative process for each time step
        Domain.Solutionsystem.iterationnumber=Domain.Solutionsystem.iterationnumber+1;
        disp(['iteration = ', num2str(Domain.Solutionsystem.iterationnumber)]);

        get_grad('pressure');
        get_grad('velocity');
        solve_momentum();
        RhieChow();
        solve_pressure();
        get_grad('PCorrect');
        correction();
        convergence();
    %     Plotresults(Domain.Mesh, Domain.Field,Solutionsystem);
        if mod(Domain.Solutionsystem.iterationnumber,Domain.Solutionsystem.max_iter)==(0)...
                ||max(max(Domain.Tmp.res_veloc(end,:)),Domain.Tmp.res_p(end))<=Domain.Solutionsystem.tolerance
            break
        end
        Domain.Field.element.lastvelocity=Domain.Field.element.velocity;
    end
    solve_scalar();
    Plotresults(Domain.Mesh, Domain.Field,Domain.Solutionsystem);
    
    if Domain.Solutionsystem.solutiontime>=Domain.Solutionsystem.max_solutiontime
        disp('********** Maximum time reached **********');
        fprintf('Elapsed time : %d min %2g sec\n', floor(toc/60), rem(toc,60));
        break
    end
end
