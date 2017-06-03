use lib <lib>;
use AndSo;

say 'sothen is like andthen except checks .Bool instead of .defined';
42  sothen     .say; # OUTPUT: «42␤»
42  andthen    .say; # OUTPUT: «42␤»

Int sothen     .say; # No output
Int andthen    .say; # No output

0   sothen     .say; # No output
0   andthen    .say; # OUTPUT: «0␤»

say "\nnotsothen is like notandthen except checks .Bool instead of .defined";
Int notsothen  .say; # OUTPUT: «(Int)␤»
Int notandthen .say; # OUTPUT: «(Int)␤»

42  notsothen  .say; # No output
42  notandthen .say; # No output

0   notsothen  .say; # OUTPUT: «0␤»
0   notandthen .say; # No output

say "\nsoelse is like orelse except checks .Bool instead of .defined";
Int soelse     .say; # OUTPUT: «(Int)␤»
Int orelse     .say; # OUTPUT: «(Int)␤»

42  soelse     .say; # No output
42  orelse     .say; # No output

0   soelse     .say; # OUTPUT: «0␤»
0   orelse     .say; # No output
