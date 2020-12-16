% Walk csv data and remove row wrapper
unrow([], Acc, Acc).
unrow([row(H)], Acc, Out) :- append([H], Acc, Out).
unrow([row(H)|T], Acc, Out) :- append([H], Acc, Acc1), unrow(T, Acc1, Out).

make_2020(List, A, B) :-
   make_tuple(List, A, B),
   2020 is A + B.

make_tuple([H|T], A, B) :-
    H = A, member(B, T)
    ; make_tuple(T, A, B).

% 316 * 1704 = 538464
main(A, B, Res) :-
  csv_read_file('ex1.txt', Rows),
  unrow(Rows, [], Nums),
  make_2020(Nums, A, B),
  Res is A * B.
