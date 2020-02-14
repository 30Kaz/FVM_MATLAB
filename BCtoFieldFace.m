function BCtoFieldFace(Mesh,Fluid)
    global Domain
    
    for i=1:Mesh.face.boundarynum
        switch Mesh.face.boundarycondition(i,1)
            case 1 %Specific pressure
                Domain.Field.face.pressure(i)=Mesh.face.boundarycondition(i,2);
            case {2,3}  %Specific velocity, No slip wall
                Domain.Field.face.velocity(i,:)=Mesh.face.boundarycondition(i,2:4);
                Domain.Field.face.flux(i)=Fluid.density*dot(Domain.Field.face.velocity(i,:),Mesh.face.Sf(i,:));
            case 4 %Slip wall
                disp('Slip wall not defined in BCtoFieldFace.m');
        end
    end
end