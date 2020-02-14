function addition=AddBoundaryPCorrectRHS(Mesh,Field)
    addition=zeros(Mesh.element.number,1);
    
    for i=1:Mesh.face.boundarynum
        switch Mesh.face.boundarycondition(i,1)
            case {1,2,3}  %Specific velocity, No slip wall
                %do nothing
            case 4      %Slip wall
                disp('Slip wall, Undefined Boundary Condition in AddBoundaryPCorrectRHS.m')
            otherwise
                disp('Undefined Boundary Condition in AddBoundaryPCorrectRHS.m')
        end
    end
end