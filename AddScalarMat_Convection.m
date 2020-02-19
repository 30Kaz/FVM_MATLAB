function convectionterm=AddScalarMat_Convection(Mesh,Field)
    %{
    - just copied AddMomMat_Convection
    - includes boundary term only for convetion, not diffusion
    %}
    convectionterm=zeros(Mesh.element.number);
    
    for i=1:Mesh.face.number
%         for i=Mesh.face.boundarynum+1:Mesh.face.number
        %u direction
        %aC for cell C, owner 1
        convectionterm(Mesh.face.owner(i,1),Mesh.face.owner(i,1))...
       =convectionterm(Mesh.face.owner(i,1),Mesh.face.owner(i,1))...
       +max(Field.face.flux(i),0);
        if Mesh.face.owner(i,2)~=0
        %aF for cell C, owner 1
        convectionterm(Mesh.face.owner(i,1),Mesh.face.owner(i,2))...
       =convectionterm(Mesh.face.owner(i,1),Mesh.face.owner(i,2))...
       -max(-Field.face.flux(i),0);
        
        %aC for cell C, owner 2
        convectionterm(Mesh.face.owner(i,2),Mesh.face.owner(i,2))...
       =convectionterm(Mesh.face.owner(i,2),Mesh.face.owner(i,2))...
       +max(-Field.face.flux(i),0);
        %aF for cell C, owner 2
        convectionterm(Mesh.face.owner(i,2),Mesh.face.owner(i,1))...
       =convectionterm(Mesh.face.owner(i,2),Mesh.face.owner(i,1))...
       -max(Field.face.flux(i),0);
        end
    end
end