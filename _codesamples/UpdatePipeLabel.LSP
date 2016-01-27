(defun c:r1 (/ m d r g)

  (if
    (and (setq g (getobject))
	 (setq m (list (cons "Corrugated HDPE Pipe" "A-2000")
		       (cons "Concrete Pipe" "RCP")
		 )
	 )
	 (setq d (asc (m:property g 'Description) m))
	 (setq
	   r (strcat
	       (itoa (fix (* 12.0 (m:property g 'InnerDiameterOrWidth))))
	       (chr 34)
	       " "
	       d
	     )
	 )
    )
     (vlax-put-property g 'Description r)
  )
  r
)