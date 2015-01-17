USING: kernel sequences ;
IN: day2.examples.strings

: palindrome? ( str -- ispal )  dup reverse = ;
