function Mesh=Boundaryapply(Mesh,Boundarycondition)
    global Domain
    Mesh=Domain.Mesh;
    
    boundarycondition=zeros(Mesh.face.number,4);
    % 0 presents internal face
    % 1 presents 'Specific pressure'
    % 2 presents 'Specific velocity'
    % 3 presents 'No slip wall'
    % 4 presents 'Slip wall'

    boundarynum=Mesh.face.boundarynum;

    Meshfacenodes=cell2mat([Mesh.face.nodes]);
    startpoint=Mesh.nodes(Meshfacenodes(1:boundarynum,1),:);
    endpoint  =Mesh.nodes(Meshfacenodes(1:boundarynum,2),:);

    for index=1:size(Boundarycondition,1);

        check_start=cross((startpoint-repmat(Boundarycondition{index,1},[boundarynum,1]))',(repmat(Boundarycondition{index,2},[boundarynum,1])-startpoint)');
        check_start=sqrt(check_start(1,:).^2+check_start(2,:).^2+check_start(3,:).^2);
        check_start=find(check_start<=10^-5);

        check_end=cross((endpoint-repmat(Boundarycondition{index,1},[boundarynum,1]))',(repmat(Boundarycondition{index,2},[boundarynum,1])-endpoint)');
        check_end=sqrt(check_end(1,:).^2+check_end(2,:).^2+check_end(3,:).^2);
        check_end=find(check_end<=10^-5);

        switch Boundarycondition{index,3}
            case 'Specific pressure'
                boundarycondition(intersect(check_start,check_end),1)=1;
                boundarycondition(intersect(check_start,check_end),2:4)=repmat(Boundarycondition{index,4},length(intersect(check_start,check_end)),1);
            case 'Specific velocity'
                boundarycondition(intersect(check_start,check_end),1)=2;
                boundarycondition(intersect(check_start,check_end),2:4)=repmat(Boundarycondition{index,4},length(intersect(check_start,check_end)),1);
            case 'No slip wall'
                boundarycondition(intersect(check_start,check_end),1)=3;
                boundarycondition(intersect(check_start,check_end),2:4)=repmat(Boundarycondition{index,4},length(intersect(check_start,check_end)),1);
            case 'Slip wall'
                boundarycondition(intersect(check_start,check_end),1)=4;
                boundarycondition(intersect(check_start,check_end),2:4)=repmat(Boundarycondition{index,4},length(intersect(check_start,check_end)),1);
        end
    end

    Domain.Mesh.face.boundarycondition=boundarycondition;
    
end


