(defun AddPointGroup (strName / objGroup objGroups)
  (if (and (setq objGroups (vlax-get-property (op:c3ddoc) 'PointGroups))
	   (setq objGroup (addorgetitem objGroups strName))
      )
    objGroup
  )
)