! The reduce word takes a sequence, an initial value, and a quotation and returns the result of applying the quotation to the initial value and the first element of the sequence, then the result of applying the quotation to the result of the next element of the sequence, and so on. Using reduce, write a line of code that returns the sum of the numbers 1, 4, 17, 9, 11. Try it on your own first, but if you are truly stuck, look back carefully over the pages you've just read. There is a hint hiding somewhere.
[ 1 4 17 9 11 ] 0 [ + ] reduce .

! Now calculate the sum of the numbers 1 to 100 in a similar fashion. Do not manually write the sequence of numbers. Instead, enter USE:math.ranges in the Listener, and use the [1,b] word to produce the sequence.

USE: math.ranges
100 [1,b] 0 [ + ] reduce .

! The map word takes a sequence and a quotation, and returns a sequence of results of applying the quotation to each value. Using map and the words you have learned so far, write a line of code that returns the squares of the numbers 1 to 10.

10 [1,b] [ sq ] map .
! { 1 4 9 16 25 36 49 64 81 100 }
