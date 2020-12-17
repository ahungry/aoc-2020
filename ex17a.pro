%% ...#...#
%% ..##.#.#
%% ###..#..
%% ........
%% ...##.#.
%% .#.####.
%% ...####.
%% ..##...#

% # - active, . - inactive
% Each cube has 26 neighbors to consider - 8 on one z-layer, then top/bottom z-layers
% which would cause it to be 9 + 9 + 8 = 26

%% If a cube is active and exactly 2 or 3 of its neighbors are also
%% active, the cube remains active.
%% Otherwise, the cube becomes inactive.
%% If a cube is inactive but exactly 3 of its neighbors are active,
%% the cube becomes active. Otherwise, the cube remains inactive.

x(cube{x: 0, y: 0, z: 0, state: active, next_state: active}).
%% Small testing input
%% .#.
%% ..#
%% ###

in_range(p{x: X1, y: Y1, z: Z1, a: _, b: _}, p{x: X2, y: Y2, z: Z2, a: _, b: _}) :-
  1 is abs(X1 - X2) ; 1 is abs(Y1 - Y2) ; 1 is abs(Z1 - Z2).

num_in_range(_, [], Out, Out).
num_in_range(X, [H], Sum, Out) :-
  in_range(X, H),
  Out is Sum + 1.
num_in_range(_, [_], Out, Out).
num_in_range(X, [H|T], Sum, Out) :-
  in_range(X, H),
  Sum1 is Sum + 1,
  num_in_range(X, T, Sum1, Out).
num_in_range(X, [_|T], Sum, Out) :-
  num_in_range(X, T, Sum, Out).

two_in_range(X, Xs) :- num_in_range(X, Xs, 0, N), 2 is N.
three_in_range(X, Xs) :- num_in_range(X, Xs, 0, N), 3 is N.

test_num_in_range(N) :-
  num_in_range(
    p{x: 0, y: 0, z: 0, a: f, b: t},
    [
      p{x: 1, y: 0, z: 0, a: f, b: t},
      p{x: 0, y: 1, z: 0, a: f, b: t},
      p{x: 0, y: 0, z: 0, a: f, b: t}
    ],
    0,
    N
  ),
  two_in_range(
    p{x: 0, y: 0, z: 0, a: f, b: t},
    [
      p{x: 1, y: 0, z: 0, a: f, b: t},
      p{x: 0, y: 1, z: 0, a: f, b: t},
      p{x: 0, y: 0, z: 0, a: f, b: t}
    ]).
