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

% foldleft(+L, +Folder, +Init, -O)
% where Folder = folder(I1, I2, F, O)
foldleft([], _, Init, Init).
foldleft([H|T], Fold, Init, O) :-
	copy_term(Fold, folder(Init, H, F, OF)),
	once(F),
	foldleft(T, Fold, OF, O).

% foldright(+L, +Folder, +Init, -O)
% where Folder = folder(I1, I2, F, O)
foldright([], _, Init, Init).
foldright([H|T], Fold, Init, O) :-
	foldright(T, Fold, Init, FR),
	copy_term(Fold, folder(FR, H, F, O)),
	once(F).

% map_2(+L, +Mapper, -Lo)
% where Mapper = mapper(I, O, UNARY_OP)
% e.g. Mapper = mapper(X, Y, Y is X+1)
map_2(L, mapper(B, MappedB, OP), LO) :- foldright(L, folder(A, B, OP, [MappedB|A]), [], LO).

% filter_2(+L, +Predicate, -LO)
% where Predicate = predicate(I, P)
filter_2(L, predicate(B, P), LO) :- foldright(L, folder(A, B, filter_2_helper(A,B,P, FO), FO), [], LO).
filter_2_helper(A, B, P, [B|A]) :- once(P), !.
filter_2_helper(A, B, _, A).

% reduce_2(+L, +Reducer, -O)
% where Reducer = reducer(I1, I2, R, O)
reduce_2([H|T], reducer(A, B, R, RO), O) :- foldleft(T, folder(A, B, R, RO), H, O).
