(defun NumberString->ListIntegers (strNumbers / lstNumbers lstTemp)
  (setq lstTemp (_explode strNumbers ","))
  (foreach n lstTemp
    (if	(vl-string-search "-" n)
      (setq lstNumbers
	     (append lstNumbers (_expandNumberRange (_explode n "-")))
      )
      (setq lstNumbers (append lstNumbers (list (atoi n))))
    )
  )
  (setq lstNumbers (vl-sort lstNumbers '<))
)