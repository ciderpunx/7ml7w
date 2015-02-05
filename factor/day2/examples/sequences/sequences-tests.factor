USING: kernel io math math.parser tools.test ;
USE: day2.examples.sequences
IN: day2.examples.sequences.tests

{ 2 } [ { 1 2 3 4 } [ 2 >= ] find-first ] unit-test
{ 3 } [ { 1 2 3 4 } [ 2 >  ] find-first ] unit-test
{ f } [ { 1 2 3 4 } [ 9 >  ] find-first ] unit-test

{ 2 } [ [ 2 >= ] { 1 2 3 4 } find-first' ] unit-test
{ 3 } [ [ 2 >  ] { 1 2 3 4 } find-first' ] unit-test
{ f } [ [ 9 >  ] { 1 2 3 4 } find-first' ] unit-test

