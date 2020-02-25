function solve_momentum()
    %{
    - Solves [ac][vc]=[b] (15.70)
    - upwind for convection
    %}
    global Domain;
    Mesh=Domain.Mesh;
    Field=Domain.Field;
    Fluid=Domain.Fluid;
    Solutionsystem=Domain.Solutionsystem;
    
    MomMat=zeros(Mesh.element.number,Mesh.element.number,Mesh.Dimension);
    MomRHS=zeros(Mesh.element.number,Mesh.Dimension);
    
    MomMat=MomMat+AddMomMat_Transient(Mesh,Solutionsystem,Fluid);
    MomMat=MomMat+AddMomMat_Convection(Mesh,Field);
    MomMat=MomMat+AddMomMat_Diffusion(Mesh,Fluid);
%     dlmwrite('MomMatX_AddedDiffusion.txt',MomMat(:,:,1));
%     dlmwrite('MomMatY_AddedDiffusion.txt',MomMat(:,:,2));
    MomMat=MomMat+AddMomMat_Boundary(Mesh,Field,Fluid);
%     dlmwrite('MomMatX_AddedBoundary.txt',MomMat(:,:,1));
%     dlmwrite('MomMatY_AddedBoundary.txt',MomMat(:,:,2));
    
    MomRHS=MomRHS+AddMomRHS_Transient(Mesh,Field,Solutionsystem,Fluid);
    MomRHS=MomRHS+AddMomRHS_Pressure(Mesh,Field);
%     dlmwrite('MomRHSAddedPressure.txt',MomRHS);
    MomRHS=MomRHS+AddMomRHS_Diffusion(Mesh,Field,Fluid);
%     dlmwrite(join([pwd '/output/MomRHSAddedDiffusion.txt']),MomRHS);

%     writematrix(MomRHS,join([pwd '/output/MomRHSBeforeHO_iter' num2str(Solutionsystem.iterationnumber) '.csv']));
    MomRHS=MomRHS+AddMomRHS_HigherOrder(Mesh,Field);
%     writematrix(MomRHS,join([pwd '/output/MomRHSAddedHO_iter' num2str(Solutionsystem.iterationnumber) '.csv']));
    
    MomRHS=MomRHS+AddMomRHS_Boundary(Mesh,Field,Fluid);
%     dlmwrite(join([pwd '/output/MomRHSAddedBoundary.txt']),MomRHS);
    [MomMat,MomRHS]=RelaxMom(MomMat,MomRHS,Mesh,Field,Solutionsystem);
%     dlmwrite('MomMatX_relaxed.txt',MomMat(:,:,1));
%     dlmwrite('MomMatY_relaxed.txt',MomMat(:,:,2));
%     dlmwrite('MomRHS_relaxed.txt',MomRHS);
    
    for k=1:Mesh.Dimension
        Domain.Field.element.velocity(:,k)=sparse(MomMat(:,:,k))\MomRHS(:,k);
    end
    
%     dlmwrite('Field.element.velocity.txt',Domain.Field.element.velocity);
    
    Domain.Tmp.mom_mat=MomMat;
    Domain.Tmp.mom_right=MomRHS;
end