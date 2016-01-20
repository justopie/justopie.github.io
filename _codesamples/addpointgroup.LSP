(defun AddPointGroup (strName / objGroup objGroups)
  (if (and (setq objGroups (vlax-get-property (op:c3ddoc) 'PointGroups))
	   (setq objGroup (addorgetitem objGroups strName))
      )
    objGroup
  )
)

(defun GetPointGroup (strName / objGroup objGroups)
  (if (and (setq objGroups (vlax-get-property (op:c3ddoc) 'PointGroups))
	   (= 'VLA-OBJECT (type (setq objGroup (vl-catch-all-apply 'vla-item (list objGroups strName)))))
      )
    objGroup
  )
)