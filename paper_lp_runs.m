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

no_solvers = 4;
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

% setup third test
test(3).Method = 23;        % krylov solver
test(3).krylov_method = 11;  % PPCG
test(3).precond_method = 4; % constraint pre
test(3).inner_tol = 1e-2;   
test(3).PDConvergenceDescriptions = 'PPCG';
test(3).descriptions = ['PPCG, tol = $10^-2\\eta_k$'];

% setup fourth test
test(4).Method = 23;        % krylov_solver
test(4).krylov_method = 4;  % mpgmres
test(4).precond_method = 1; % aug lag
test(4).inner_tol = 1e-7;  
test(4).PDConvergenceDescriptions = 'aug_lag_tiny_mu';
test(4).descriptions = ['Aug lag, tol = $10^-7$'];


lp_test_loop;
