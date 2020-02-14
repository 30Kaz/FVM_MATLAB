function correction()
    %{
    - (15.101)
    %}
    global Domain
    Mesh=Domain.Mesh;
    Field=Domain.Field;
    Fluid=Domain.Fluid;
    Solutionsystem=Domain.Solutionsystem;
    interiorface=Mesh.face.boundarynum+1:Mesh.face.number;
    
%     dlmwrite('element.velocity_uncorrected.txt',Field.element.velocity);
%     dlmwrite('face.flux_uncorrected.txt',Field.face.flux);
%     dlmwrite('element.pressure_uncorrected.txt',Field.element.pressure);
    
    Field.element.velocity=Field.element.velocity...
                          -Field.element.Dc.*Field.element.PCorrectgrad;
    
    Field.face.flux(interiorface)=Field.face.flux(interiorface)...
             -Fluid.density*sum(Field.face.Dv_f(interiorface,:).*Field.face.PCorrectgrad(interiorface,:).*Mesh.face.Sf(interiorface,:),2);
    
    Field.element.pressure=Field.element.pressure...
                          +Solutionsystem.relax_pressure*Field.element.PCorrect;
    
                      
    Domain.Field.element.velocity=Field.element.velocity;
    Domain.Field.face.flux(interiorface)=Field.face.flux(interiorface);
    Domain.Field.element.pressure=Field.element.pressure;
    
%     dlmwrite('element.velocity_corrected.txt',Domain.Field.element.velocity);
%     dlmwrite('face.flux_corrected.txt',Domain.Field.face.flux);
%     dlmwrite('element.pressure_corrected.txt',Domain.Field.element.pressure);
end