  (defun getPointGroupNames (objC3Doc blnAllPoints / lstPG)
    (setq lstPG	(CollectionNames->List
		  (vlax-get-property objC3Doc 'PointGroups)
		)
    )
    (if	(not blnAllPoints)
      (setq lstPG (vl-remove "_All Points" lstPG))
    )
    lstPG
  )