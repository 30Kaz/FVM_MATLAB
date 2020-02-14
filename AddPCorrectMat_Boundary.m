function addition=AddBoundaryPCorrectMat(Mesh,Field,Fluid)
    %{
    -P.618
    %}
    
    addition=zeros(Mesh.element.number);
    
    for i=1:Mesh.face.boundarynum
        switch Mesh.face.boundarycondition(i,1)
            case 1      %Specific pressure
                DCb=sum(...
                        (Field.element.Dc(Mesh.face.owner(i,1),:).*Mesh.face.Sf(i,:)).^(2)...
                       )...
                   /sum(...
                        (Mesh.face.dCF(i)*Mesh.face.ecf(i,:).*Field.element.Dc(Mesh.face.owner(i,1),:))...
                        .*Mesh.face.Sf(i,:)...
                       );           %eq(15.108) for boundary elements
                addition(Mesh.face.owner(i,1),Mesh.face.owner(i,1))...
               =addition(Mesh.face.owner(i,1),Mesh.face.owner(i,1))...
               +Fluid.density*DCb;  %eq(15.168)
                
            case {2,3}  %Specific velocity, No slip wall
                %does nothing
            case 4      %Slip wall
                disp('Slip wall, Undefined Boundary Condition in AddBoundaryPCorrectMat.m')
            otherwise
                disp('Undefined Boundary Condition in AddBoundaryPCorrectMat.m')
        end
    end
end