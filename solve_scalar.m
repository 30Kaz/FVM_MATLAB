function solve_scalar()
    %{
    - not support pressure outlet yet. Need to have another think.
    %}
    global Domain
    if Domain.Solutionsystem.scalarmode==1
        Mesh=Domain.Mesh;
        Field=Domain.Field;
        Fluid=Domain.Fluid;
        Solutionsystem=Domain.Solutionsystem;

        get_grad('scalar1');

        ScalarMat=zeros(Mesh.element.number);
        ScalarRHS=zeros(Mesh.element.number,1);

        ScalarMat=ScalarMat+AddScalarMat_Transient(Mesh,Solutionsystem,Fluid);
        ScalarMat=ScalarMat+AddScalarMat_Convection(Mesh,Field);
        ScalarMat=ScalarMat+AddScalarMat_Diffusion(Mesh,Fluid);
        ScalarMat=ScalarMat+AddScalarMat_Boundary(Mesh,Fluid);

        ScalarRHS=ScalarRHS+AddScalarRHS_Transient(Mesh,Field,Solutionsystem,Fluid);
        
        writematrix(ScalarRHS,join(['output/' 'ScalarRHS_beforeHO.csv']));
%         writematrix(ScalarRHS,join(['output/' 'ScalarRHS_beforeHO.txt']));
%         dlmwrite('output/ScalarRHS_beforeHO.txt', ScalarRHS);
        ScalarRHS=ScalarRHS+ScalarRHS_HigherOrder(Mesh,Field);
        writematrix(ScalarRHS,join(['output/' 'ScalarRHS_afterHO.csv']));
%        0 dlmwrite('output/ScalarRHS_afterHO.txt', ScalarRHS);
%         writematrix(ScalarRHS,join(['output/' 'ScalarRHS_afterHO.txt']));
        ScalarRHS=ScalarRHS+AddScalarRHS_Boundary(Mesh,Field,Fluid);

        Domain.Field.element.scalar1=sparse(ScalarMat)\ScalarRHS;
        writematrix(Domain.Field.element.scalar1,join(['output/' 'Scalar1.csv']));
        
    end
end