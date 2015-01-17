USING: tools.test io io.streams.null kernel namespaces sequences ;

USE: day2.examples.greeter 
USE: day2.examples.hello
USE: day2.examples.strings
USE: day2.examples.sequences

IN: day2.examples.test-suite

: test-all-examples ( -- )
    [ "day2.examples" test ] with-null-writer
    test-failures get empty?
    [ "w00t. All tests passed." print ] [ :test-failures ] if ;

MAIN: test-all-examples
