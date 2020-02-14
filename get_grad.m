function get_grad(Type)
    global Domain
    
    switch Type
        case 'pressure'
            Domain.Field.face.pressure=InterpolateValue(Domain.Mesh,Domain.Field,'pressure');
            Domain.Field.element.pressuregrad=GreenGaussGradient(Domain.Mesh,Domain.Field,'pressure');
            Domain.Field.face.pressuregrad=InterpolateGrad(Domain.Mesh,Domain.Field,'pressure');
%             dlmwrite('face.pressure.txt',Domain.Field.face.pressure);
%             dlmwrite('element.pressuregrad.txt',Domain.Field.element.pressuregrad);
%             dlmwrite('face.pressuregrad.txt',Domain.Field.face.pressuregrad);
        case 'velocity'
            Domain.Field.face.velocity=InterpolateValue(Domain.Mesh,Domain.Field,'velocity');
            Domain.Field.element.velocitygrad=GreenGaussGradient(Domain.Mesh,Domain.Field,'velocity');
            Domain.Field.face.velocitygrad=InterpolateGrad(Domain.Mesh,Domain.Field,'velocity');
%             dlmwrite('face.velocity.txt',Domain.Field.face.velocity);
%             dlmwrite('element.velocitygrad.txt',Domain.Field.element.velocitygrad);
%             dlmwrite('face.velocitygrad.txt',Domain.Field.face.velocitygrad);
        case 'PCorrect'
            Domain.Field.face.PCorrect=InterpolateValue(Domain.Mesh,Domain.Field,'pressure correction');
            Domain.Field.element.PCorrectgrad=GreenGaussGradient(Domain.Mesh,Domain.Field,'pressure correction');
            Domain.Field.face.PCorrectgrad=InterpolateGrad(Domain.Mesh,Domain.Field,'pressure correction');
%             dlmwrite('face.PCorrect.txt',Domain.Field.face.PCorrect);
%             dlmwrite('element.PCorrectgrad.txt',Domain.Field.element.PCorrectgrad);
%             dlmwrite('face.PCorrectgrad.txt',Domain.Field.face.PCorrectgrad);
        otherwise
            disp('Incorrect Type in get_grad!!');
    end
end