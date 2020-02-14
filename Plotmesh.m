function Plotmesh( Mesh )

t1=clock;

Nodes=cell2mat(Mesh.element.nodes);
x=zeros(size(Nodes,2),size(Nodes,1));
y=zeros(size(Nodes,2),size(Nodes,1));
for index=1:size(Nodes,2)
x(index,:)=Mesh.nodes(Nodes(:,index),1)';
y(index,:)=Mesh.nodes(Nodes(:,index),2)';
end

figure(1)
clf
patch(x,y,[1,1,1])
view(2)
axis equal
axis off
ax=axis;
axis(ax*1.001);

t2=clock;
etime(t2,t1);

end

