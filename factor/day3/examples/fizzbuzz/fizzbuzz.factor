USING: kernel io combinators.short-circuit math math.functions
math.ranges present sequences ;

IN: day3.examples.fizzbuzz

: fb-trad ( n -- seq )
    [1,b] [ dup 15 mod 0 = 
            [ drop "FizzBuzz" ]
            [ dup 3 mod 0 = 
              [ drop "Fizz" ]
              [ dup 5 mod 0 =
                [ drop "Buzz" ]
                [ present ] if
              ] if
            ] if
          ] map ;

! A more ppipeliney solution

: mult? ( x/str n -- ? ) 
    over number? [ mod 0 = ] [ 2drop f ] if ;

: when-mult ( x/str n str -- x/str ) 
    pick [ mult? ] 2dip ? ;

: fizz ( x/str -- x/str )
    3 "Fizz" when-mult ;

: buzz ( x/str -- x/str )
    5 "Buzz" when-mult ;

: fizzbuzz ( x/str -- x/str )
    15 "FizzBuzz" when-mult ;

: fb-pipeline ( x -- str )
    fizzbuzz fizz buzz present ;

: fb-with-pipeline ( n -- seq )
    [1,b] [ fb-pipeline ] map ;
