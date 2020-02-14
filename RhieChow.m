function RhieChow()
    %{
    - eq(15.60)
    - also computes and stores Dc and Dv_f as in eq(15.35) as are used in
      correction.m
    %}
    
    global Domain
    Mesh=Domain.Mesh;
    Field=Domain.Field;
    Tmp=Domain.Tmp;
    Fluid=Domain.Fluid;
    
    interiorface=Mesh.face.boundarynum+1:Mesh.face.number;
    Dc=zeros(Mesh.element.number,3);
    Dv_f=zeros(Mesh.face.number,3);
    
    for k=1:Mesh.Dimension
        Dc(:,k)=Mesh.element.volume(:)./diag(Tmp.mom_mat(:,:,k));
    end
    
    for k=1:Mesh.Dimension
        Dv_f(interiorface,k)=Mesh.face.gcf(interiorface,1).*Dc(Mesh.face.owner(interiorface,1),k)...
                            +Mesh.face.gcf(interiorface,2).*Dc(Mesh.face.owner(interiorface,2),k);
    end
    
    Field.face.velocity(interiorface,:)=...     %Any point to write Field.face.velocity? Just facevelocity looks fine. For readability?
        Mesh.face.gcf(interiorface,1).*Field.element.velocity(Mesh.face.owner(interiorface,1),:)...
       +Mesh.face.gcf(interiorface,2).*Field.element.velocity(Mesh.face.owner(interiorface,2),:)...
       -Dv_f(interiorface,:).*(...
                                (Field.element.pressure(Mesh.face.owner(interiorface,2))-Field.element.pressure(Mesh.face.owner(interiorface,1)))./Mesh.face.dCF(interiorface)...
                                -sum(Field.face.pressuregrad(interiorface,:).*Mesh.face.ecf(interiorface,:),2)...
                              ).*Mesh.face.ecf(interiorface,:);
    
    Field.face.flux(interiorface)=Fluid.density*sum(Field.face.velocity(interiorface,:).*Mesh.face.Sf(interiorface,:),2);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%% ADDED FROM HERE %%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    boundaryface=1:Mesh.face.boundarynum;
    for i=1:Mesh.face.boundarynum
        if Mesh.face.boundarycondition(i,1)==1
            Field.face.velocity(i,:)=Field.element.velocity(Mesh.face.owner(i,1),:)...
                                    -Dc(Mesh.face.owner(i,1),:)...
                                  .*(Field.face.pressuregrad(i,:)-Field.element.pressuregrad(Mesh.face.owner(i,1),:));
            Field.face.flux(i)=Fluid.density*dot(Field.face.velocity(i,:),Mesh.face.Sf(i,:));
        else
            Field.face.velocity(i,:)=Field.face.velocity(i,:);
            Field.face.flux(i)=Field.face.flux(i);
        end
    end
    Domain.Field.face.velocity(boundaryface)=Field.face.velocity(boundaryface);
    Domain.Field.face.flux(boundaryface)=Field.face.flux(boundaryface);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%% ADDED  TO  HERE %%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Domain.Field.element.Dc=Dc;
    Domain.Field.face.Dv_f(interiorface,:)=Dv_f(interiorface,:);
    Domain.Field.face.velocity(interiorface,:)=Field.face.velocity(interiorface,:);
    Domain.Field.face.flux(interiorface)=Field.face.flux(interiorface);
    
%     dlmwrite('element.Dc.txt',Domain.Field.element.Dc);
%     dlmwrite('Dv_f.txt',Domain.Field.face.Dv_f);
%     dlmwrite('face.velocity_RC.txt',Domain.Field.face.velocity);
%     dlmwrite('face.flux_RC.txt',Domain.Field.face.flux);
end