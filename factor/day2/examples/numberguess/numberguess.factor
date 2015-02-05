USING: random sequences kernel math math.parser io ;
IN: day2.examples.numberguess

: win? ( num guess -- whl num guess ) 
    2dup = 
        [ "Winner" ]
        [
          2dup <
              [ "Lower" ]
              [ "Higher" ] if
        ] if ;

: ask-num ( -- ) "Guess a number? " write flush ;

: read-num ( -- n ) readln string>number ;

: try ( n -- n g ) ask-num read-num win? print ;

: game ( n -- n )  [ dup try = not ] loop ;

: choose-num ( -- n ) 100 random 1 + ;

: play ( -- )  choose-num game drop ;

MAIN: play
