USING: day2.examples.greeter tools.test ;
IN: day2.examples.greeter.tests

{ "Hello, Test" } [ "Test" greeting ] unit-test
{ "Hello, Test 2" } [ "Test 2" greeting ] unit-test
