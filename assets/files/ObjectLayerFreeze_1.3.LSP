;|

ObjectLayerFreeze.lsp

Version History
1.3     February 17, 2016       Added *error* handler
                                Added Settings option to specify freeze type
1.2     February 10, 2016       Revised _FreezeLabelLayer sub-routine
                                Revised calls to same
1.1	    September 10, 2015	    Added additional Civil 3D object types
1.0	    July 11, 2013	        Initial Release

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

(defun c:olf (/		      _LabelPropertyValue
	      _FreezeLabelLayer		      oPicked
	      sObject	      sLayer	      sName
	      oStyle
	     )
  ;;_ Sub Routine definitions

  (vla-startundomark (setq +doc (m:doc)))
  ;;_ Define error handler
  (defun *error* (strMessage /)
    (if	(or
	  (= strMessage "Function cancelled") ; If user cancelled
	  (= strMessage "quit / exit abort") ; If user aborted
	  (null strMessage)		; End quietly
	)				; End or sequence
      (princ)				; Exit quietly
      (princ (strcat "\nError: " strMessage)) ; Report Error
    )
    (if	lstVariables
      (mapcar '(lambda (x) (setvar (car x) (cdr x))) lstVariables)
    )
    (vla-endundomark (m:doc))
    (princ)
  )

  ;;_ Adjust system variable and save original to list
  (defun _SetSysVar (name value /)
    (if	lstVariables
      (if (null (assoc name lstVariables))
	(setq lstVariables
	       (append lstVariables
		       (list (cons name (getvar name)))
	       )
	)
      )
      (setq lstVariables (list (cons name (getvar name))))
    )
    (setvar name value)
  )

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
	 (sStyleType sLayerName sStyleName blnFreezeStyle / msg)
    ;;_ Arguments:
    ;;_   sStyleName - <String> Associated object for label
    ;;_   sLayerName - <String> Assigned layer name
    ;;_   sStyleName - <String> Label style name
    ;;_   blnFreezeStyle - <boolean> Determines type of layer freeze to use
    ;;_                    t   = vplayer
    ;;_                    nil = layer
    (if	(/= (getvar 'clayer) sLayerName)
      (progn
	(if (or	blnFreezeStyle
		(= (getvar 'tilemode) 1)
	    )
	  (vla-put-freeze (op:layer sLayerName) :vlax-true)
	  (vl-cmdf "_vplayer" "f" sLayerName "Current" "")
	)
	(if sStyleName
	  (setq	msg (strcat "\n"	      sStyleType
			    " Label Style \"" sStyleName
			    "\""	      "\n"
			    sStyleType	      " Label Layer \""
			    sLayerName	      "\" was frozen"
			    (if (and (= (getvar 'tilemode) 0)
				     (not blnFreezeStyle)
				     )
			      " in this viewport. "
			      ". "
			      )
			   )
	  )
	  (setq	msg (strcat "\nSelected object's layer \""
			    sLayerName
			    "\" was frozen. "
		    )
	  )
	)
      )
      (setq msg	(strcat	"\nCannot freeze layer \""
			sLayerName
			"\". It is the CURRENT layer."
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

  ;;_ Implode
  (defun _implode (data delim / str n)
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

  ;;_ Settings
  (defun _Settings (/ freezetype initStrings sDefault)
    (setvar 'ErrNo 0)
    (setq initStrings '("Freeze" "Vpfreeze")
	  )
    (if	op:olf_freezetype
      (setq sDefault (car initStrings))
      (setq sDefault (last initStrings))
    )
    ;;_ Concept by Robert Bell at
    ;;_ http://forums.augi.com/showthread.php?25828-user-input-options-(like-qleader)&p=191225&viewfull=1#post191225
    (while (and	(not (progn (initget (setq initStrings (_Implode initStrings " ")))
			    (setq freezetype
				   (getkword
				     (strcat "\nIn paper space viewport use ["(vl-string-subst "/" " " initStrings)"] <" sDefault ">: ")
				   )
			    )
		     )
		)
		(/= 52 (getvar "ErrNo"))
	   )
    ) ;_ <Enter> was hit
    (if	(= freezetype "Freeze")
      (setq op:olf_freezetype t)
      (setq op:olf_freezetype nil)
    )
	(c:olf)
  )

  ;;_ Main function

  (_SetSysVar "cmdecho" 0 )
  (setq iErrNo (getvar 'ErrNo))
  (if op:olf_freezetype
    (princ "\nUsing Layer Freeze")
    (princ "\nUsing Viewport Freeze")
  )
  (setvar 'ErrNo 0) ;_ reset variable
  (while
    (and
      (not
	(progn (initget "Settings")
	       (setq oPicked (nentselp
			       "\nSelect a label to freeze or [Settings]: "
			     )
	       )
	)
      )
      (/= 52 (getvar "ErrNo"))
    )
  )
  (setvar 'ErrNo iErrNo)
  (cond ((= oPicked "Settings")
	  (_settings)
	)
	((and (= (type oPicked) 'LIST)
	      (or
		(= 2 (length oPicked))
		(= 4 (length oPicked))
	      )
	      (setq oPicked (op:object (car oPicked)))
	 )
	  (cond
	    ((=	(op:property oPicked 'ObjectName)
		"AeccDbParcelSegmentLabel"
	     )
	     (setq sObject "Line"
		   slayer  (_LabelPropertyValue
			     (setq
			       oStyle (op:property oPicked 'LineLabelStyle)
			     )
			   )
		   sname   (op:property oStyle 'Name)
	     )
	     (_FreezeLabelLayer sObject slayer sname op:olf_freezetype)
	     (setq sObject "Curve"
		   slayer  (_LabelPropertyValue
			     (setq
			       oStyle
				(op:property oPicked 'CurveLabelStyle)
			     )
			   )
		   sname   (op:property oStyle 'Name)
	     )
	     (_FreezeLabelLayer sObject slayer sname op:olf_freezetype)
	    )
	    ((and (= (op:property oPicked 'ObjectName) "AeccDbFace")
		  (vlax-property-available-p oPicked "AreaLabelStyle")
	     )
	     (setq sObject "Parcel Area"
		   slayer  (_LabelPropertyValue
			     (setq
			       oStyle (op:property oPicked 'AreaLabelStyle)
			     )
			   )
		   sname   (op:property oStyle 'Name)
	     )
	     (_FreezeLabelLayer sObject slayer sname op:olf_freezetype)
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
	     (_FreezeLabelLayer sObject slayer sname op:olf_freezetype)
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
	     (_FreezeLabelLayer sObject slayer sname op:olf_freezetype)
	    )
	  )
	)
	((and t
	      (vlax-property-available-p oPicked "Layer")
	 )
	 (_FreezeLabelLayer
	   nil
	   (vla-get-layer oPicked)
	   nil
	   op:olf_freezetype
	 )
	)
  )
  (*error* nil)
)