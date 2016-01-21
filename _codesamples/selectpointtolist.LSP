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