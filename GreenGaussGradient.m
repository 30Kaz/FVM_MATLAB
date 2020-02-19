function elemgrad=GreenGaussGradient(Mesh,Field,Type)
    %eq(9.4)
    switch Type
        case 'pressure'
            elemgrad=zeros(Mesh.element.number,3);
            for i=1:Mesh.face.number
                %face owner 1's contribution
                elemgrad(Mesh.face.owner(i,1),:)=elemgrad(Mesh.face.owner(i,1),:)...
                                                +Field.face.pressure(i)*Mesh.face.Sf(i,:)...
                                                /Mesh.element.volume(Mesh.face.owner(i,1));
                %face owner 2's contribution, excluding boundary
                if Mesh.face.owner(i,2)~=0
                elemgrad(Mesh.face.owner(i,2),:)=elemgrad(Mesh.face.owner(i,2),:)...
                                                -Field.face.pressure(i)*Mesh.face.Sf(i,:)...
                                                /Mesh.element.volume(Mesh.face.owner(i,1));
                end
            end
            
        case 'velocity'
            elemgrad=zeros(Mesh.element.number,9);
            for i=1:Mesh.face.number
                for k=1:Mesh.Dimension
                    %face owner 1's contribution
                    elemgrad(Mesh.face.owner(i,1),3*k-2:3*k)=elemgrad(Mesh.face.owner(i,1),3*k-2:3*k)+...
                                                      +Field.face.velocity(i,k)*Mesh.face.Sf(i,:)...
                                                      /Mesh.element.volume(Mesh.face.owner(i,1));
                    %face owner 2's contribution, excluding boundary
                    if Mesh.face.owner(i,2)~=0
                    elemgrad(Mesh.face.owner(i,2),3*k-2:3*k)=elemgrad(Mesh.face.owner(i,2),3*k-2:3*k)+...
                                                      -Field.face.velocity(i,k)*Mesh.face.Sf(i,:)...
                                                      /Mesh.element.volume(Mesh.face.owner(i,2));
                    end
                end
            end
            
        case 'pressure correction'
            elemgrad=zeros(Mesh.element.number,3);
            for i=1:Mesh.face.number
                %face owner 1's contribution
                elemgrad(Mesh.face.owner(i,1),:)=elemgrad(Mesh.face.owner(i,1),:)...
                                                +Field.face.PCorrect(i)*Mesh.face.Sf(i,:)...
                                                /Mesh.element.volume(Mesh.face.owner(i,1));
                %face owner 2's contribution, excluding boundary
                if Mesh.face.owner(i,2)~=0
                elemgrad(Mesh.face.owner(i,2),:)=elemgrad(Mesh.face.owner(i,2),:)...
                                                -Field.face.PCorrect(i)*Mesh.face.Sf(i,:)...
                                                /Mesh.element.volume(Mesh.face.owner(i,1));
                end
            end
            
        case 'scalar1'
            elemgrad=zeros(Mesh.element.number,3);
            for i=1:Mesh.face.number
                %face owner 1's contribution
                elemgrad(Mesh.face.owner(i,1),:)=elemgrad(Mesh.face.owner(i,1),:)...
                                                +Field.face.scalar1(i)*Mesh.face.Sf(i,:)...
                                                /Mesh.element.volume(Mesh.face.owner(i,1));
                %face owner 2's contribution, excluding boundary
                if Mesh.face.owner(i,2)~=0
                elemgrad(Mesh.face.owner(i,2),:)=elemgrad(Mesh.face.owner(i,2),:)...
                                                -Field.face.scalar1(i)*Mesh.face.Sf(i,:)...
                                                /Mesh.element.volume(Mesh.face.owner(i,1));
                end
            end
    end
end