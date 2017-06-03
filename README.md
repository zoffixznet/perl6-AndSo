[![Build Status](https://travis-ci.org/zoffixznet/perl6-AndSo.svg)](https://travis-ci.org/zoffixznet/perl6-AndSo)

# NAME

AndSo - Bool versions of `andthen`, `notandthen`, and `orelse`

# SYNOPSIS

```perl6
use AndSo;

# `sothen` is like `andthen` except checks .Bool instead of .defined
42  sothen     .say; # OUTPUT: «42␤»
42  andthen    .say; # OUTPUT: «42␤»

Int sothen     .say; # No output
Int andthen    .say; # No output

0   sothen     .say; # No output
0   andthen    .say; # OUTPUT: «0␤»

# `notsothen` is like `notandthen` except checks .Bool instead of .defined
Int notsothen  .say; # OUTPUT: «(Int)␤»
Int notandthen .say; # OUTPUT: «(Int)␤»

42  notsothen  .say; # No output
42  notandthen .say; # No output

0   notsothen  .say; # OUTPUT: «0␤»
0   notandthen .say; # No output

# `soelse` is like `orelse` except checks .Bool instead of .defined
Int soelse     .say; # OUTPUT: «(Int)␤»
Int orelse     .say; # OUTPUT: «(Int)␤»

42  soelse     .say; # No output
42  orelse     .say; # No output

0   soelse     .say; # OUTPUT: «0␤»
0   orelse     .say; # No output
```

# DESCRIPTION

Three ops like [`infix:<andthen>`](https://docs.perl6.org/routine/andthen),
[`infix:<notandthen>`](https://docs.perl6.org/routine/notandthen), and
[`infix:<orelse>`](https://docs.perl6.org/routine/notandthen), except which
check for truthiness instead of definedness.

But wait a minute! Don't we got `or` and `and` already? Yes, but they don't
alias anything to `$_`. These ops do!

# EXPORTED OPERATORS


----

#### REPOSITORY

Fork this module on GitHub:
https://github.com/zoffixznet/perl6-Proc-Q

#### BUGS

To report bugs or request features, please use
https://github.com/zoffixznet/perl6-Proc-Q/issues

#### AUTHOR

Zoffix Znet (http://perl6.party/)

#### LICENSE

You can use and distribute this module under the terms of the
The Artistic License 2.0. See the `LICENSE` file included in this
distribution for complete details.

The `META6.json` file of this distribution may be distributed and modified
without restrictions or attribution.
