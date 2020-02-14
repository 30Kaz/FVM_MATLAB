function convectionterm=AddMomMat_Convection(Mesh,Field)
    %{
    - Only for internal faces
    %}
    convectionterm=zeros(Mesh.element.number);
    
    for i=Mesh.face.boundarynum+1:Mesh.face.number
        %u direction
        %aC for cell C, owner 1
        convectionterm(Mesh.face.owner(i,1),Mesh.face.owner(i,1))...
       =convectionterm(Mesh.face.owner(i,1),Mesh.face.owner(i,1))...
       +max(Field.face.flux(i),0);
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
    %copy for v, w direction
%     dlmwrite('Convectionterm.txt',convectionterm);
    convectionterm=repmat(convectionterm, [1 1 Mesh.Dimension]);
    
end