USING: tools.test arrays ;

USE: day3.examples.checkout

IN: day3.examples.checkout.tests

{ 49.98 } 
   [ "7lang2" 24.99 2 <cart-item> cart-item-price ] unit-test

: <sample-cart> ( -- cart ) 
  "7lang2" 24.99 2 <cart-item> 
  "noderw" 10.99 1 <cart-item> 2array ;

{ 60.97 }
   [ <sample-cart> cart-base-price ] unit-test

{ 3 }
    [ <sample-cart> cart-item-count ] unit-test

{ T{ checkout f 3 60.97 f f f } }
   [ <sample-cart> <checkout> ] unit-test

{ T{ cart-item f "test" 9.0 1 } }
    [ sample-item [ tenpercent-off ] discount-item ] unit-test

{ T{ cart-item f "test" 7.50 1 } }
    [ sample-item [ twentyfivepercent-off ] discount-item ] unit-test

{ T{ checkout f 3 60.97 12.19 5.09 78.25 } }
   [ <sample-cart> <checkout> uk-checkout ] unit-test

{ T{ checkout f 3 60.97 9.13 4.49 74.59 } }
   [ <sample-cart> <checkout> sample-checkout ] unit-test
