USING: accessors kernel math syntax tools.test ;

USE: day3.examples.tuples

IN: day3.examples.tuples.tests

{ T{ cart-item f f f f } }
    [ cart-item new ] unit-test

{ T{ cart-item f f 4.95 f } }
    [ cart-item new
    4.95 >>price
    ] unit-test

{ 4.95 }
    [ cart-item new 4.95 >>price price>> ] unit-test

{ T{ cart-item f f 12.50 f } }
    [ cart-item new 25.00 >>price
    dup price>> 0.5 * >>price
    ] unit-test

! { T{ cart-item f f 12.50 f } }
!    [ cart-item new 25.00 >>price
!    [ 0.5 * ] change-price
!    ] unit-test

{ T{ cart-item f "Seven Languages Book" 25.00 1 } }
    [ "Seven Languages Book"
    25.00
    1
    cart-item boa
    ] unit-test

{ T{ cart-item f "Paint brush" 1.00 1 } }
    [ "Paint brush"
    <dollar-cart-item>
    ] unit-test

{ 1 }
    [ <one-cart-item> qty>> ] unit-test

{ 1.50 }
    [ 1.50 <price-cart-item> price>> ] unit-test

{ T{ cart-item f "orange" 0.59 f } }
    [ T{ cart-item f "orange" 0.59 } ] unit-test
