! using only * and + how would you calculate 3^2 + 4^2 
! Assuming that I am allowed to use integers too ;-)
3 3 * 4 4 * +

! Enter USE: math.functions in the Listener. Now, with sq and sqrt calculate the square root of 3^2 + 4^2 
3 sq 4 sq + sqrt .

! If you had the numbers 1 2 on the stack, what code could you use to end up with 1 1 2 on the stack
1 swap

! Enter USE: ascii in the Listener. Put your name on the stack and write a line of code that puts "Hello, " in front of your name and converts the whole string to uppercase. Use the append word to concatenate two strings and >upper to convert to uppercase. Did you have to do any stack shuffling to get the desired result?
"charlie"
"Hello, " swap append >upper .
! "HELLO, CHARLIE"
