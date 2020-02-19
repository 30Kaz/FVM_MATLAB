b=3;
a=1+2+b...  %tripledot(...) works only after a variable, not number!
    +4

%%
% %% works only for run and advance, not for run

%%
figure(5)
x=0:0.1:10;

y1=sin(x)+2;
y2=cos(x)+2;
y3=x;

%plot(y1,'color','y','LineWidth',2);
semilogy(y1,'color','y','LineWidth',2);
hold on;
%plot(y2,'color','m','LineWidth',2);
semilogy(y2,'color','m','LineWidth',2);
yyaxis right;
%plot(y3,'color','b','LineWidth',2);
semilogy(y3,'color','b','LineWidth',2);
legend('y1','y2','y3');
hold off;

%%
for iter=1:3
    for j=1:3
        for k=1:3
            iter*j*k;  %test
        end
        iter*j;%test
    end
    disp(iter)
end

%%
a='Velooooooooooooooocity'
switch a
    case 'Pressure'
        disp('This is case Pressure');
    case 'Velocity'
        disp('This is case Velocity');
    case 3
        disp('This is case 3');
end
%When no case matches the imput, nothing happens, no error.


%%
%test double while loop
timestep=0;
iter=0;
tic
while(1)
    timestep=timestep+1;
    disp(['timestep = ' num2str(timestep)]);
    while(1)
        iter=iter+1;
%         disp(['iter = ' num2str(iter)]);
        if mod(iter,5)==0
            break
        end
    end
    if timestep>=30000
        break
    end
end
% toc
fprintf('Elapsed time : %d min %2g sec\n', floor(toc/60), rem(toc,60));
% fprintf('%d minutes and %f seconds\n', floor(toc/60), rem(toc,60));
%%
if Domain.Solutionsystem.transient=='on'
    disp('yes')
end

