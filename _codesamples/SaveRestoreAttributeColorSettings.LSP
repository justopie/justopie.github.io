
;acColorMethodByACI 195
;acColorMethodByBlock 193
;acColorMethodByLayer 192
;acColorMethodByRGB 194
;acColorMethodForeground 197

(defun c:SaveAttColors (/ cnt y l)
  (defun :VLA_GET_COLOR	(object / COLOR-METHOD COLOR-OBJECT color-list)
    (setq color-object (vla-get-TrueColor object)
	  color-method (vla-get-ColorMethod color-object)
    )
    (cond ((= color-method acColorMethodByRGB)
	   (setq color-list
		  (mapcar
		    '(lambda (l) (vlax-get color-object l))
		    '(Red Green Blue)
		  )
	   )
	  )
	  ((= color-method acColorMethodByACI)
	   (setq color-list (vla-get-ColorIndex color-object))
	  )
    )
    (setq color-list
	   (cons (vla-get-handle object)
		 (list color-method color-list)
	   )
    )
  )
  (setq lstHandles nil)
  (repeat (setq cnt (sslength (setq y (ssget '((0 . "INSERT"))))))
    (foreach n
	     (m:safelist
	       (vla-getattributes
		 (vlax-ename->vla-object (ssname y (setq cnt (1- cnt))))
	       )
	     )
      (setq l (append l (list (vla-get-handle n))))
    )
  )
  (if l
    (setq lstHandles
	   (mapcar
	     (function (lambda (x)
			 (:vla_get_color
			   (vlax-ename->vla-object (handent x))
			 )
		       )
	     )
	     l
	   )
    )
  )
)
(defun c:RestoreAttColors (/)
  (defun :VLA_SET_COLOR	(object color-list / COLOR-METHOD)
    (or	color-object
	(setq color-object
	       (vla-GetInterfaceObject
		 (setq :ACAD_OBJECT (vlax-get-acad-object))
		 (strcat "AutoCAD.AcCmColor."
			 (substr (getvar 'ACADVER) 1 2)
		 )
	       )
	)
    )
    (setq color-method (nth 0 color-list))
    (vla-put-ColorMethod color-object color-method)
    (if	(= color-method acColorMethodByRGB)
      (vla-SetRGB
	color-object
	(nth 0 (setq color-list (nth 1 color-list)))
	(nth 1 color-list)
	(nth 2 color-list)
      )
      (vla-put-ColorIndex color-object (nth 1 color-list))
    )
    (vla-put-TrueColor object color-object)
    (vlax-release-object color-object)
    object
  )
  (if (and lstHandles
	   (= (type lstHandles) 'LIST)
      )
    (foreach n lstHandles
      (:VLA_SET_COLOR
	(vlax-ename->vla-object (handent (car n)))
	(cdr n)
      )
    )
  )
  (princ)
)
  ;;(setq u (mapcar (function (lambda (x) (:vla_get_color (vlax-ename->vla-object (handent x))))) lstHandles))
(setq lstHandles u)
  