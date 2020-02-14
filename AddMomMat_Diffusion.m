function diffusionterm=AddMomMat_Diffusion(Mesh,Fluid)
    %{
    - eq(15.72)
    - Only for internal faces
    %}
    diffusionterm=zeros(Mesh.element.number);
    
    for i=Mesh.face.boundarynum+1:Mesh.face.number
        %aC for cell C, owner 1
        diffusionterm(Mesh.face.owner(i,1),Mesh.face.owner(i,1))...
       =diffusionterm(Mesh.face.owner(i,1),Mesh.face.owner(i,1))...
       +Fluid.viscosity*Mesh.face.Ef(i)/Mesh.face.dCF(i);
        %aF for cell F, owner 1
        diffusionterm(Mesh.face.owner(i,1),Mesh.face.owner(i,2))...
       =diffusionterm(Mesh.face.owner(i,1),Mesh.face.owner(i,2))...
       -Fluid.viscosity*Mesh.face.Ef(i)/Mesh.face.dCF(i);
        %aC for cell C, owner 2
        diffusionterm(Mesh.face.owner(i,2),Mesh.face.owner(i,2))...
       =diffusionterm(Mesh.face.owner(i,2),Mesh.face.owner(i,2))...
       +Fluid.viscosity*Mesh.face.Ef(i)/Mesh.face.dCF(i);
        %aF for cell F, owner 2
        diffusionterm(Mesh.face.owner(i,2),Mesh.face.owner(i,1))...
       =diffusionterm(Mesh.face.owner(i,2),Mesh.face.owner(i,1))...
       -Fluid.viscosity*Mesh.face.Ef(i)/Mesh.face.dCF(i);
    end
    
%     dlmwrite('diffusiontermMat.txt',diffusionterm);
    diffusionterm=repmat(diffusionterm,[1 1 Mesh.Dimension]);
end