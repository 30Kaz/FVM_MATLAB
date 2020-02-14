function [MomMat,MomRHS]=RelaxMom(MomMat,MomRHS,Mesh,Field,Solutionsystem)
    %{
    - relaxation factors'name may need to be renamed, as well as the
      hierachical structure of Solutionsystem
    %}
    
%     MomMat=MomMat/Solutionsystem.relax_velocity;
    
    for k=1:Mesh.Dimension
        for i=1:Mesh.element.number
            MomRHS(i,k)=MomRHS(i,k)+(1-Solutionsystem.relax_velocity)/Solutionsystem.relax_velocity...
                       *MomMat(i,i,k)*Field.element.velocity(i,k);
            MomMat(i,i,k)=MomMat(i,i,k)/Solutionsystem.relax_velocity;
            
        end
%         
%         MomRHS(:,k)=MomRHS(:,k)+(1-Solutionsystem.relax_velocity)/Solutionsystem.relax_velocity...
%             *MomMat(:,:,k)*Field.element.velocity(:,k);
    end
    
end