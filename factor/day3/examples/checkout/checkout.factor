USING: kernel accessors locals
  math math.order math.functions math.parser
  sequences sequences.repeating ;

IN: day3.examples.checkout

CONSTANT: gst-rate 0.05
CONSTANT: pst-rate 0.09975
CONSTANT: uk-vat-rate 0.20

CONSTANT: base-shipping 1.49
CONSTANT: per-item-shipping 1.00
CONSTANT: uk-base-shipping 4.49
CONSTANT: uk-per-item-shipping 0.20

TUPLE: cart-item name price quantity ;

TUPLE: checkout item-count 
       base-price taxes shipping total-price
       ;

: <cart-item> ( name price quantity -- cart-item )
    cart-item boa ;

! ! convert a number to 2 decimal places
: to-price ( float -- price )
    100 * round 100 / ;

! just sums a sequence of vals, convenience
: sum ( seq -- n )
    0 [ + ] reduce ;

! number items in cart
: cart-item-count ( cart -- count ) [ quantity>> ]
    map sum ;

! price of a single line (#items X price)
: cart-item-price ( cart-item -- price )
    [ price>> ] [ quantity>> ] bi * to-price ;

! map cart-item-price over all items to get base-price
: cart-base-price ( cart -- price )
    [ cart-item-price ] map sum ;

! create a base checkout, with item count and baseprice, all
! other fields set to f
: <base-checkout> ( item-count base-price -- checkout )
    f f f checkout boa ;

! takes a cart, returns a checkout based on its contents
: <checkout> ( cart -- checkout )
    [ cart-item-count ] [ cart-base-price ] bi <base-checkout> ;

! works GST-PST out taxes on a base price
: gst-pst ( price -- taxes ) 
    [ gst-rate * ] [ pst-rate * ] bi + ;

! work out taxes on a checkout instance. 
! takes a checkout and an HoF that works out taxes on 
! a base price (like gst-pst) cf: strategy pattern 
: taxes ( checkout taxes-calc -- taxes )
    [ dup base-price>> ] dip
    call to-price >>taxes ; inline

! work out shipping on a cart-item-count
! don't like the name so much.
: per-item ( item-count -- shipping )
    per-item-shipping * base-shipping + ;

! work out shipping for a checkout instance
! takes a checkout and an HoF that works out shipping on 
! an item-count (like per-item)
: shipping ( checkout shipping-calc -- shipping )
    [ dup item-count>> ] dip
    call to-price >>shipping ; inline

! takes a checkout and pushes the total 
! price for that checkout onto the stack
: total ( checkout -- total-price )
    dup [ base-price>> ] [ taxes>> ] [ shipping>> ]
    tri + + to-price >>total-price ;

! just an example for convenience
: sample-checkout ( checkout -- checkout )
    [ gst-pst ] taxes [ per-item ] shipping total ;

! exercises: 

! just an example for convenience
: sample-item ( -- cart-item )
    "test" 10 1 cart-item boa ;

! ten percent off everything
: tenpercent-off ( price -- discounted-price )
    0.9 * ;

! 25 percent off everything
: twentyfivepercent-off ( price -- discounted-price )
    0.75 * ;

! work out discount on a cart-item
: discount-item ( cart-item discount-calc -- cart-item )
     [ dup price>> ] dip
     call to-price >>price ; inline

! works UK VAT out taxes on a base price
: uk-vat ( price -- taxes ) 
    uk-vat-rate * ;

! ! UK shipping
: uk-per-item ( item-count -- shipping )
    uk-per-item-shipping * uk-base-shipping + ;

! ! testing the UK pipeline
: uk-checkout ( checkout -- checkout )
    [ uk-vat ] taxes [ uk-per-item ] shipping total ;

