% A driver for running opt problems with Saunders' PDCO
% and testing my post-processing code

clear all
close all

problem = importdata('netlib.txt');
length_problem = length(problem);

first_prob = 1;
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
test(1).Method = 1;        % backslash
test(1).krylov_method = 0;  % none
test(1).precond_method = 0; % none
test(1).inner_tol = 0.0;    % none
test(1).PDConvergenceDescriptions = 'lt_exact_convergence';
test(1).descriptions = '$A\backslash b$';

% setup second test
test(2).Method = 5;        % pcg
test(2).inner_tol = 1e-2;    
test(2).PDConvergenceDescriptions = 'CG';
test(2).descriptions = ['Aug lag, tol = $10^{-2}$'];

% setup third test
test(3) = test(2);
test(3).inner_tol = 1e-5;   
test(3).PDConvergenceDescriptions = 'CG, tighter tol';
test(3).descriptions = ['Aug lag, tol = $10^-8$'];


lp_test_loop;
