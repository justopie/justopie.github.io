;|

addPG.LSP

Version History
1.0		January 27, 2016			Initial Release

Add COGO Point to Point Group

Dependencies:	none
Usage: (CLI)	AddToPG
Arguments:		none
Returns:		none

Copyright © 2016 by Richard Lawrence

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

(defun C:AddToPG (/	       _doc	    dcl_id	 data
		  value	       group	    lstNumbers	 strMsg
		  objPG	       	    blnClick	 
		  strDCLFile   strDCLFilePath		 fname
		  strIncludedNumbers
		 )
  ;;COLLECTIONNAMES->LIST
  (defun CollectionNames->list (objCollection / lstNames)
    (vlax-for n	objCollection
      (setq lstNames (append lstNames (list (vla-get-name n))))
    )
  )
  ;;UPDATELIST
  (defun UpdateList (key lst)

    ;; This function updates the list_box associated with the specified key
    ;; using the contents of the supplied lst

    (start_list key)
    (mapcar 'add_list lst)
    (end_list)
  )

  ;; - Get Civil 3D Active Document
  (defun OP:c3ddoc (/ prod verstr c3dver)
    (defun c3dver (/ c3d *acad*)
      (setq C3D	(strcat	"HKEY_LOCAL_MACHINE\\"
			(if vlax-user-product-key
			  (vlax-user-product-key)
			  (vlax-product-key)
			)
		)
	    C3D	(vl-registry-read C3D "Release")
	    c3d	(substr
		  C3D
		  1
		  (vl-string-search
		    "."
		    C3D
		    (+ (vl-string-search "." C3D) 1)
		  )
		)
      )
      c3d
    )
    (if	(not _C3DDoc)
      (setq
	_C3DDoc	(vla-get-activedocument
		  (vla-getinterfaceobject
		    (vlax-get-acad-object)
		    (strcat "AeccXUiLand.AeccApplication." (c3dver))
		  )
		)

      )
    )
    _C3DDoc
  )

  ;; - AddOrGetItem
  (defun addorgetitem (objCollection strName / objFromCollection)
    (or	(= (type (setq objFromCollection
			(vl-catch-all-apply
			  'vla-add
			  (list objCollection strName)
			)
		 )
	   )
	   'VLA-OBJECT
	)
	(= (type (setq objFromCollection
			(vl-catch-all-apply
			  'vla-item
			  (list objCollection strName)
			)
		 )
	   )
	   'VLA-OBJECT
	)
    )
    (if	(= (type objFromCollection) 'VL-CATCH-ALL-APPLY-ERROR)
      (setq objFromCollection nil)
      objFromCollection
    )
  )

  ;; - AddPointGroup
  (defun AddPointGroup (strName / objGroup objGroups)
    (if	(and (setq objGroups (vlax-get-property (op:c3ddoc) 'PointGroups))
	     (setq objGroup (addorgetitem objGroups strName))
	)
      objGroup
    )
  )

  ;; - GetPointGroup
  (defun GetPointGroup (strName / objGroup objGroups)
    (if	(and (setq objGroups (vlax-get-property (op:c3ddoc) 'PointGroups))
	     (=	'VLA-OBJECT
		(type (setq objGroup (vl-catch-all-apply
				       'vla-item
				       (list objGroups strName)
				     )
		      )
		)
	     )
	)
      objGroup
    )
  )

  ;; - ContainsPoint
  (defun ContainsPoint (objGroup intPoint /)
    (if	(and (= (type intPoint) 'INT)
	     (= (type objGroup) 'VLA-OBJECT)
	     (= (vla-get-ObjectName objGroup) "AeccDbPG")
	)
      (= -1 (vlax-invoke objGroup 'ContainsPoint intPoint))
    )
  )

  ;; - GetQueryBuilder
  (defun GetQueryBuilder (objGroup)
    (if	(and (= (type objGroup) 'VLA-OBJECT)
	     (= (vla-get-ObjectName objGroup) "AeccDbPG")
	)
      (vlax-get-property objGroup 'QueryBuilder)
    )
  )

  ;; - AddPointToGroup
  (defun AddPointToGroup (intPoint objGroup / objQB strIncludedNumbers)
    (if	(and (= (type intPoint) 'INT)
	     (= (type objGroup) 'VLA-OBJECT)
	     (= (vla-get-ObjectName objGroup) "AeccDbPG")
	     (not (ContainsPoint objGroup intPoint))
	)
      (progn
	(setq objQB		 (GetQueryBuilder objGroup)
	      strIncludedNumbers (vlax-get-property objQB 'IncludeNumbers)
	)
	(if (> (strlen strIncludedNumbers) 0)
	  (vlax-put-property
	    objQB
	    'IncludeNumbers
	    (strcat strIncludedNumbers "," (itoa intPoint))
	  )
	  (vlax-put-property objQB 'IncludeNumbers (itoa intPoint))
	)
      )
    )
  )
  
  ;; - SelectPoints->List
  (defun SelectPoints->List (/ ss scnt lstNumbers)
    (setq ss (ssget '((0 . "AECC_COGO_POINT"))))
    (repeat (setq scnt (sslength ss))
      (setq lstNumbers
	     (append
	       lstNumbers
	       (list
		 (vlax-get-property
		   (vlax-ename->vla-object (ssname ss (setq scnt (1- scnt))))
		   'Number
		 )
	       )
	     )
      )
    )
  )

  ;; getPointGroupNames
  (defun getPointGroupNames (objC3Doc blnAllPoints / lstPG)
    (setq lstPG	(CollectionNames->List
		  (vlax-get-property objC3Doc 'PointGroups)
		)
    )
    (if	(not blnAllPoints)
      (setq lstPG (vl-remove "_All Points" lstPG))
    )
    lstPG
  )

  ;; createDialog
  (defun createDialog (/ fn fname)
    (setq fname (vl-filename-mktemp "dcl.dcl"))
    (setq fn (open fname "w"))
    (foreach n
	     (list
	       "AddToPointGroup : dialog { label = \"Add to Point Group\";"
	       "  : column {"
	       "    : list_box { width = 25;"
	       "                 fixed_width = true;"
	       "                 alignment = centered;"
	       "                 allow_accept = true;"
	       "                 key = \"ePG\";"
	       "                 label = \"Make\"; }"
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

  (setq lstNumbers (SelectPoints->List))

  (if (and
	(setq fname (createdialog))
	(setq dcl_id (load_dialog fname))
      )
    (progn
      (if (not (new_dialog "AddToPointGroup" dcl_id))
	(exit)
      )
      (setq Data  (getPointGroupNames (m:c3ddoc) nil)
	    e	  ""
	    n	  ""
	    group nil
      )
      (UpdateList "ePG" Data)
      (action_tile
	"cancel"
	"(done_dialog) (setq blnClick nil)"
      )
      (action_tile
	"accept"
	(strcat
	  "(progn (setq e (get_tile \"ePG\"))"
	  "(setq n (get_tile \"nPG\"))"
	  " (done_dialog)(setq blnClick T))"
	)
      )
      (start_dialog)
      (unload_dialog dcl_id)
      (vl-file-delete fname)
      (if blnClick
	(progn
	  (cond	((> (strlen e) 0)
		 (setq value  (nth (atoi e) Data)
		       strMsg (strcat "Existing Point Group: " value)
		       objPG  (GetPointGroup value)
		 )
		)
		((> (strlen n) 0)
		 (setq value  n
		       strMsg (strcat "New Point Group: " value)
		       objPG  (AddPointGroup value)
		 )
		)
	  )
	  (foreach n (vl-sort lstNumbers '<)
	    (AddPointToGroup n objPG)
	  )
	  (setq strMsg (strcat "\n\n"(itoa (length lstNumbers)) " Point Numbers added to " strMsg))
	  (princ strMsg)
	)
      )
      (if group
	group
	(princ)
      )
    )
  )
)