function SetFluid()
    global Domain
    Domain.Fluid.density=1000;
    Domain.Fluid.viscosity=1;
    
    Domain.Fluid.scalar1diff=5.0;   % diffusion coefficient of scalar1
    
end