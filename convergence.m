function convergence()
%{
- by Kazuya
- Compute residuals
- Draw graphs later
%}
    global Domain;
    Mesh=Domain.Mesh;
    Field=Domain.Field;
    Solutionsystem=Domain.Solutionsystem;
    Tmp=Domain.Tmp;
    res_veloc=Tmp.res_veloc;
    res_p=Tmp.res_p;
    
    iterationnumber=Solutionsystem.iterationnumber;

    res_veloc(iterationnumber, 1)=(sum((Tmp.mom_right(:,1)-Tmp.mom_mat(:,:,1)*Field.element.velocity(:,1)).^2)/Mesh.element.number)^(1/2);
    res_veloc(iterationnumber, 2)=(sum((Tmp.mom_right(:,2)-Tmp.mom_mat(:,:,2)*Field.element.velocity(:,2)).^2)/Mesh.element.number)^(1/2);
    res_p(iterationnumber)=(sum((Tmp.p_right(:,1)-Tmp.p_mat(:,:,1)*Field.element.velocity(:,1)).^2)/Mesh.element.number)^(1/2);
    
    disp(['residuals:     u = ', num2str(res_veloc(iterationnumber, 1))...
          '     v = ', num2str(res_veloc(iterationnumber, 2))...
          '     continuity = ', num2str(res_p(iterationnumber))]);
    
    figure(1),clf(1)    %clf necessary for correctly-coloured legend
    semilogy(res_veloc(:,1),'color','y','LineWidth',2);   %res_u
    hold on;
    semilogy(res_veloc(:,2),'color','m','LineWidth',2);   %res_v
    semilogy(res_p,'color','b','LineWidth',2);   %res_p
    hold off;
    legend('X-momentum','Y-momentum','Continuity');
    xlabel('Iteration')
    ylabel('Residual')
    title('Residuals')
    if Solutionsystem.solutiontime>=Solutionsystem.max_solutiontime
        saveas(gcf,join([pwd '/output/Residuals.png']));
    end
    
    
    Domain.Tmp.res_veloc=res_veloc;
    Domain.Tmp.res_p=res_p;
    
end