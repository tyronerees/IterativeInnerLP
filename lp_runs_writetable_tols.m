fprintf('Problem');
maxits = 80;
fprintf([' & ',test(1).descriptions ]); %backslash first, no tol
for i = 2:no_solvers
    fprintf([' & ',test(i).descriptions, '& max(tol) & min(tol)'  ]);
end 
fprintf('\\\\ \n');

for i = first_prob:first_prob + length_problem - 1
    if (PDitns{1,i}==maxits)||(PDitns{1,i}==1)||(PDitns{1,i}==0)
        continue
    end
    fprintf(strrep(problem{i}(1:end-4),'_','\\_')); 
    % remove the .mat, _ --> \_ 
    fprintf(' & %i',PDitns{1,i});
    for j = 2:no_solvers
        fprintf(' & %i',PDitns{j,i} - PDitns{1,i});
        if PDitns{j,i} == maxits
            fprintf('*');
        end
        fprintf(' & %2.1e ',max(extras{j,i}.tol));
        fprintf(' & %2.1e ',min(extras{j,i}.tol));
    end
    fprintf('\\\\ \n');
end