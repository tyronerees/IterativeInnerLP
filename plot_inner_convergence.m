function plot_inner_convergence(no_solvers,extras,test,problem)


% setup for plot_cc
for i = 1:no_solvers
    res(i).resvec = extras{i,problem}.residual;%residual(:,i);
    res(i).description = test(i).descriptions;
    con_viol(i).resvec = extras{i,problem}.constraint_violation;% constraint_violation(:,i);
    con_viol(i).description = test(i).descriptions;
    Lag(i).resvec = extras{i,problem}.Lagrangian;%Lagrangian(:,i);
    Lag(i).description = test(i).descriptions;
    figure(i+3)
    semilogy(extras{i,problem}.RelRes,'r-o')
    hold on, %semilogy(extras{i,problem}.dualfeas,'k-x') 
    %    semilogy(extras{i,problem}.complementray,'b-.')
    semilogy(extras{i,problem}.mu.^0.5,'k-x')
    semilogy(extras{i,problem}.mu,'b-*')
    hold off
    legend('final residual','\mu^{1/2}','\mu')
    saveas(i,['img/xxx.png'],'png');
end

%plot_cc('paper',2,'blash_minres_residuals',res)