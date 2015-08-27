% A driver for running opt problems with Saunders' PDCO
% and testing my post-processing code

clear all
close all

problem = importdata('netlib.txt');
length_problem = length(problem);

imgname = 'ne_changetol_';

first_prob = 1;
%length_problem = 20;

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
test(2).inner_tol = 1e2;    
test(2).PDConvergenceDescriptions = 'CG, tol 10^2 * mu * delta ';
test(2).descriptions = ['Norm Eqns, tol = $10^{2} \\mu \\delta$'];

% setup third test
test(3) = test(2);
test(3).inner_tol = 1;   
test(3).PDConvergenceDescriptions = 'CG, tol mu * delta';
test(3).descriptions = ['Norm Eqns, tol = $\\mu \\delta$'];

CalculateError = 0;
ScaleTol = 1;

lp_test_loop;
