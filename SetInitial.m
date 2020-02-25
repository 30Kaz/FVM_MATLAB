function SetInitial()
    %{
    - should normally be turned off
    %}
    global Domain;
    
    Domain.Field.element.velocity=ones(size(Domain.Field.element.velocity));    %(u,v)=(1,1) everywhere
end