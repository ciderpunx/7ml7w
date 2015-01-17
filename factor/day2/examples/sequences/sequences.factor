USING: sequences kernel ;
IN: day2.examples.sequences

: find-first ( seq pred -- elt ) partition drop ?first ; inline
