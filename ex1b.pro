% Walk csv data and remove row wrapper
unrow([], Acc, Acc).
unrow([row(H)], Acc, Out) :- append([H], Acc, Out).
unrow([row(H)|T], Acc, Out) :- append([H], Acc, Acc1), unrow(T, Acc1, Out).

make_2020(List, A, B, C) :-
   make_tuple(List, A, B, C),
   2020 is A + B + C.

make_tuple([H|T], A, B, C) :-
    H = A, member(B, T), member(C, T)
    ; make_tuple(T, A, B, C).

% 502 * 903 * 615 = 278783190
main(A, B, C, Res) :-
  csv_read_file('ex1.txt', Rows),
  unrow(Rows, [], Nums),
  make_2020(Nums, A, B, C),
  Res is A * B * C.
