(defun C:AddToPG ( / _doc dcl_id data value group lstNumbers strMsg objPG ss blnClick)
  (setq ss (ssget '((0 . "AECC_COGO_POINT"))))
  (vlax-map-collection
    (vla-get-activeselectionset
      (setq _doc (vla-get-activedocument (vlax-get-acad-object)))
    )
    '(lambda (x)
       (setq lstNumbers
	      (append lstNumbers
		      (list (vlax-get-property x 'Number))
	      )
       )
     )
  )
  (setq dcl_id (load_dialog "C:\\Projects\\git\\justopie\\_codesamples\\pg.DCL"))
  (if (not (new_dialog "AddToPointGroup" dcl_id))
    (exit)
  );if
  (setq Data (CollectionNames->List (vlax-get-property (m:c3ddoc) 'PointGroups))
	e ""
	n ""
	group nil)
  (UpdateList "ePG" Data)
  (action_tile
    "cancel"
    "(done_dialog) (setq userclick nil)"
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
  (if blnClick
    (progn
      (cond ((> (strlen e) 0)
	     (setq value (nth (atoi e) Data)
		   strMsg	 (strcat "Existing Point Group: " value)
		   objPG (GetPointGroup value)
	     )
	    )
	    ((> (strlen n) 0)
	     (setq value n
		   strMsg	 (strcat "New Point Group: " value)
		   objPG (AddPointGroup value)
	     )
	    )
      )
      (foreach n lstNumbers (AddPointToGroup n objPG))

      (princ strMsg)
    ) 
  )
  (if group
    group
    (princ)
  )
);defun