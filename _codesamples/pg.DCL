// DCL File to be saved as listboxexample.dcl
// Example courtesy of Lee Mac © 2010 (www.lee-mac.com)

lbox : list_box { width = 25; fixed_width = true; alignment = centered; allow_accept = true;}

AddToPointGroup : dialog { label ="Add to Point Group"; spacer;
  : column {
    : lbox { key = "ePG"; label = "Make" ; }
    : text { value = "Create Point Group"; }
    : edit_box {
                allow_accept = true;
                width = 23;
                edit_width = 23;
                edit_limit = 35;
                key = "nPG";
                mnemonic = "n";
                alignment = centered;
               }
           }
  ok_cancel ;
}