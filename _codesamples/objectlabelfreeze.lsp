(defun c:PLF3 (/		      _LabelPropertyValue
	      _FreezeLabelLayer		      _GetLayer
	      _getobject	      oPicked	      sObject
	      sLayer	      sName	      oStyle
	     )
  (defun _LabelPropertyValue (VLA-Object /)
    ;;_ Returns string value
    (if
      (and
	(vlax-property-available-p VLA-Object "LabelProperties")
	(vlax-property-available-p
	  (setq	VLA-Object
		 (vlax-get-property VLA-Object 'LabelProperties)
	  )
	  "Layer"
	)
	(vlax-property-available-p
	  (setq VLA-Object (vlax-get-property VLA-Object 'Layer))
	  "Value"
	)
      )
       (vlax-get-property VLA-Object 'Value)
    )
  )
  (defun _FreezeLabelLayer
	 (sStyleType lstStyleData blnFreezeStyle / msg)
    (if	(= (type lstStyleData) 'LIST)
      (progn
	(foreach n lstStyleData
	  (if (getvar 'tilemode)
	    (vla-put-freeze (_getlayer (nth 0 n)) :vlax-true)
	    (vl-cmdf "_vplayer"
		     "f"
		     (nth 0 n)
		     "Current"
		     ""
	    )
	  )
	  (setq	msg (strcat "\n"
			    sStyleType
			    " Label Style \""
			    (nth 1 n)
			    "\""
			    "\n"
			    sStyleType
			    " Label Layer \""
			    (nth 0 n)
			    "\" has been frozen. "
		    )
	  )
	)
      )
    )
    (if	msg
      (princ msg)
    )
  )
  (defun _GetLayer (name)

    (if	(= (type name) 'STR)
      (progn
	(setq name
	       (vl-catch-all-apply
		 'vla-item
		 (list (vla-get-layers
			 (vla-get-activedocument (vlax-get-acad-object))
		       )
		       name
		 )
	       )
	)
	(if (vl-catch-all-error-p name)
	  nil
	  name
	)
      )
    )
  )
  (defun _getobject (entity / object)
    (cond ((and	(= (type entity) 'LIST)
		(= (type (car entity)) 'ENAME)
	   )
	   (setq ename (car entity))
	  )
	  ((and	(= (type entity) 'LIST)
		(assoc -1 entity)
		(= (cdr (assoc -1 entity)))
	   )
	   (setq ename (cdr (assoc -1 entity)))
	  )
	  ((= (type entity) 'ENAME)
	   (setq ename entity)
	  )
    )
    (setq
      ename (vl-catch-all-apply 'vlax-ename->vla-object (list ename))
    )
    (if	(vl-catch-all-error-p ename)
      nil
      ename
    )
  )

  (if (and (setq oPicked (nentselp "\nSelect label to freeze: "))
	   (= (type oPicked) 'LIST)
	   (or
	     (= 2 (length oPicked))
	     (= 4 (length oPicked))
	   )
	   (setq oPicked (_getobject (car oPicked)))
      )
    (progn
      (cond
	((= (vlax-get-property oPicked 'ObjectName)
	    "AeccDbParcelSegmentLabel"
	 )
	 (setq sObject "Line"
	       slayer  (_LabelPropertyValue
			 (setq oStyle
				(vlax-get-property oPicked 'LineLabelStyle)
			 )
		       )
	       sname   (vlax-get-property oStyle 'Name)
	 )
	 (_FreezeLabelLayer sObject (list (list slayer sname)) nil)
	 (setq sObject "Curve"
	       slayer  (_LabelPropertyValue
			 (setq oStyle (vlax-get-property
					oPicked
					'CurveLabelStyle
				      )
			 )
		       )
	       sname   (vlax-get-property oStyle 'Name)
	 )
	 (_FreezeLabelLayer sObject (list (list slayer sname)) nil)
	)
	((and (= (vlax-get-property oPicked 'ObjectName) "AeccDbFace")
	      (vlax-property-available-p oPicked "AreaLabelStyle")
	 )
	 (setq sObject "Parcel Area"
	       slayer  (_LabelPropertyValue
			 (setq oStyle
				(vlax-get-property oPicked 'AreaLabelStyle)
			 )
		       )
	       sname   (vlax-get-property oStyle 'Name)
	 )
	 (_FreezeLabelLayer sObject (list (list slayer sname)) nil)
	)
	((and (= (vlax-get-property oPicked 'ObjectName)
		 "AeccDbCogoPoint"
	      )
	      (vlax-property-available-p oPicked "LabelStyle")
	 )
	 (setq sObject "Point"
	       slayer  (_LabelPropertyValue
			 (setq
			   oStyle (vlax-get-property oPicked 'LabelStyle)
			 )
		       )
	       sname   (vlax-get-property oStyle 'Name)
	 )
	 (_FreezeLabelLayer sObject (list (list slayer sname)) nil)
	)
	((and (= (vlax-get-property oPicked 'ObjectName) "AeccDbNoteLabel")
	      (vlax-property-available-p oPicked "LabelStyle")
	 )
	 (setq sObject "Note"
	       slayer  (_LabelPropertyValue
			 (setq oStyle (vlax-get-property oPicked 'LabelStyle))
		       )
	       sname   (vlax-get-property oStyle 'Name)
	 )
	 (_FreezeLabelLayer sObject (list (list slayer sname)) nil)
	)
	((and t
	      (vlax-property-available-p oPicked "Layer")
	 )
	 (vlax-put-property
	   ((vlax-get-property oPicked 'Layer))
	   'Freeze
	   :vlax-true
	 )
	 (princ	(strcat	"\nSelected object's layer \""
			(vlax-get-property oPicked 'Layer)
			"\" has been frozen. "
		)
	 )
	)
      )
    )
  )
  (princ)
)