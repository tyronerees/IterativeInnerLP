scale = 0; %?

A       = Problem.A;
b       = Problem.b;
bl      = Problem.aux.lo;
bu      = Problem.aux.hi;
c       = Problem.aux.c;
[m,n]   = size(A);

if scale
    iprint  = 1;
    scltol  = 0.9;
    [cscale,rscale] = gmscale(A,iprint,scltol);
    
    C = spdiags(cscale,0,n,n);   Cinv = spdiags(1./cscale,0,n,n);
    R = spdiags(rscale,0,m,m);   Rinv = spdiags(1./rscale,0,m,m);
    
    A  = Rinv*A*Cinv;
    b  = b ./rscale;
    c  = c ./cscale;
    bl = bl.*cscale;
    bu = bu.*cscale;
end

fixed   = find(bl==bu);
blpos   = find(bl< bu & bl>0);
buneg   = find(bl< bu & bu<0);
rhs     = b - A(:,fixed)*bl(fixed) ...
          - A(:,blpos)*bl(blpos) ...
          - A(:,buneg)*bu(buneg);

bscale  = norm(rhs,inf);   bscale  = max(bscale,1);
oscale  = norm(c,inf);     oscale  = max(oscale,1);

if scale
    b       = b /bscale;
    bl      = bl/bscale;
    bu      = bu/bscale;
    c       = c /oscale;
    fprintf('\n\n  Final b and c scales:  %11.4e     %11.4e', bscale, oscale)
end


c10     = zeros(n,1);
c20     = zeros(n,1);
d0      = zeros(m,1);
gamma   = 1e-3;           % Primal regularization
delta   = 1e-3;           % 1e-3 or 1e-4 for LP;  1 for Least squares.
d1      = gamma;          % Can be scalar if D1 = d1*I.
d2      = delta*ones(m,1);
zoom    = 1e-3;


options = pdcoSet;

x0      = zeros(n,1);      % Initial x
x0      = max(x0,bl);
x0      = min(x0,bu);
y0      = zeros(m,1);      % Initial y
z0      = zeros(n,1);      % Initial z

if scale
    xsize   = 1;               % Estimate of norm(x,inf) at solution
    zsize   = 1;               % Estimate of norm(z,inf) at solution
else
    xsize   = bscale;
    zsize   = oscale;
end
% Estimate of norm(x,inf) at solution
% Estimate of norm(z,inf) at solution
