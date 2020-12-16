:- use_module(library(pio)).
:- set_prolog_flag(double_quotes, chars).

%% 1-3 a: abcde
%% 1-3 b: cdefg
%% 2-9 c: ccccccccc

count_char([], _, N, N).
count_char([H], [H], In, Out) :- Out is In + 1.
count_char([H], [_], In, In).
count_char([H|T], [H], In, Out) :- In2 is In + 1, count_char(T, [H], In2, Out).
count_char([H|T], [C], In, Out) :- count_char(T, [C], In, Out).

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

main(Data) :-
  csv_read_file('ex2.txt', Rows),
  unrow(Rows, [], Data).
