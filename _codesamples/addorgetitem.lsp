(defun addorgetitem (objCollection strName / objFromCollection)
  (or (= (type (setq objFromCollection
              (vl-catch-all-apply
            'vla-add
            (list objCollection strName)
              )
           )
     )
     'VLA-OBJECT
      )
      (= (type (setq objFromCollection
              (vl-catch-all-apply
            'vla-item
            (list objCollection strName)
              )
           )
     )
     'VLA-OBJECT
      )
  )
  (if (= (type objFromCollection) 'VL-CATCH-ALL-APPLY-ERROR)
    (setq objFromCollection nil)
    objFromCollection
  )
)