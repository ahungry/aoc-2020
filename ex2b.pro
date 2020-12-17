:- use_module(library(pio)).
:- set_prolog_flag(double_quotes, chars).

%% 1-3 a: abcde
%% 1-3 b: cdefg
%% 2-9 c: ccccccccc

count_char([], _, N, N).
count_char([H], [H], In, Out) :- Out is In + 1.
count_char([_], [_], In, In).
count_char([H|T], [H], In, Out) :- In2 is In + 1, count_char(T, [H], In2, Out).
count_char([_|T], [C], In, Out) :- count_char(T, [C], In, Out).

inc(Min, Max, Count, 1) :- Count >= Min, Count =< Max.
inc(_, _, _, 0).

get_valid_count([], Out, Out).
get_valid_count([attr{min: Min, max: Max, input: Input, char: C}], Sum, Out) :-
  count_char(Input, C, 0, Count),
  inc(Min, Max, Count, Inc),
  Out is Sum + Inc.
get_valid_count([attr{min: Min, max: Max, input: Input, char: C}|T], Sum, Out) :-
  count_char(Input, C, 0, Count),
  inc(Min, Max, Count, Inc),
  Sum1 is Sum + Inc,
  get_valid_count(T, Sum1, Out).

identifier([H|T]) --> [H], { code_type(H, digit) ; H = '-' }, identifier(T).
identifier([]) --> [].

ws --> [W], { char_type(W, space) }, ws.
ws --> [].

any --> [].
any --> [_], any.
any([]) --> [].
any([H|T]) --> [H], any(T).

parseit(Out) --> identifier(Min), ['-'], identifier(Max), ws, any(C), [':'], ws, any(Input),
                 {
                   number_string(Minn, Min),
                   number_string(Maxn, Max),
                   Out = attr{min: Minn, max: Maxn, input: Input, char: C}
                 }.

doit(V) :- phrase(parseit(V), "8-9 v: vvvvvvvvvg").

parse(I, O) :-
  atom_string(I, S),
  string_chars(S, Chars),
  phrase(parseit(O), Chars).

% Walk csv data and remove row wrapper
unrow([], Acc, Acc).
unrow([row(H)], Acc, Out) :-
  parse(H, P),
  append([P], Acc, Out).
unrow([row(H)|T], Acc, Out) :-
  parse(H, P),
  append([P], Acc, Acc1), unrow(T, Acc1, Out).

% 439
main(Out) :-
  csv_read_file('ex2.txt', Rows),
  unrow(Rows, [], Data),
  get_valid_count(Data, 0, Out).
