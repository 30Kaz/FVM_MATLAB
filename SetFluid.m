function SetFluid()
    global Domain
    Domain.Fluid.density=1000;
    Domain.Fluid.viscosity=30;
    
    Domain.Fluid.scalar1diff=0.0;   % diffusion coefficient of scalar1
    
end