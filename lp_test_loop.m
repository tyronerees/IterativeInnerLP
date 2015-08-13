%lp_test_loop.m
% 
% requires 'test = struct('Method',{},...
%              'krylov_method',{},...
%             'precond_method',{},...
%             'inner_tol',{},...
%             'PDConvergenceDescrptions',{},...
%             'descriptions',{});' 
% and 'problem' (from netlib) structures to be defined
% together with scalars length_problem, max_sigma, no_solvers


for i = first_prob:first_prob + length_problem - 1

    %!!!!!!!!!!!!!!!!!!!!!!!!!!%
    %! Loop over the problems !%
    %!!!!!!!!!!!!!!!!!!!!!!!!!!%
    probstring = ['/numerical/trees/matrices/netlib_problems/',problem{i}];
    %    load(problem{i});
    load(probstring);
    
    lp_setup;
    
    max_sigma(i) = svds(A,1)
    
    conv_data.max_sigma = max_sigma(i);
    options.conv_data = conv_data;
    
    options.mu0       = 0e-0;  % An absolute value
    options.wait      = 0;     
    options.MaxIter   = 50;
    options.gamma     = 1e-16;
    
    options.FeaTol    = 1e-7;
    options.OptTol    = 1e-7;
    options.LSMRMaxIter = 100;
    
    options.CalculateError = 1;
    
    gamma = 0.0;
    delta = 0.0;
    
    for j = 1:no_solvers
        %!!!!!!!!!!!!!!!!!!!!!!!!!!%
        %! Loop over the solvers  !%
        %!!!!!!!!!!!!!!!!!!!!!!!!!!%
        
        d1      = gamma;      % Can be scalar if D1 = d1*I.
        d2      = delta*ones(m,1);
        options.Method = test(j).Method;
        options.krylov_method = test(j).krylov_method;
        options.precond_method = test(j).precond_method;
        options.LSMRatol1 = test(j).inner_tol;
        options.LSMRatol2 = test(j).inner_tol;
          
        d1      = gamma;      % Can be scalar if D1 = d1*I.
        d2      = delta*ones(m,1);
        [x,y,z,inform,PDitns{j,i},CGitns{j,i},time{j,i},iv,extras{j,i}] = ...
            pdco(c,A,b,bl,bu,d1,d2,options,x0, ...
                     y0,z0,xsize,zsize );
        itvec{j,i} = iv(1:PDitns{j,i});
        
        lp_post;
    end
end

lp_runs_writetable;


plot_convergence(no_solvers,extras,test,first_prob)
if options.CalculateError
    plot_inner_convergence(no_solvers,extras,test,first_prob)
end