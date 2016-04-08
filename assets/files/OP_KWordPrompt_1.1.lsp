;|

OP_KWordPrompt.lsp

Version History
1.1		April 8, 2016	Reviesed to include implode subroutine
1.0		2005			Initial Release

Request string input from user.

Dependencies:	none
Usage: (op:KWordPrompt lTypes sPrompt iDefault)
Arguments:		lTypes	<List>	keyword strings
				sPrompt	<String>	prefix for user prompt
				iDefault	<Integer>	represents default keyword, starting at 1
Returns:		string of user specified keyword

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
(defun op:KWordPrompt (lTypes sPrompt iDefault / X $TYPES $TYPES2)

  (defun op:implode (data delim / str n)
    ;; Join list items into string with delimiter string
    (if	(and (= (type data) 'LIST)
	     (= (type delim) 'STR)
	     (> (strlen delim) 0)
	)
      (foreach n data
	(if str
	  (setq str (strcat str delim n))
	  (setq str n)
	)
      )
    )
  )
  (if (or (>= iDefault (length lTypes))
	   (<= iDefault 0)
      )
    ;; Error check to verify the default
    ;; integer is within parameters
    (setq iDefault (1- (length lTypes)))
    (setq iDefault (1- iDefault))
  )
  (initget (op:implode lTypes " "))
  ;; sets the initget values
  (setq	X (getkword
	    (strcat "\n"
		    sPrompt
		    " ["
		    (op:implode lTypes "/")
		    "] <"
		    (nth iDEFAULT lTypes)
		    ">: "
	    )
	  )
  )
  ;; prompts user for selection
  (if (not X)
    (setq X (nth idefault lTYPES))
  )
  X
)