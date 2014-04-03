function y = cvx_isaffnnc( x )
[ v, w ] = cvx_vexity( x );
y = all( y(:) == 0 | ( y(:) == 1 & w(:) == 1 ) );

% Copyright 2005-2014 CVX Research, Inc.
% See the file LICENSE.txt for full copyright information.
% The command 'cvx_where' will show where this file is located.
