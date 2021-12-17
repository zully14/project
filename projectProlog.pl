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
