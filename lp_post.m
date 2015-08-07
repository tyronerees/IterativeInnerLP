if scale          % unscale x,y,z
    b  = b *bscale;
    bl = bl*bscale;
    bu = bu*bscale;
    c  = c *oscale;
    x  = x *bscale;
    y  = y *oscale;
    z  = z *oscale;
        
    A  = R*A*C;
    b  = b .*rscale;
    c  = c .*cscale;
    bl = bl./cscale;
    bu = bu./cscale;
    x  = x ./cscale;
    y  = y ./rscale;
    z  = z ./cscale;
    linobj = c'*x;
    fprintf('\n Unscaled linear objective = %12.7e\n', linobj)
end