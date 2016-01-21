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
    (if	(not _C3DDoc) ;; Check to see if a global variable is set
      (setq
	_C3DDoc	(vla-get-activedocument
		  (vla-getinterfaceobject
		    (vlax-get-acad-object)
		    (strcat "AeccXUiLand.AeccApplication." (c3dver))
		  )
		)

      )
    )
    _C3DDoc  ;; Return reference to active civil 3d document object
  )