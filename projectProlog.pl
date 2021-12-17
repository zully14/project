/* digit */
digit(Input) :- term_string(TermInput, Input), integer(TermInput), !.
digit255(Input) :- term_string(TermInput, Input), integer(TermInput),
                   TermInput >= 0, TermInput < 256.

/* caratteri non validi per identificatore */
id(64). %@
id(47). %/
id(63). %?
id(35). %#
id(58). %:

identificatore(Input) :- string_codes(Input, List_input), ide(List_input).

ide([L| _]) :- id(L), ! , fail.
ide([_ | Ls]) :- ide(Ls).
ide([_]).

/* caratteri non validi per identificatore_host */
idH(64). %@
idH(47). %/
idH(63). %?
idH(35). %#
idH(58). %:
idH(46). %.

identificatore_host(Input) :- string_codes(Input, List_input), ids(List_input).

ids([L| _]) :- idH(L), ! , fail.
ids([_ | Ls]) :- ids(Ls).
ids([_]).

/* elimina gli spazi */

elimina_spazi([], []).
elimina_spazi([255 | Tail], Tail ) :- !.
elimina_spazi([Head | Tail], [Head, X]) :-  elimina_spazi(Tail, X).

/* scheme */
scheme(Input) :- identificatore(Input), !.

/* host */
host(Input) :- identificatore_host(Input), !.
host(Input) :- indirizzo_ip(Input), !.
host(Input) :- string_codes(Input, List_input), member(46, List_input),
               point(List_input), !.

point(List_input) :- listPos(List_input, 46, Pos),
                     atom_codes(Atom, List_input),
                     sub_atom(Atom, 0, Pos, After, SubAtom),
                     identificatore_host(SubAtom),
                     length(List_input, X),
                     Pos2 is Pos+1,
                     C is X-Pos2,
                     sub_atom(Atom, Pos2, C, After1, SubAtom1),
                     identificatore_host(SubAtom1).
