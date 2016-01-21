(defun C:AddToPG (/	       _doc	    dcl_id	 data
		  value	       group	    lstNumbers	 strMsg
		  objPG	       ss	    blnClick	 sCnt
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

  ;;ADDPOINTGROUP
  (defun AddPointGroup (strName / objGroup objGroups)
    (if	(and (setq objGroups (vlax-get-property (op:c3ddoc) 'PointGroups))
	     (setq objGroup (addorgetitem objGroups strName))
	)
      objGroup
    )
  )

  ;;GETPOINTGROUP
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

  ;;Get Civil 3D Active Document
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

  ;;ADDPOINTTOGROUP
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

  ;;CONTAINSPOINT
  (defun ContainsPoint (objGroup intPoint /)
    (if	(and (= (type intPoint) 'INT)
	     (= (type objGroup) 'VLA-OBJECT)
	     (= (vla-get-ObjectName objGroup) "AeccDbPG")
	)
      (= -1 (vlax-invoke objGroup 'ContainsPoint intPoint))
    )
  )

  ;;GETQUERYBUILDER
  (defun GetQueryBuilder (objGroup)
    (if	(and (= (type objGroup) 'VLA-OBJECT)
	     (= (vla-get-ObjectName objGroup) "AeccDbPG")
	)
      (vlax-get-property objGroup 'QueryBuilder)
    )
  )

  ;; ADDORGETITEM
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


  (setq	ss	   (ssget '((0 . "AECC_COGO_POINT")))
	strDCLFile "pg.DCL"
  )
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