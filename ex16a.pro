departure_location(A) :- A >= 35, A =< 796 ; A >= 811, A =< 953.
departure_station(A) :- A >= 25, A =< 224 ; A >= 248, A =< 952.
departure_platform(A) :- A >= 47, A =< 867 ; A >= 885, A =< 959.
departure_track(A) :- A >= 44, A =< 121 ; A >= 127, A =< 949.
departure_date(A) :- A >= 49, A =< 154 ; A >= 180, A =< 960.
departure_time(A) :- A >= 35, A =< 532 ; A >= 546, A =< 971.
arrival_location(A) :- A >= 41, A =< 700 ; A >= 706, A =< 953.
arrival_station(A) :- A >= 25, A =< 562 ; A >= 568, A =< 968.
arrival_platform(A) :- A >= 31, A =< 672 ; A >= 680, A =< 969.
arrival_track(A) :- A >= 43, A =< 836 ; A >= 852, A =< 961.
class(A) :- A >= 38, A =< 291 ; A >= 304, A =< 968.
duration(A) :- A >= 31, A =< 746 ; A >= 755, A =< 956.
price(A) :- A >= 46, A =< 711 ; A >= 719, A =< 971.
route(A) :- A >= 35, A =< 584 ; A >= 608, A =< 955.
row(A) :- A >= 39, A =< 618 ; A >= 640, A =< 950.
seat(A) :- A >= 25, A =< 308 ; A >= 334, A =< 954.
train(A) :- A >= 26, A =< 901 ; A >= 913, A =< 957.
type(A) :- A >= 33, A =< 130 ; A >= 142, A =< 965.
wagon(A) :- A >= 34, A =< 395 ; A >= 405, A =< 962.
zone(A) :- A >= 46, A =< 358 ; A >= 377, A =< 969.

is_valid(A) :- departure_location(A) ; departure_station(A) ; departure_platform(A) ;
               departure_track(A) ; departure_date(A) ; departure_time(A) ;
               arrival_location(A) ; arrival_station(A) ; arrival_platform(A) ;
               arrival_track(A) ; class(A) ; duration(A) ; price(A) ; route(A) ;
               row(A) ; seat(A) ; train(A) ; type(A) ; wagon(A) ; zone(A).

is_invalid(A) :- \+ is_valid(A).
inc(H, H) :- is_invalid(H).
inc(_, 0).

get_invalid_count([H], Sum, Out) :- inc(H, Inc), Out is Sum + Inc.
get_invalid_count([H|T], Sum, Out) :-
  inc(H, Inc),
  Sum1 is Sum + Inc,
  get_invalid_count(T, Sum1, Out).

% Walk csv data and remove row wrapper
unrow([], Acc, Acc).
unrow([row(H)], Acc, Out) :-
  append([H], Acc, Out).
unrow([row(H)|T], Acc, Out) :-
  append([H], Acc, Acc1), unrow(T, Acc1, Out).

% 23115
main(Out) :-
  csv_read_file('ex16-clean.txt', Rows),
  unrow(Rows, [], Data),
  flatten(Data, Flat),
  get_invalid_count(Flat, 0, Out).
