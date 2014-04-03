function disp( x, prefix )
if nargin < 2,
    prefix = '';
end
disp( [ prefix, 'cvx: ', cvx_class( x, true, true, true ), ' ', type( x ) ] );
dual = cvx_getdual( x );
if ~isempty( dual ),
    disp( [ prefix, '   tied to dual variable: ', dual.subs ] );
end

% Copyright 2005-2014 CVX Research, Inc.
% See the file LICENSE.txt for full copyright information.
% The command 'cvx_where' will show where this file is located.
