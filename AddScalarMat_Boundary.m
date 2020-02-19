function boundaryterm=AddScalarMat_Boundary(Mesh,Fluid)
    %{
    - p.218-222
    - convection contribution is included in AddScalarMat_Convection,
      not here
      ->fix later
    %}
    
    boundaryterm=zeros(Mesh.element.number,Mesh.element.number);
    
    for i=1:Mesh.face.boundarynum
        switch Mesh.face.boundarycondition(i,1)
            case 1 %Specific pressure: ???
                disp('Specific pressure, Undefined Boundary Condition in AddScalarMat_Boundary.m')
%                 BoundaryVelocity=zeros(1,3);
%                 for k=1:Mesh.Dimension
%                     BoundaryVelocity(k)...
%                    =Field.element.velocity(Mesh.face.owner(i,1),k)...
%                    +dot(Field.face.velocitygrad(i,3*k-2:3*k),...
%                         Mesh.face.dCF(i)*Mesh.face.ecf(i,:)...
%                        );
%                 end
%                 for k=1:Mesh.Dimension
%                     boundaryterm(Mesh.face.owner(i,1),Mesh.face.owner(i,1),k)...
%                    =boundaryterm(Mesh.face.owner(i,1),Mesh.face.owner(i,1),k)...
%                    +Fluid.density*dot(BoundaryVelocity,Mesh.face.Sf(i,:));
%                 end
            case 2  %Specific velocity: Dirichlet
                    boundaryterm(Mesh.face.owner(i,1),Mesh.face.owner(i,1))...
                   =boundaryterm(Mesh.face.owner(i,1),Mesh.face.owner(i,1))...
                   +Fluid.scalar1diff*Mesh.face.Ef(i)/Mesh.face.dCF(i);
%                    +max(Field.face.flux(i),0)...
%                    +Fluid.viscosity*Mesh.face.Ef(i)/Mesh.face.dCF(i);
            case {3,4}  %No slip wall, slip wall: von Neuman w/ zero flux
                %no updates
            otherwise
                disp('Undefined Boundary Condition in AddScalarMat_Boundary.m')
        end
    end
end