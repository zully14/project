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

identificatore(Input) :- atom_codes(Input, List_input), ide(List_input).

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

identificatore_host(Input) :- atom_codes(Input, List_input), ids(List_input).

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

point(List_input) :- listPos(List_input, 46, Pos),
                     atom_codes(Atom, List_input),
                     sub_atom(Atom, 0, Pos, After, SubAtom),
                     identificatore_host(SubAtom),
                     length(List_input, X),
                     Pos2 is Pos+1,
                     C is X-Pos2,
                     sub_atom(Atom, Pos2, C, After1, SubAtom1),
                     identificatore_host(SubAtom1).

/* userinfo */
userinfo(Input) :- identificatore(Input), !.

/* port */
port(Input) :- digit255(Input), !.

/* authority */
authority(Input) :- atom_codes(Input, List_input), c_aut(List_input).

c_aut([X, X | Y]) :- X == 47, member(64, Y), !, aut(Y), !.
c_aut([X, X | Y]) :- X == 47, member(58, Y), !, twopoints(Y), !.
c_aut([X, X | Y]) :- X == 47, atom_codes(Atom, Y), host(Atom), !.

aut(List_codes):-length(List_codes, Length_list),
            listPos(List_codes, 64, Pos),
            P is Pos - 1,
            atom_codes(Atom, List_codes),
            sub_atom(Atom, 0, P, After, SubAtomAt), %stringa fino a PRIMA di @
            A is After - 1, 
            sub_atom(Atom, Pos, A, _ , SubAtomRest), % da @ in poi quindi vado a richiamare twopoints per vedere se ho anche present i due punti 
            atom_codes(SubAtomRest, List_SubAtomRest),
            twopoints(List_SubAtomRest).

aut(List_codes):- length(List_codes, Length_list),
            listPos(List_codes, 64, Pos),
            P is Pos - 1,
            atom_codes(Atom, List_codes),
            sub_atom(Atom, 0, P, After, SubAtomAt), %stringa fino a PRIMA di @
            A is After - 1, 
            sub_atom(Atom, Pos, A, _ , SubAtomRest), % da @ in poi quindi vado a richiamare twopoints per vedere se ho anche present i due punti 
            atom_codes(SubAtomRest, List_SubAtomRest),
            host(SubAtomRest), !, 
            userinfo(SubAtomAt).

twopoints(List_codes):- member(58, List_codes), !,
                        length(List_codes, Length),
                        listPos(List_codes, 58, Pos), 
                        L is Length - Pos,
                        atom_codes(Atom, List_codes),
                        sub_atom(Atom, Pos, L, _, SubAtomPoints), % prende stringa dopo due punti
                        A is Length - L - 1,
                        sub_atom(Atom, 0,  A, _, SubAtomHost), %prende stringa host
                        host(SubAtomHost), !,
                        port(SubAtomPoints).


listPos([X|_], X, 1).
listPos([_|Tail], X, Pos) :- listPos(Tail, X, P), Pos is P + 1.



/* indirizzo_ip */
indirizzo_ip(Input):- atom_codes(Input, List_input), length(List_input, 15), !, validate_point(List_input).

validate_point(L):- nth1(12, L, 46), nth1(8, L, 46), nth1(4, L, 46),
                    atom_codes(String, L),
                    split_string(String, ".", "", List_string),
                    length(List_string, 4),
                    validate_number(List_string).

validate_number([L | Ls]):- digit(L), validate_number(Ls), !.
validate_number([]).

/* path */
path(Input) :- identificatore(Input), !.
path(Input) :- atom_codes(Input, List_input), member(47, List_input),
               slash(List_input), !.

slash(List_input) :- listPos(List_input, 47, Pos),
                     atom_codes(Atom, List_input),
                     sub_atom(Atom, 0, Pos, After, SubAtom),
                     identificatore(SubAtom),
                     length(List_input, X),
                     Pos2 is Pos+1,
                     C is X-Pos2,
                     sub_atom(Atom, Pos2, C, After1, SubAtom1),
                     identificatore(SubAtom1).

/* query */
query(Input) :- atom_codes(Input, List_input), member(35, List_input), !, fail.
query(Input).

/* fragment */
fragment(Input).
