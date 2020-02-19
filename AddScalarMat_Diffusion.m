function diffusionterm=AddScalarMat_Diffusion(Mesh,Fluid)
    %{
    - copied from AddMomMat_Diffusion
    %}
    
    diffusionterm=zeros(Mesh.element.number);
    
    for i=Mesh.face.boundarynum+1:Mesh.face.number
        %aC for cell C, owner 1
        diffusionterm(Mesh.face.owner(i,1),Mesh.face.owner(i,1))...
       =diffusionterm(Mesh.face.owner(i,1),Mesh.face.owner(i,1))...
       +Fluid.scalar1diff*Mesh.face.Ef(i)/Mesh.face.dCF(i);
        %aF for cell F, owner 1
        diffusionterm(Mesh.face.owner(i,1),Mesh.face.owner(i,2))...
       =diffusionterm(Mesh.face.owner(i,1),Mesh.face.owner(i,2))...
       -Fluid.scalar1diff*Mesh.face.Ef(i)/Mesh.face.dCF(i);
        %aC for cell C, owner 2
        diffusionterm(Mesh.face.owner(i,2),Mesh.face.owner(i,2))...
       =diffusionterm(Mesh.face.owner(i,2),Mesh.face.owner(i,2))...
       +Fluid.scalar1diff*Mesh.face.Ef(i)/Mesh.face.dCF(i);
        %aF for cell F, owner 2
        diffusionterm(Mesh.face.owner(i,2),Mesh.face.owner(i,1))...
       =diffusionterm(Mesh.face.owner(i,2),Mesh.face.owner(i,1))...
       -Fluid.scalar1diff*Mesh.face.Ef(i)/Mesh.face.dCF(i);
    end
    
end