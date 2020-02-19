function Plotresults(Mesh,Field,Solutionsystem)

%if strcmp(Mesh.meshtype,'Uniform')
%{
global Domain
Mesh=Domain.Mesh;
Field=Domain.Field;
%}

Nodes=cell2mat(Mesh.element.nodes);
x=zeros(size(Nodes,2),size(Nodes,1));
y=zeros(size(Nodes,2),size(Nodes,1));
for index=1:size(Nodes,2)
x(index,:)=Mesh.nodes(Nodes(:,index),1)';
y(index,:)=Mesh.nodes(Nodes(:,index),2)';
end

%Velocity vector
figure(2)
clf
patch(x,y,[1,1,1])
view(2)
axis equal
axis off
ax=axis;
axis(ax*1.001);
hold on
h1=quiver(Mesh.element.centroid(:,1),Mesh.element.centroid(:,2),Field.element.velocity(:,1),Field.element.velocity(:,2));
set(h1,'AutoScale','on', 'AutoScaleFactor', 2)
title(join(['Velocity, Time = ' num2str(Solutionsystem.solutiontime) '[s]']));

saveas(gcf,join([pwd '/output/VelocField_' num2str(Solutionsystem.timelevel) '.png']))

n = length(findobj('type','figure'));

%Velocity contour
figure(3)
%figure(n+1)
clf
patch(x,y,sqrt(Field.element.velocity(:,1).^2+Field.element.velocity(:,2).^2+Field.element.velocity(:,3).^2))
colorbar
colormap(jet)
title(join(['Velocity Contour, Time = ' num2str(Solutionsystem.solutiontime) '[s]']));
caxis([0,1]);

view(2)
axis equal
axis off
ax=axis;
axis(ax*1.001);
saveas(gcf,join([pwd '/output/VelocityContour_' num2str(Solutionsystem.timelevel) '.png']))

%Pressure
figure(4)
%figure(n+2)
clf
patch(x,y,Field.element.pressure)
colorbar
colormap(jet)
title(join(['Pressure, Time = ' num2str(Solutionsystem.solutiontime) '[s]']));
caxis([-1200 1500]);

view(2)
axis equal
axis off
ax=axis;
axis(ax*1.001);
saveas(gcf,join([pwd '/output/Pressure_' num2str(Solutionsystem.timelevel) '.png']))

%Scalar1
if Solutionsystem.scalarmode==1
    figure(5)
    %figure(n+2)
    clf
    patch(x,y,Field.element.scalar1)
    colorbar
    colormap(jet)
    title(join(['scalar1, Time = ' num2str(Solutionsystem.solutiontime) '[s]']));
    caxis([0 1]);
    view(2)
    axis equal
    axis off
    ax=axis;
    axis(ax*1.001);
    saveas(gcf,join([pwd '/output/scalar1_' num2str(Solutionsystem.timelevel) '.png']))
end
%else
    


%end


end

