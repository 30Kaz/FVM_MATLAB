function boundaryterm=AddMomMat_Boundary(Mesh,Field,Fluid)
    boundaryterm=zeros(Mesh.element.number,Mesh.element.number,Mesh.Dimension);

    for i=1:Mesh.face.boundarynum
        switch Mesh.face.boundarycondition(i,1)
            case 1 %Specific pressure
                BoundaryVelocity=zeros(1,3);
                for k=1:Mesh.Dimension
                    BoundaryVelocity(k)...
                   =Field.element.velocity(Mesh.face.owner(i,1),k)...
                   +dot(Field.face.velocitygrad(i,3*k-2:3*k),...
                        Mesh.face.dCF(i)*Mesh.face.ecf(i,:)...
                       );
                end
                for k=1:Mesh.Dimension
                    boundaryterm(Mesh.face.owner(i,1),Mesh.face.owner(i,1),k)...
                   =boundaryterm(Mesh.face.owner(i,1),Mesh.face.owner(i,1),k)...
                   +Fluid.density*dot(BoundaryVelocity,Mesh.face.Sf(i,:));
                end
                
            case 2  %Specific velocity
                for k=1:Mesh.Dimension
                    boundaryterm(Mesh.face.owner(i,1),Mesh.face.owner(i,1),k)...
                   =boundaryterm(Mesh.face.owner(i,1),Mesh.face.owner(i,1),k)...
                   +max(Field.face.flux(i),0)...
                   +Fluid.viscosity*Mesh.face.Ef(i)/Mesh.face.dCF(i);
                end
                
            case 3  %No slip wall
                for k=1:Mesh.Dimension
                    boundaryterm(Mesh.face.owner(i,1),Mesh.face.owner(i,1),k)...
                   =boundaryterm(Mesh.face.owner(i,1),Mesh.face.owner(i,1),k)...
                   +Fluid.viscosity*Mesh.face.area(i)/Mesh.face.dCF(i)...
                   *(1-(Mesh.face.Sf(i,k)/Mesh.face.area(i))^2);
                end
                
            case 4 %Slip wall
                disp('Sipwall, Undefined Boundary Condition in AddBoundaryMomMat.m')
            otherwise
                disp('Undefined Boundary Condition in AddBoundaryMomMat.m')
        end
    end
end