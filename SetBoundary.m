function SetBoundary()
    %{
    - For pressure outlet, (15.140),(15.141) aren't done, instead,
    extrapolation method same as other boundary condition.
    - Only 2D
    - Types:    'Specific pressure'
                'Specific velocity'
                'No slip wall'
                'Slip wall'
    -For each row, first two elements constitute a boundary, third type,
    fourth velocity vector or pressure
    %}
    global Domain
%     rid-driven
%     Boundarycondition={[0,0,0],[1,0,0],'No slip wall',[0,0,0];
%                        [1,0,0],[1,1,0],'No slip wall',[0,0,0];
%                        [0,1,0],[1,1,0],'No slip wall',[1,0,0];
%                        [0,0,0],[0,1,0],'No slip wall',[0,0,0];};
    %left to bottom
%    Boundarycondition={[0,0,0],[1,0,0],'Specific pressure',[0,0,0];
%                        [1,0,0],[1,1,0],'No slip wall',[0,0,0];
%                        [0,1,0],[1,1,0],'No slip wall',[0,0,0];
%                        [0,0,0],[0,1,0],'Specific velocity',[1.0,0,0];};
     %left to right and top
%    Boundarycondition={[0,0,0],[1,0,0],'No slip wall',[0,0,0];
%                        [1,0,0],[1,1,0],'Specific velocity',[0.5,0,0];
%                        [0,1,0],[1,1,0],'Specific velocity',[0,0.5,0];
%                        [0,0,0],[0,1,0],'Specific velocity',[1,0,0];};
    %left to right
    Boundarycondition={[0,0,0],[1,0,0],'No slip wall',[0,0,0];
                       [1,0,0],[1,1,0],'Specific pressure',[0,0,0];
                       [0,1,0],[1,1,0],'No slip wall',[0,0,0];
                       [0,0,0],[0,1,0],'Specific velocity',[1,0,0];};
%    Boundarycondition={[0,0,0],[1,0,0],'Specific velocity',[0,-1,0];
%                        [1,0,0],[1,1,0],'No slip wall',[0,0,0];
%                        [0,1,0],[1,1,0],'No slip wall',[0,0,0];
%                        [0,0,0],[0,1,0],'Specific velocity',[1,0,0];};
%    Boundarycondition={[0,0,0],[1,0,0],'No slip wall',[0,0,0];
%                        [1,0,0],[1,1,0],'Specific velocity',[1,0,0];
%                        [0,1,0],[1,1,0],'No slip wall',[0,0,0];
%                        [0,0,0],[0,1,0],'Specific velocity',[1,0,0];};

    Boundaryapply2D(Domain.Mesh,Boundarycondition);
    BCtoFieldFace(Domain.Mesh,Domain.Fluid);
end