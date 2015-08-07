% A driver for running opt problems with Saunders' PDCO
% and testing my post-processing code

clear all
close all

problem = importdata('netlib.txt');
length_problem = length(problem);
length_problem = 1;

max_sigma(length_problem) = 0;

%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%!! S E T U P    T E S T S  !!
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

no_solvers = 3;
test = struct('Method',{},...
              'krylov_method',{},...
              'precond_method',{},...
              'inner_tol',{},...
              'PDConvergenceDescrptions',{},...
              'descriptions',{});

% setup first test
test(1).Method = 224;        % backslash
test(1).krylov_method = 0;  % none
test(1).precond_method = 0; % none
test(1).inner_tol = 0.0;    % none
test(1).PDConvergenceDescriptions = 'lt_exact_convergence';
test(1).descriptions = '$A\backslash b$';

% setup second test
test(2).Method = 23;        % krylov solver
test(2).krylov_method = 4;  % mpgmres
test(2).precond_method = 1; % aug lag
test(2).inner_tol = 1e-1;    
test(2).PDConvergenceDescriptions = 'aug_lag';
test(2).descriptions = ['Aug lag, tol = $10^-1\\eta_k$'];

% setup second test
test(3).Method = 23;        % krylov solver
test(3).krylov_method = 11;  % PPCG
test(3).precond_method = 4; % constraint pre
test(3).inner_tol = 1e-2;   
test(3).PDConvergenceDescriptions = 'PPCG';
test(3).descriptions = ['PPCG, tol = $10^-1\\eta_k$'];

% setup second test
test(4).Method = 23;        % krylov_solver
test(4).krylov_method = 4;  % mpgmres
test(4).precond_method = 1; % aug lag
test(4).inner_tol = 1e-7;  
test(4).PDConvergenceDescriptions = 'aug_lag_tiny_mu';
test(4).descriptions = ['Aug lag, tol = $10^-7$'];


for i = 1:length_problem

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


plot_convergence(no_solvers,extras,test,1)