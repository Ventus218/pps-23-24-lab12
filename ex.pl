% ---------- part 2 ----------

% map (+L, +Mapper , -Lo)
% where Mapper = mapper (I,O, UNARY_OP )
% e.g. Mapper = mapper (X, Y, Y is X+1)
map ([] , _ , []) .
map ([ H |T], M , [ H2 | T2 ]) :-
	map (T , M , T2 ),
	copy_term (M , mapper (H , H2 , OP )),
	call ( OP ).

% filter(+L, +Predicate, -LO)
% where Predicate = predicate(I, P)
filter([], _, []).
filter([H|T], Pred, [H|TR]) :-
	filter(T, Pred, TR),
	copy_term(Pred, predicate(H,P)),
	once(P),
	!.
filter([H|T], Pred, TR) :-
	filter(T, Pred, TR).

% reduce(+L, +Reducer, -O)
% where Reducer = reducer(I1, I2, R, O)
reduce([H], Red, H).
reduce([A,B|T], Red, O) :-
	copy_term(Red, reducer(A, B, R, OR)),
	once(R),
	reduce([OR|T], Red, O).
