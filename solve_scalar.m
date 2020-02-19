function solve_scalar()
    %{
    - not support pressure outlet yet. Need to have another think.
    %}
    
    global Domain
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
    ScalarRHS=ScalarRHS+AddScalarRHS_Boundary(Mesh,Field,Fluid);
    
    Domain.Field.element.scalar1=sparse(ScalarMat)\ScalarRHS;
    
end