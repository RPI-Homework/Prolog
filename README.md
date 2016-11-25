Joseph Salomone
660658959
salomj@rpi.edu
Programming Languages - Section 1
September 30, 2010
Due October 8, 2010
Project 1

Parse.pl

Part1
Designed to be able to take any LL(1) grammar and figure out the parse order.
Tranform function may need to be added to accomplish this.

Part2
Is designed to use the example LL(1) grammar and output the value.
Is not designed to take other LL(1) grammars.

Maze.pl

Part1
Uses he notmember function, which goes through a list and sees weather or not
a given value is not in the list.
Also uses nextpath function, which goes to the nextpath and adds the value to
the nextpath function it calls.

Part2
Uses the same functions as part one and also uses, maxvalue, minvalue, and sort.
maxvalue determines the maximum possible value of using the pway function, or 
more simple put, the max value of the maze without repeating paths.
min value determine the minmum possible value the same way maze determines the max
value. This is done incase of negative values in path length.
sort function just iterates from minimum value to the maximum value found. This makes
the output be outputed in order.
Minimum value are there in case of negative path length.
