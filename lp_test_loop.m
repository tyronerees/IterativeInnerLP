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
    
    options.mu0       = 0e-0;  % An absolute value
    options.wait      = 0;     
    options.MaxIter   = 80;
    options.gamma     = 1e-16;
    
    options.FeaTol    = 1e-7;
    options.OptTol    = 1e-7;
    options.LSMRMaxIter = 100;
    
    if exist('CalculateError')
        options.CalculateError = CalculateError;
    end
    if exist('ScaleTol')
        options.ScaleTol = ScaleTol;
    end
    
    gamma = 0.0;
    delta = 0.0;
    
    for j = 1:no_solvers
        %!!!!!!!!!!!!!!!!!!!!!!!!!!%
        %! Loop over the solvers  !%
        %!!!!!!!!!!!!!!!!!!!!!!!!!!%
        
        fprintf('\n\n')
        fprintf('###################\n')
        fprintf(['##  ',problem{i},'\n'])
        fprintf('###################\n')
        
        
        
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
        if (sum(isnan(x)) + sum(isnan(y)) + sum(isnan(z)))
            % NaN in one of the solutions....something's gone wrong!
            inform = 100;
        end
        if (j == 1) && (inform ~= 0)
            fprintf('move along...didn''t work with backslash\n')
            for j = 1:no_solvers
                itvec{j,i} = 0;
                PDitns{j,i} = 0;
                CGitns{j,i} = 0;
                time{j,i} = 0;
            end
            lp_post;
            break
        elseif inform ~= 0
            itvec{j,i} = 0;
            PDitns{j,i} = 0;
            CGitns{j,i} = 0;
            time{j,i} = 0;
            lp_post;
            continue
        end
        itvec{j,i} = iv(1:PDitns{j,i});
        
        lp_post;
    end
end

lp_runs_writetable;


plot_convergence(no_solvers,extras,test,first_prob,[imgname,'ip_'])
if options.CalculateError
    plot_inner_convergence(no_solvers,extras,test,first_prob,[imgname,'err_'])
end