%{
- for no slip wall boundary, boundary velocity is not calculated in InterpolateValue
  >has been modified to do pressure outlet
- (^ _ ^)v
%}
clear, clc, close all;
global Domain;

Domain.Mesh=GmshFileRead('Cavity_400.msh',2);

SetFluid();
preallocate();
SetBoundary();
SetSolver();
Plotmesh(Domain.Mesh);
figure(4),clf;

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
    %     Plotresults(Domain.Mesh, Domain.Field);
        if mod(Domain.Solutionsystem.iterationnumber,Domain.Solutionsystem.max_iter)==(0)...
                ||max(max(Domain.Tmp.res_veloc(end,:)),Domain.Tmp.res_p(end))<=Domain.Solutionsystem.tolerance
            break
        end
        Domain.Field.element.lastvelocity=Domain.Field.element.velocity;
    end

    Plotresults(Domain.Mesh, Domain.Field);
    
    if Domain.Solutionsystem.solutiontime>=Domain.Solutionsystem.max_solutiontime
        disp('********** Maximum time reached **********');
        break
    end
end