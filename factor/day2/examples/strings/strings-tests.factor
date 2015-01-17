USING: day2.examples.strings tools.test ;
IN: day2.examples.strings.tests

{ t } [ "racecar" palindrome? ] unit-test
{ f } [ "racecat" palindrome? ] unit-test
