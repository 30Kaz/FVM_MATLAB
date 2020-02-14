function product=TensorDotVec(Tensor,Vec)
    if size(Tensor,1)==size(Vec,1) && size(Tensor,2)==9 && size(Vec,2)==3
        product=[sum(Tensor(:,1:3).*Vec,2),...
                 sum(Tensor(:,4:6).*Vec,2),...
                 sum(Tensor(:,7:9).*Vec,2)];
    else
        disp("Problem with Tensor or Vector size")
    end
end