;|

OP_RedefTitle_1.1.lsp

Version History
1.1		July 15, 2016	Initial Public Release
1.0		2009	Initial Release

Requires predefined list of blocks.

Dependencies:	none
Usage: RedefTitle
Arguments:		none
Returns:		prompt

Copyright © 2005-2016 by Richard Lawrence

Written permission must be obtained to copy, modify, and distribute 
this software. Permission to use this software for any purpose and 
without fee is hereby granted, provided that the above copyright 
notice appears in all copies and that both the copyright notice and 
the limited warranty and restricted rights notice below appear in 
all supporting documentation.

THIS PROGRAM IS PROVIDED "AS IS" AND WITH ALL FAULTS.  ANY IMPLIED 
WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR USE ARE 
HEREIN DISCLAIMED. THERE IS NO WARRANTY THAT THE OPERATION OF THE 
PROGRAM WILL BE UNINTERRUPTED OR ERROR FREE.  USAGE OF THIS PROGRAM 
IS AT YOUR OWN RISK.

|;
(defun c:redeftitle (/ cmde sFolder lBlocks)
  (setq	cmde	(getvar "cmdecho")
	;;_ Assign base folder path for blocks
	sFolder	"U:\\Sheets\\"
  )
  (setvar "cmdecho" 0)
  ;;_ Define possible titleblock drawing names (exclude the file extension)
  (setq lBlocks (list "TTLB-L-MS-11x17"	    "TTLB-L-MS-18x24"
		   "TTLB-L-MS-22x34"	    "TTLB-L-MS-24x36"
		   "TTLB-L-MS-30x42"	    "TTLB-P-MS-LEGAL"
		  )
	)
  ;;_ Provide list of block names to query
  (foreach n lBlocks 
    (progn
      (if (tblsearch "BLOCK" n)
	(progn
	  ;;_ If drawing is set as an STB based plotting,
	  (if (and (= (getvar "PSTYLEMODE") 1)
		   (findfile (strcat sFolder n "-STB.dwg"))
	      )
	    ;;_ then append the STB version of the block,
	    (command "insert" (strcat n "=" sFolder n "-STB.dwg") nil)
	    ;;_ else use the CTB version.
	    (command "insert" (strcat n "=" sFolder n) nil)
	  )
	  ;;_ Synchronize the attributes for this block.
	  (command "attsync" "n" n)
	)
      )

    )
  )
  ;;_ Reset cmdecho system variable
  (setvar "cmdecho" cmde)
  (prompt "\nTitleblock redefined. ")
  (princ)
)