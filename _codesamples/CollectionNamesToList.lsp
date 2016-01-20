(defun CollectionNames->list (objCollection / lstNames)
  (vlax-for n objCollection
    (setq lstNames (append lstNames (list (vla-get-name n))))
  )
)