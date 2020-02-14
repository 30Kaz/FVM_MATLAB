function node_num = type2num( elm_type )
switch elm_type
    case 1
        node_num=2; % 2-node line
    case 2
        node_num=3; % 3-node triangle
    case 3
        node_num=4; % 4-node quadrangle
    case 4
        node_num=4; % 4-node tetrahedron
    case 5
        node_num=8; % 8-node tetrahedron

end

