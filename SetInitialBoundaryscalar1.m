function SetInitialBoundaryscalar1()
    global Domain
    Mesh=Domain.Mesh;
    
    %Initial Condition
    for i=1:Mesh.element.number
        if Mesh.element.centroid(i,1)>=0.6 && Mesh.element.centroid(i,2)>=0.6...
           &&Mesh.element.centroid(i,1)<=0.9 && Mesh.element.centroid(i,2)<=0.9
            Domain.Field.element.scalar1(i)=1;
        else
            Domain.Field.element.scalar1(i)=0;
        end
    end
    
    %Boundary Condition, argument dependent on Mesh
%         Domain.Field.face.scalar1(151:175)=1; %only the boundary on the left (0,0)-(0,1)
        Domain.Field.face.scalar1(61:80)=1;   %for mesh 400
%     Domain.Field.face.scalar1(151:200)=1;   %for mesh 2500
end