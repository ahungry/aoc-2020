% https://www.swi-prolog.org/man/clpfd.html
:- use_module(library(clpfd)).

positive_integer(N) :- N #>= 1.
