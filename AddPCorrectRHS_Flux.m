function addition=AddFluxPCorrectRHS(Mesh,Field)
    %{
    - (15.99)
    %}
    
    addition=zeros(Mesh.element.number,1);
    
    for i=1:Mesh.face.number
        addition(Mesh.face.owner(i,1))...
       =addition(Mesh.face.owner(i,1))...
       -Field.face.flux(i);
        if Mesh.face.owner(i,2)~=0
            addition(Mesh.face.owner(i,2))...
           =addition(Mesh.face.owner(i,2))...
           +Field.face.flux(i);
        end
    end
%     for i=Mesh.face.boundarynum+1:Mesh.face.number
%         addition(Mesh.face.owner(i,1))...
%        =addition(Mesh.face.owner(i,1))...
%        -Field.face.flux(i);
%         addition(Mesh.face.owner(i,2))...
%        =addition(Mesh.face.owner(i,2))...
%        +Field.face.flux(i);
%     end
end