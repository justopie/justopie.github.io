  (defun createDialog (/ fn fname)
    (setq fname (vl-filename-mktemp "dcl.dcl"))
    (setq fn (open fname "w"))
    (foreach n
	     (list
	       "AddToPointGroup : dialog { label = \"Add to Point Group\";"
	       "  : column {"
	       "    : text { value = \"Existing Point Groups\"; }"
	       "    : list_box { width = 25;"
	       "                 fixed_width = true;"
	       "                 alignment = centered;"
	       "                 allow_accept = true;"
	       "                 key = \"ePG\"; }"
	       "    : text { value = \"Create Point Group\"; }"
	       "    : edit_box {"
	       "                allow_accept = true;"
	       "                width = 23;"
	       "                edit_width = 23;"
	       "                edit_limit = 35;"
	       "                key = \"nPG\";"
	       "                mnemonic = \"n\";"
	       "                alignment = centered;"
	       "               }"
	       "           }"
	       "  ok_cancel ;"
	       "}"
	      )
      (write-line n fn)
    )
    (close fn)
    fname
  )