% The Path of the Maze
pway(a, b, 10).
pway(b, c, 15).
pway(d, c, 5).
pway(d, b, 10).

pway(b, e, 7).
pway(e, c, 8).

pway(d, f, 5).
pway(c, f, 5).
% Sees if a value is not in the list
notmember(_,[]).
notmember(Z,[Y|List]):- Z \= Y,
	                notmember(Z, List).
% Goes to the next path and sees if it is a sucess
nextpath(X, X, P, _, N):-        N = 0,
	                         P = [].
nextpath(X, Y, [Z|M], List, N):- pway(X, Z, Add),
	                         notmember(Z, List),
				 nextpath(Z, Y, M, [Z|List], Result),
				 N is Result + Add.
nextpath(X, Y, [Z|M], List, N):- pway(Z, X, Add),
	                         notmember(Z, List),
				 nextpath(Z, Y, M, [Z|List], Result),
				 N is Result + Add.
% The function that solves the maze
solve(X, Y, [X|P], N):- nextpath(X, Y, P, [X], N).


% Part 2
%
% Find a Maximum
maxvalue(List1, Z):- pway(X, Y, V),
			    notmember([X,Y], List1),
			    maxvalue([[X,Y]|List1], J),
			    V > 0,
			    Z is V + J,
			    !.
maxvalue(_, Z):- Z = 0.
minvalue(List1, Z):- pway(X, Y, V),
			    notmember([X,Y], List1),
			    minvalue([[X,Y]|List1], J),
			    V < 0,
			    Z is V + J,
			    !.
minvalue(_, Z):- Z = 0.
max(V):- maxvalue([], V).
min(V):- minvalue([], V).

% iterate to Maximum
sort(Value, _, X, Y, P, V) :- solve(X, Y, P, Value),
			      V = Value.
sort(Value, Max, X, Y, P, V) :- Value < Max,
	                     NextValue is Value + 1,
			     sort(NextValue, Max, X, Y, P, V).
solveSorted(X, Y, P, N) :- max(V),
	                   min(Z),
	                   sort(Z, V, X, Y, P, N).
