! Write a line of code that, given a number between 1 and 99, returns the two digits in the number. That is, given 42 <your code>, you should get 4 and 2 on the stack. Use the words /i, mod, and b to accomplish this task.

! my code 
! [ 10 /i ] [ 10 mod ] bi

! example
42 [ 10 /i ] [ 10 mod ] bi

! Repeat the previous exercise for any number of digits. Use a different strategy, though: first convert the number to a string, then iterate over each character, converting each character back to a string and then to a number. Enter USE: math.parser in the Listener and use number>strng, string>number, 1 string and each.

942 number>string [ 1string string>number ] each
