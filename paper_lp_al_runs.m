% A driver for running opt problems with Saunders' PDCO
% and testing my post-processing code

clear all
close all

problem = importdata('netlib.txt');
length_problem = length(problem);
length_problem = 1;

imgname = 'al_runs_';

first_prob = 1;
max_sigma(length_problem) = 0;

%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%!! S E T U P    T E S T S  !!
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

no_solvers = 5;
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
test(2).krylov_method = 2;  % mpgmres
test(2).precond_method = 1; % aug lag
test(2).inner_tol = 1e-4;    
test(2).PDConvergenceDescriptions = 'aug_lag, loose tol';
test(2).descriptions = ['Aug lag, tol = $10^{-4}$'];

% setup third test
test(3) = test(2);
test(3).inner_tol = 1e-6;   
test(3).PDConvergenceDescriptions = 'aug_lag, tighter tol';
test(3).descriptions = ['PPCG, tol = $10^-{-6}$'];

% setup fourth test
test(4) = test(2);
test(4).inner_tol = 1e-8;   
test(4).PDConvergenceDescriptions = 'aug_lag, tightest tol';
test(4).descriptions = ['PPCG, tol = $10^-{8}$'];

% setup fourth test
test(5) = test(2);
test(5).inner_tol = 1e-10;   
test(5).PDConvergenceDescriptions = 'aug_lag, tightest tol';
test(5).descriptions = ['PPCG, tol = $10^-{10}$'];

lp_test_loop;
