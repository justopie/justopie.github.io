;|

ObjectLayerFreeze.lsp

Version History
1.1		September 10, 2015		Added additional Civil 3D object types
1.0		July 11, 2013			Initial Release

Freezes the label's assigned layer of a selected Civil 3D object

Dependencies:	none
Usage: (CLI)	OLF
Arguments:		none
Returns:		none

Copyright © 2013-2015 by Richard Lawrence

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

(defun c:olf (/	_LabelPropertyValue		  _FreezeLabelLayer
		oPicked		 sObject	  sLayer
		sName		 oStyle
	       )
  ;;_ Sub Routine definitions

  ;;_ Retrieve label name from label style
  (defun _LabelPropertyValue (VLA-Object /)
    ;;_ Returns string value
    (if
      (and
	(vlax-property-available-p VLA-Object "LabelProperties")
	(vlax-property-available-p
	  (setq	VLA-Object
		 (op:property VLA-Object 'LabelProperties)
	  )
	  "Layer"
	)
	(vlax-property-available-p
	  (setq VLA-Object (op:property VLA-Object 'Layer))
	  "Value"
	)
      )
       (op:property VLA-Object 'Value)
    )
  )
  ;;_ Freeze label layer
  (defun _FreezeLabelLayer
	 (sStyleType lstStyleData blnFreezeStyle / msg)
    (if	(= (type lstStyleData) 'LIST)
      (progn
	(foreach n lstStyleData
	  (if
	    (getvar 'tilemode)
	     (vla-put-freeze (op:layer (nth 0 n)) :vlax-true)
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
			    "\" was frozen. "
		    )
	  )
	)
      )
    )
    (if	msg
      (princ msg)
    )
  )

 ;_ Get Active Document object
  (defun op:doc	()
    (vla-get-activedocument (vlax-get-acad-object))
  )

  (defun op:property (vlaObject symProperty /)
    (if	(vlax-property-available-p vlaObject symProperty)
      (vlax-get-property vlaObject symProperty)
    )
  )

 ;_ Get Layers collection
  (defun op:layers ()
    (vla-get-layers (op:doc))
  )

 ;_ Get Layer object by name
  (defun op:layer (name)
    (if	(= (type name) 'STR)
      (progn
	(setq
	  name (vl-catch-all-apply 'vla-item (list (op:layers) name))
	)
	(if (vl-catch-all-error-p name)
	  nil
	  name
	)
      )
    )
  )

 ;_ Get vla-object from entity
  (defun op:object (entity / object)
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

  ;;_ Main function

  (if (and (setq oPicked (nentselp "\nSelect label to freeze: "))
	   (= (type oPicked) 'LIST)
	   (or
	     (= 2 (length oPicked))
	     (= 4 (length oPicked))
	   )
	   (setq oPicked (op:object (car oPicked)))
      )
    (progn
					;(setq objLayers (op:layers))
      (cond
	((= (op:property oPicked 'ObjectName)
	    "AeccDbParcelSegmentLabel"
	 )
	 (setq sObject "Line"
	       slayer  (_LabelPropertyValue
			 (setq oStyle (op:property oPicked 'LineLabelStyle))
		       )
	       sname   (op:property oStyle 'Name)
	 )
	 (_FreezeLabelLayer sObject (list (list slayer sname)) nil)
	 (setq sObject "Curve"
	       slayer  (_LabelPropertyValue
			 (setq oStyle (op:property oPicked 'CurveLabelStyle))
		       )
	       sname   (op:property oStyle 'Name)
	 )
	 (_FreezeLabelLayer sObject (list (list slayer sname)) nil)
	)
	((and (= (op:property oPicked 'ObjectName) "AeccDbFace")
	      (vlax-property-available-p oPicked "AreaLabelStyle")
	 )
	 (setq sObject "Parcel Area"
	       slayer  (_LabelPropertyValue
			 (setq oStyle (op:property oPicked 'AreaLabelStyle))
		       )
	       sname   (op:property oStyle 'Name)
	 )
	 (_FreezeLabelLayer sObject (list (list slayer sname)) nil)
	)
	((and (= (op:property oPicked 'ObjectName) "AeccDbCogoPoint")
	      (vlax-property-available-p oPicked "LabelStyle")
	 )
	 (setq sObject "Point"
	       slayer  (_LabelPropertyValue
			 (setq oStyle (op:property oPicked 'LabelStyle))
		       )
	       sname   (op:property oStyle 'Name)
	 )
	 (_FreezeLabelLayer sObject (list (list slayer sname)) nil)
	)
	((and (= (op:property oPicked 'ObjectName) "AeccDbNoteLabel")
	      (vlax-property-available-p oPicked "LabelStyle")
	 )
	 (setq sObject "Note"
	       slayer  (_LabelPropertyValue
			 (setq oStyle (op:property oPicked 'LabelStyle))
		       )
	       sname   (op:property oStyle 'Name)
	 )
	 (_FreezeLabelLayer sObject (list (list slayer sname)) nil)
	)
	((and t
	      (vlax-property-available-p oPicked "Layer")
	 )
	 (vlax-put-property
	   (op:layer (op:property oPicked 'Layer))
	   'Freeze
	   :vlax-true
	 )
	 (princ	(strcat	"\nSelected object's layer \""
			(op:property oPicked 'Layer)
			"\" was frozen. "
		)
	 )
	)
      )
    )
  )
  (princ)
)