function y = abs( x )

%Disciplined convex/geometric programming information for ABS:
%   ABS(X) is convex and nonmonotonic in X. Therefore, when used in
%   DCPs, X must be affine. ABS(X) is not useful in DGPs, since all
%   log-convex and log-concave expressions are already positive.

persistent remap
if isempty( remap ),
    % If we know the next operation is a squaring, we don't actually need
    % to apply any absolute value to the real elements.
    remap = cvx_remap( 'constant' );
    remap = remap + 2 * ( cvx_remap( 'p-nonconst' ) & ~remap );
    remap = remap + 3 * ( cvx_remap( 'n-nonconst' ) & ~remap );
    remap = remap + 4 * ( cvx_remap( 'r-affine' ) & ~remap );
    remap = remap + 5 * ( cvx_remap( 'c-affine' ) & ~remap );
end
v = remap( cvx_classify( x ) );

%
% Process each type of expression one piece at a time
%

yt = [];
vu = sort( v(:) );
vu = vu([true;diff(vu)~=0]);
nv = length( vu );
sx = x.size_;
if nv ~= 1,
    y = cvx( sx, [] );
end
for k = 1 : nv,

    %
    % Select the category of expression to compute
    %

    vk = vu( k );
    if nv == 1,
        xt = x;
        st = sx;
    else
        t = v == vk;
        xt = cvx_subsref( x, t );
        st = size( xt );
    end

    %
    % Perform the computations
    %

    switch vk,
        case 0,
            % Invalid
            error( 'Disciplined convex programming error:\n    Illegal operation: abs( {%s} ).', cvx_class( xt ) );
        case 1,
            % Constant
            yt = cvx( abs( cvx_constant( xt ) ) );
        case 2,
            % Positive any
            yt = xt;
        case 3,
            % Negative any
            yt = -xt;
        case 4,
            % Real affine
            cvx_begin
                epigraph variable yt( st )
                { xt, yt } == lorentz( st, 0 ); %#ok
                cvx_setnneg( yt );
            cvx_end
        case 5,
            % Complex affine
            cvx_begin
                epigraph variable yt( st )
                { xt, yt } == complex_lorentz( st, 0 ); %#ok
                cvx_setnneg( yt );
            cvx_end
        otherwise,
            error( 'Shouldn''t be here.' );
    end

    %
    % Store the results
    %

    if nv == 1,
        y = yt;
    else
        y = cvx_subsasgn( y, t, yt );
    end

end

% Copyright 2005-2014 CVX Research, Inc.
% See the file LICENSE.txt for full copyright information.
% The command 'cvx_where' will show where this file is located.
