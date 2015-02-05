USING: sequences kernel io ;
IN: day2.examples.sequences

: find-first ( seq pred -- elt ) partition drop ?first ; inline

! Here's a version using only the shuffling words and a loop
: find-first' ( pred seq -- elt ) 
    [ 2dup dup length 0 =  
         [ 4drop f f ]
         [ first swap call 
             [ swap drop first f ] 
             [ rest t ] if 
         ] if 
    ] loop ; inline
