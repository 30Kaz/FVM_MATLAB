function Mesh = GmshFileRead( Filename, Dimension)
    %{
      - dCf added near the bottom
    %}
  t1=clock;

  Mesh.Dimension=Dimension;
  
  input = fopen ( Filename, 'rt' );

  if ( input < 0 )
    fprintf ( 1, '\n' );
    fprintf ( 1, 'GMSH_DATA_READ - Error!\n' );
    fprintf ( 1, '  Could not open the input file "%s".\n', gmsh_filename );
    error ( 'GMSH_DATA_READ - Error!' );
    return
  end

  level = 0;
  while ( 1 )
    text = fgetl ( input );
    if ( text == -1 )
      break
    end
    if ( level == 0 )
      if ( s_begin ( text(1:6), '$Nodes' ) )
        level = 1;
      end
    elseif ( level == 1 )
      [ value, count ] = sscanf ( text, '%d' );
       nodes = zeros ( value(1), 3 );
      level = 2;
    elseif ( level == 2 )
      if ( s_begin ( text(1:7), '$EndNodes' ) )
        break
      else
        [ value, count ] = sscanf ( text, '%d  %f  %f  %f' );
        nodes(value(1),:) = value(2:4)';
      end
    end
  end
  
  Mesh.nodes=nodes;
  nodenum=size(Mesh.nodes,1);
%
%  Now read face and element information.
%
  level = 0;

  while ( 1 )
    text = fgetl ( input );
    if ( text == -1 )
      fprintf ( 'ran out\n' );
      break
    end
    if ( level == 0 )
      if ( s_begin ( text(1:7), '$Elements' ) )
        level = 1;
        i=0;
        j=0;
      end
    elseif ( level == 1 )
      [ value, count ] = sscanf ( text, '%d' );
      face = cell ( value(1), 1 );
      element = cell ( value(1), 1 );
      face_nodes= zeros(value(1),size(Mesh.nodes,1));
      element_nodes= zeros(value(1),size(Mesh.nodes,1));
      level = 2;
    elseif ( level == 2 )
      if ( s_begin ( text(1:12), '$EndElements' ) )
        break
      else
        [ value, count ] = sscanf ( text, '%d' );
        if Dimension==1
            if value(2)==15
                i = i + 1;
                face{i,1} = value(count:count)';
                face_nodes(i,face{i,1})=1;
            end
            if value(2)==1
                j = j + 1;
                element{j,1} = value(count-type2num(value(2))+1:count)';
                element_nodes(j,element{j,1})=1;
            end
        end

        if Dimension==2
            if value(2)==1
                i = i + 1;
                face{i,1} = value(count-1:count)';
                face_nodes(i,face{i,1})=1;
            end
            if ismember(value(2),[2,3])
                j = j + 1;
                element{j,1} = value(count-type2num(value(2))+1:count)';
                element_nodes(j,element{j,1})=1;
            end
        end
        if Dimension==3
            if ismember(value(2),[2,3])
                i = i + 1;
                face{i,1} = value(count-type2num(value(2))+1:count)';
                face_nodes(i,face{i,1})=1;
            end
            if ismember(value(2),[4,5])
                j = j + 1;
                element{j,1} = value(count-type2num(value(2))+1:count)';
                element_nodes(j,element{j,1})=1;
            end
        end
      end
    end
  end
  
  fclose ( input );
    
  face=face(1:i,1);
  element=element(1:j,1);
  face_nodes= face_nodes(1:i,:);
  element_nodes= element_nodes(1:j,:);
  
  % delete the faces on the conincident boundary
  vector=[];
  for index1=1:i
      Owners=find(sum(element_nodes(:,find(face_nodes(index1,:)~=0)),2)==max(sum(element_nodes(:,find(face_nodes(index1,:)~=0)),2)));
      if size(Owners,1)==2
          vector=[vector,index1];
      end
  end
  face=face(setdiff([1:i],vector),1);
  face_nodes= face_nodes(setdiff([1:i],vector),:);
  
  i=i-size(vector,2);
  boundarynum=i;
  
  t2=clock;
  etime(t2,t1);
  
  face_nodes=[face_nodes;zeros(2*j,nodenum)];
  % find the other faces
  for index1=1:j-1
      if Dimension==1
          neighbour_elm=find(sum(element_nodes(index1+1:j,find(element_nodes(index1,:)~=0)),2)==1)+index1;
          for index2=1:size(neighbour_elm,1)
              i=i+1;
              face{i,1}=[intersect(element{index1,1},element{neighbour_elm(index2),1})];
              face_nodes(i,face{i,1})=1;
          end
      end

      if Dimension==2
          neighbour_elm=find(sum(element_nodes(index1+1:j,find(element_nodes(index1,:)~=0)),2)==2)+index1;
          for index2=1:size(neighbour_elm,1)
              i=i+1;
              face{i,1}=[intersect(element{index1,1},element{neighbour_elm(index2),1})];
              face_nodes(i,face{i,1})=1;
          end
      end
      if Dimension==3
          neighbour_elm=find(sum(element_nodes(index1+1:j,find(element_nodes(index1,:)~=0)),2)>=3)+index1;
          for index2=1:size(neighbour_elm,1)
              i=i+1;
              face{i,1}=[intersect(element{index1,1},element{neighbour_elm(index2),1})];
              face_nodes(i,face{i,1})=1;
          end
      end
  end
  face_nodes= face_nodes(1:i,:);
  
  t3=clock;
  etime(t3,t2);
  % find the centroid, area, Sf, owner and neighbour for each face...
  % neighbours for each element
  centroid=zeros(i,3);
  area=zeros(i,1);
  owner=zeros(i,2);
  Sf=zeros(i,3);
  face_elm=cell(j,1);
  neighbour_elm=cell(j,1);
  for index1=1:i
      nodenum_face=length(face{index1});
      Geocenter=zeros(1,3);
      for index2=1:nodenum_face
          Geocenter=Geocenter+Mesh.nodes(face{index1}(index2),:)/nodenum_face;
      end
      centroid(index1,:)=Geocenter;
      if nodenum_face==1
          Sf(index1,:)=[1,0,0];
          area(index1,1)=1;
      elseif nodenum_face==2
          Sf(index1,:)=[Mesh.nodes(face{index1}(2),2)-Mesh.nodes(face{index1}(1),2),...
                                Mesh.nodes(face{index1}(1),1)-Mesh.nodes(face{index1}(2),1),0];
          area(index1,1)=norm(Mesh.nodes(face{index1}(1),:)-Mesh.nodes(face{index1}(2),:));
      elseif nodenum_face==3
          Sf(index1,:)=surfacevector(Mesh.nodes(face{index1}(1),:),Mesh.nodes(face{index1}(2),:),Mesh.nodes(face{index1}(3),:));
          area(index1,1)=1/2*norm(Sf{index1,1});
      else
          %not applicable to 3D
          polygonarea=1/2*norm(surfacevector(Mesh.nodes(face{index1}(1),:),Mesh.nodes(face{index1}(nodenum_face),:),Geocenter));
          Centroid=polygonarea*mean([Mesh.nodes(face{index1}(1),:);Mesh.nodes(face{index1}(nodenum_face),:);Geocenter]);
          for index2=1:nodenum_face-1
              polygonarea=polygonarea+1/2*norm(surfacevector(Mesh.nodes(face{index1}(index2),:),Mesh.nodes(face{index1}(index2+1),:),Geocenter));
              Centroid=Centroid+1/2*norm(surfacevector(Mesh.nodes(face{index1}(index2),:),Mesh.nodes(face{index1}(index2+1),:),Geocenter))*...
                                mean([Mesh.nodes(face{index1}(index2),:),Mesh.nodes(face{index1}(index2+1),:),Geocenter]);
          end
          area(index1,1)=polygonarea;
          centroid(index1,:)=Centroid/polygonarea;
          Sf(index1,:)=polygonarea*surfacevector(Mesh.nodes(face{index1}(1),:),Mesh.nodes(face{index1}(nodenum_face),:),Geocenter)...
                               /norm(surfacevector(Mesh.nodes(face{index1}(1),:),Mesh.nodes(face{index1}(nodenum_face),:),Geocenter));
      end

      vector=sum(element_nodes(:,face{index1}),2);
      Owners=find(vector==max(vector));
      if size(Owners,1)==1
        owner(index1,1)=Owners;
        face_elm{Owners,1}=[face_elm{Owners,1},index1];
        neighbour_elm{Owners,1}=[neighbour_elm{Owners,1},0];
      else
        owner(index1,:)=Owners; 
        face_elm{Owners(1),1}=[face_elm{Owners(1),1},index1];
        neighbour_elm{Owners(1),1}=[neighbour_elm{Owners(1),1},Owners(2)];
        face_elm{Owners(2),1}=[face_elm{Owners(2),1},index1];
        neighbour_elm{Owners(2),1}=[neighbour_elm{Owners(2),1},Owners(1)];
      end
  end
  
  Mesh.face=struct('nodes',{face},'centroid',centroid,'area',area,'owner',owner,'Sf',Sf,'number',i,'boundarynum',boundarynum);
  
  t4=clock;
  etime(t4,t3);
  
  
   % find the centroid, volume for each element...
  centroid=zeros(j,3);
  volume=zeros(j,1);
  for index1=1:j
      nodenum_elm=length(element{index1});
      Geocenter=zeros(1,3);
      for index2=1:nodenum_elm
          Geocenter=Geocenter+Mesh.nodes(element{index1}(index2),:)/nodenum_elm;
      end
      if nodenum_elm==2
          centroid(index1,:)=Geocenter;
          volume(index1,1)=norm(Mesh.nodes(element{index1}(1),:)-Mesh.nodes(element{index1}(2),:));
      elseif nodenum_elm==3
          centroid(index1,:)=Geocenter;
          volume(index1,1)=1/2*norm(surfacevector(Mesh.nodes(element{index1}(1),:),Mesh.nodes(element{index1}(2),:),Mesh.nodes(element{index1}(3),:)));
      else
          %quadrangle
          polygonarea=0;
          Centroid=zeros(1,3);
          for index2=1:length(face_elm{index1,1})
              polygonarea=polygonarea+1/2*norm(surfacevector(Mesh.nodes(Mesh.face.nodes{face_elm{index1,1}(index2)}(1),:),Mesh.nodes(Mesh.face.nodes{face_elm{index1,1}(index2)}(2),:),Geocenter));
              Centroid=Centroid+1/2*norm(surfacevector(Mesh.nodes(Mesh.face.nodes{face_elm{index1,1}(index2)}(1),:),Mesh.nodes(Mesh.face.nodes{face_elm{index1,1}(index2)}(2),:),Geocenter))*...
                       mean([Mesh.nodes(Mesh.face.nodes{face_elm{index1,1}(index2)}(1),:);Mesh.nodes(Mesh.face.nodes{face_elm{index1,1}(index2)}(2),:);Geocenter]);
          end          
          centroid(index1,:)=Centroid/polygonarea;
          volume(index1,1)=polygonarea;
      end

  end
  
  Mesh.element=struct('nodes',{element},'centroid',centroid,'volume',volume, 'face', {face_elm}, 'neighbour', {neighbour_elm},'number',j);
  
  t5=clock;
  etime(t5,t4);

  % calculate other necessary data for face
  Mesh.face.dCF=zeros(Mesh.face.number,1);%distance between the centroids of the two elements or element and face
  Mesh.face.Ef =zeros(Mesh.face.number,1);%effective width of the face (over-relaxed approach)
  Mesh.face.ecf=zeros(Mesh.face.number,3);%unit vector along the centroids
  Mesh.face.gcf=zeros(Mesh.face.number,2);%ratio for the two elements
  vector_CF=zeros(Mesh.face.number,3);
  
  vector_CF(1:boundarynum    ,:)=Mesh.face.centroid(1:boundarynum,:)...
                                -Mesh.element.centroid(Mesh.face.owner(1:boundarynum,1),:);  
  vector_CF(boundarynum+1:end,:)=(Mesh.element.centroid(Mesh.face.owner(boundarynum+1:Mesh.face.number,2),:)...
                                 -Mesh.element.centroid(Mesh.face.owner(boundarynum+1:Mesh.face.number,1),:));
  vector_Cf=(Mesh.face.centroid(boundarynum+1:Mesh.face.number,:)...
            -Mesh.element.centroid(Mesh.face.owner(boundarynum+1:Mesh.face.number,1),:));
  vector_fF=(Mesh.element.centroid(Mesh.face.owner(boundarynum+1:Mesh.face.number,2),:)...
            -Mesh.face.centroid(boundarynum+1:Mesh.face.number,:));
  Mesh.face.dCF(:,1)=sqrt(vector_CF(:,1).^2+vector_CF(:,2).^2);
  Mesh.face.gcf(boundarynum+1:end,:)=[sqrt(vector_fF(:,1).^2+vector_fF(:,2).^2)./(sqrt(vector_Cf(:,1).^2+vector_Cf(:,2).^2)+sqrt(vector_fF(:,1).^2+vector_fF(:,2).^2)),...
                                      sqrt(vector_Cf(:,1).^2+vector_Cf(:,2).^2)./(sqrt(vector_Cf(:,1).^2+vector_Cf(:,2).^2)+sqrt(vector_fF(:,1).^2+vector_fF(:,2).^2))];
  Mesh.face.ecf=vector_CF./repmat(Mesh.face.dCF,[1,3]);
  
  %Added by Kazuya 
  Mesh.face.dCf=zeros(Mesh.face.number,2);
  Mesh.face.dCf(1:boundarynum,1)=sqrt(sum(vector_CF(1:boundarynum,:).^2,2));
  Mesh.face.dCf(boundarynum+1:Mesh.face.number,1)=sqrt(sum(vector_Cf.^2,2));
  Mesh.face.dCf(boundarynum+1:Mesh.face.number,2)=sqrt(sum(vector_fF.^2,2));
  
  %correct the Sf direction for face
  Mesh.face.Sf=Mesh.face.Sf.*repmat(sign(sum(Mesh.face.Sf.*Mesh.face.ecf,2)),[1,3]);
  
  % Minimum Correction Approach
  Mesh.face.Ef=sum(Mesh.face.ecf.*Mesh.face.Sf,2);
  Mesh.face.Tf=Mesh.face.Sf-repmat(Mesh.face.Ef,[1,3]).*Mesh.face.ecf;
  
%   %Orthogonal Correction Approach
%   Mesh.face.Ef=norm(Mesh.face.Sf);
%   Mesh.face.Tf=Mesh.face.Sf-repmat(Mesh.face.Ef,[1,3]).*Mesh.face.ecf;
%   
%   % Over-relaxed Approach
%   Mesh.face.Ef=sum(Mesh.face.Sf.*Mesh.face.Sf,2)./sum(Mesh.face.Sf.*Mesh.face.ecf,2);
%   Mesh.face.Tf=Mesh.face.Sf-repmat(Mesh.face.Ef,[1,3]).*Mesh.face.ecf;
  
  t6=clock;
  fprintf('\n');
  fprintf('Time for file read:');
  fprintf('%4.1f s',etime(t6,t1));
  fprintf('\n');
  fprintf('\n*****************************************************\n');
    
  return
end

