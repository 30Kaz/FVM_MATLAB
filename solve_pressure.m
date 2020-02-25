function solve_pressure()
    %{
    - (15.98), (15.108)
    - Only solving from i=2, so BC change requires redefining Mom\RHS
    %}
    
    global Domain
    Mesh=Domain.Mesh;
    Field=Domain.Field;
    Fluid=Domain.Fluid;
    
    PCorrectMat=zeros(Mesh.element.number);
    PCorrectRHS=zeros(Mesh.element.number,1);
    
    PCorrectMat=PCorrectMat+AddPCorrectMat_Interior(Mesh,Field,Fluid);
    PCorrectMat=PCorrectMat+AddPCorrectMat_Boundary(Mesh,Field,Fluid);
    PCorrectRHS=PCorrectRHS+AddPCorrectRHS_Flux(Mesh,Field);
    PCorrectRHS=PCorrectRHS+AddPCorrectRHS_Boundary(Mesh,Field);
    
    if min(Mesh.face.boundarycondition(1:Mesh.face.boundarynum,1))==1   %Pressure outlet exists
        PCorrect=sparse(PCorrectMat)\PCorrectRHS;
    else                                                                %No pressure outlet
        PCorrect(2:Mesh.element.number,1)=sparse(PCorrectMat(2:Mesh.element.number,(2:Mesh.element.number)))\PCorrectRHS(2:Mesh.element.number,1);
    end
%     dlmwrite('PCorrectMat.txt',PCorrectMat);
%     dlmwrite('PCorrectRHS.txt',PCorrectRHS);
%     dlmwrite('PCorrect.txt',PCorrect);
    
    Domain.Field.element.PCorrect=PCorrect;
    Domain.Tmp.p_mat=PCorrectMat;
    Domain.Tmp.p_right=PCorrectRHS;

end