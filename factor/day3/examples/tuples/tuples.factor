USE: kernel

IN: day3.examples.tuples

TUPLE: cart-item name price qty ;

: <dollar-cart-item> ( name -- cart-item ) 
    1.0 1 cart-item boa ;

: <one-cart-item> ( -- cart-item ) 
    T{ cart-item { qty 1 } } ;

: <price-cart-item> ( p -- cart-item ) 
    "Default" swap 1 cart-item boa ;
