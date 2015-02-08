USING: tools.test io io.streams.string strings
splitting kernel namespaces sequences math.parser math regexp ;

USE: day3.examples.tuples
USE: day3.examples.checkout
USE: day3.examples.fizzbuzz

IN: day3.examples.test-suite

! rather than using a null writer use a string writer,
! split output into lines, filter lines that start
! Unit Test count them and pop that on the stack
: test-all-examples ( -- )
    [ "day3.examples" test ] with-string-writer 
        >string string-lines
        [ R/ ^Unit Test:.*/ matches? ] filter length
      test-failures dup get empty?
      [ drop "w00t! All " write number>string
             " tests passed!" append print ]
      [ :test-failures
            get length number>string "/" append write
            number>string " tests failed :-(" append
            print 
      ] if ;


MAIN: test-all-examples
