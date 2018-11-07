(defun OP:AddNoteLabel (sNoteLabelStyle / coll:NoteLabelStyles oStyle)
;|

OP_AddNoteLabel_1_0_1.lsp

Version History
1.0.1         October 30, 2018 Set last entity label style
1.0.0         October 30, 2018 Initial Release

Dependencies: OP:c3ddoc
              http://justopie.github.io/blog/2016/01/how-to-add-a-point-group-with-autolisp/#c3ddoc
              sparser - Renamed to _explode
              http://forums.augi.com/showthread.php?59912-convert-String-to-List&p=695041&viewfull=1#post695041
Usage:        (OP:AddNoteLabel "Standard")

Arguments:    sNoteLabelStyle
     Type:    String
              A string denoting a note label style name currently in the drawing.

Returns:      nil

Copyright © 2018 by Richard Lawrence

THIS PROGRAM IS PROVIDED "AS IS" AND WITH ALL FAULTS.  ANY IMPLIED 
WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR USE ARE 
HEREIN DISCLAIMED. THERE IS NO WARRANTY THAT THE OPERATION OF THE 
PROGRAM WILL BE UNINTERRUPTED OR ERROR FREE.  USAGE OF THIS PROGRAM 
IS AT YOUR OWN RISK.
|;
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
      ;; Check to see if a global variable is set
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
    ;; Return reference to active civil 3d document object
  )
  (defun OP:GetCollectionItemByName (oCollection sName / oItem)
    (vlax-for n	oCollection
      (if (and (not oItem)
	       (vlax-property-available-p n 'Name)
	       (= (vlax-get-property n 'Name) sName)
	  )
	(setq oItem n)
      )
    )
    oItem
  )
  (defun OP:GetObjProperty
	 (sSettingsTree oBase / lSettingsTree oFunction)

    (defun _explode (str delim / ptr lst)
      ;; Split a string into a list by delimiter string
      (while (setq ptr (vl-string-search delim str))
	(setq lst (cons (substr str 1 ptr) lst))
	(setq str (substr str (+ ptr 2)))
      )
      (reverse (cons str lst))
    )
    (setq lSettingsTree (_explode sSettingsTree ":"))
    (if	(not oBase)
      (setq oBase (OP:C3DDoc))
    )
    (foreach n lSettingsTree
      (if (vlax-property-available-p oBase n)
	(setq oFunction	(vlax-get-property oBase n)
	      oBase	oFunction
	)
      )
    )
    oFunction
  )

  (defun _explode (str delim / ptr lst)
    ;; Split a string into a list by delimiter string
    (while (setq ptr (vl-string-search delim str))
      (setq lst (cons (substr str 1 ptr) lst))
      (setq str (substr str (+ ptr 2)))
    )
    (reverse (cons str lst))
  )
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
  vla-item
  (if
    (setq oStyle (OP:GetCollectionItemByName
		   (OP:GetObjProperty
		     "GeneralNoteLabelStyles"
		     nil
		   )
		   sNoteLabelStyle
		 )
    )
     (progn
       (command "AddNoteLabel" pause "")
       (if
	 (and (setq oLabel (vlax-ename->vla-object (entlast)))
	      (= "AeccDbNoteLabel"
		 (vla-get-ObjectName (vlax-ename->vla-object (entlast)))
	      )
	 )
	  (vlax-put-property
	    (vlax-ename->vla-object (entlast))
	    "LabelStyle"
	    oStyle
	  )
       )
     )
     (princ "\nNote Label Style not found. ")
  )
  (princ)
)
