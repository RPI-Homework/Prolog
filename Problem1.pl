% Production Rules
prod(1,[non(e,_),     non(t,_),non(eprime,_)]).
prod(2,[non(eprime,_),term(minus,_),non(t,_),non(eprime,_)]).
prod(3,[non(eprime,_),term(eps,_)]).
prod(4,[non(t,_),     term(num,_),non(tprime,_)]).
prod(5,[non(tprime,_),term(mul,_),term(num,_),non(tprime,_)]).
prod(6,[non(tprime,_),term(eps,_)]).


% Expansion Table
expand(non(e,_),     term(num,_),  1).
expand(non(eprime,_),term(minus,_),2).
expand(non(eprime,_),term(end,_),  3).
expand(non(t,_),     term(num,_),  4).
expand(non(tprime,_),term(mul,_),  5).
expand(non(tprime,_),term(minus,_),6).
expand(non(tprime,_),term(end,_),  6).


% sample inputs
input0([3,-,5]).
input1([3,-,5,*,7,-,18]).
input2([1,-,5,*,7,*,2,-,10]).
input3([1,+,9]).
input4([100,-,1,*,2,*,3,-4,*,5,-,6,-,7,*,10,*,11,*,12]).
input5([100,-,1,*,2,*,3,-,4,*,5,-,6,-,7,*,10,*,11,*,12]).
input([3,-,5]).
input([3,-,5,*,7,-,18]).
input([1,-,5,*,7,*,2,-,10]).
input([1,+,9]).
input([100,-,1,*,2,*,3,-4,*,5,-,6,-,7,*,10,*,11,*,12]).
input([100,-,1,*,2,*,3,-,4,*,5,-,6,-,7,*,10,*,11,*,12]).


% Trasform function which transforms the input list
transform([], R)      :- R = [term(end,_)].
transform([L|List], Z):- integer(L),  Z = [term(num,L)|M],   transform(List, M).
transform([L|List], Z):- L == +,      Z = [term(add,_)|M],   transform(List, M).
transform([L|List], Z):- L == -,      Z = [term(minus,_)|M], transform(List, M).
transform([L|List], Z):- L == *,      Z = [term(mul,_)|M],   transform(List, M).
transform([L|List], Z):- L == /,      Z = [term(div,_)|M],   transform(List, M).
transform([L|List], Z):- L == ^,      Z = [term(pow,_)|M],   transform(List, M).


% Parser for Part 1
% Can Parse any LL(1) grammar containing +, -, *, /, ^, and numbers
% Could parse other LL(1) grammars if transform functions were added
doparse([term(end,_)], P, []) :-                    P = [].
doparse(L, P, [term(eps,_)|List2]) :-		    doparse(L, P, List2).
doparse([term(X,_)|List1], P, [term(X,_)|List2]) :- doparse(List1, P, List2).
doparse([L|List1], P, [non(X,_)|List2]) :-	    expand(non(X,_), L, Z),
	                                            prod(Z, [non(X,_)|Y]),
						    append(Y, List2, Result),
						    doparse([L|List1], Q, Result),
					            P = [Z|Q].
parse(L, P) :- transform(L, X), doparse(X, P, [non(e,_)]).

% Parser for Part 2
% Can only compute the current LL(1) grammar
% when end is hit return
doparseandcompute([term(end,_)], P, [], V, [_,false], [_,false]) :-	     P = [],
									     V = 0.
doparseandcompute([term(end,_)], P, [], V, [_,false], [T,true]) :-	     P = [],
									     V = T.
doparseandcompute([term(end,_)], P, [], V, [E,true] , [_,false]) :-	     P = [],
									     V = E.
doparseandcompute([term(end,_)], P, [], V, [E,true] , [T,true]) :-	     P = [],
									     V is E - T.
% when eps is hit, move to next value in list
doparseandcompute(L, P, [term(eps,_)|List2], V,	[_, false] , [_, false]) :-  doparseandcompute(L, P, List2, V, [0, false], [1, false]).
doparseandcompute(L, P, [term(eps,_)|List2], V,	[_, false] , [T, true])  :-  doparseandcompute(L, P, List2, V, [T,true], [1, false]).
doparseandcompute(L, P, [term(eps,_)|List2], V,	[E, true]  , [_, false]) :-  doparseandcompute(L, P, List2, V, [E,true], [1, false]).
doparseandcompute(L, P, [term(eps,_)|List2], V,	[E, true]  , [T, true])  :-  Z is E - T,
									     doparseandcompute(L, P, List2, V, [Z,true], [1, false]).
% when a term is hit remove from both lists
doparseandcompute([term(num,Value)|List1], P, [term(num,_)|List2], V, E, [_, false]) :-       doparseandcompute(List1, P, List2, V, E, [Value, true]).
doparseandcompute([term(num,Value)|List1], P, [term(num,_)|List2], V, E, [T, true])  :-       Z is Value * T,
											      doparseandcompute(List1, P, List2, V, E, [Z, true]).
doparseandcompute([term(minus,_)|List1], P, [term(minus,_)|List2], V, E, T) :-                doparseandcompute(List1, P, List2, V, E, T).
doparseandcompute([term(mul,_)|List1], P, [term(mul,_)|List2], V, E, T) :-		      doparseandcompute(List1, P, List2, V, E, T).
% when a non terminal is hit, add new value to list2
doparseandcompute([L|List1], P, [non(X,_)|List2], V, E, T) :-	             expand(non(X,_), L, Z),
	                                                                     prod(Z, [non(X,_)|Y]),
						                             append(Y, List2, Result),
						                             doparseandcompute([L|List1], Q, Result, V, E, T),
					                                     P = [Z|Q].
% Start function
parseAndCompute(L, P, V) :- transform(L, X), doparseandcompute(X, P, [non(e,_)], V, [0, false], [1,false]).
parseAndSolve(L, P, V) :- parseAndCompute(L, P, V).
parse(L, P, V) :- parseAndCompute(L, P, V).
