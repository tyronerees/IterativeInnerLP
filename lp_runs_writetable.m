fprintf('Problem');
for i = 1:no_solvers
    fprintf([' & ',test(i).descriptions ]);
end 
fprintf('\\\\ \n');

for i = first_prob:first_prob + length_problem - 1
    fprintf(problem{i}(1:end-4)); % remove the .mat
    for j = 1:no_solvers
        fprintf(' & %i',PDitns{j,i});
    end
    fprintf('\\\\ \n');
end