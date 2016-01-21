(defun RemoveNumberFromNumberString (intNumber strNumbers / lstExpandedNumbers)

  (if (and (= (type intNumber) 'INT)
	   (= (type strNumbers) 'STR)
      )
    (progn
      (setq lstNumbers (_explode strNumbers ","))
      (foreach n lstNumbers
	(if (vl-string-search "-" n)
	  (setq lstTemp (_explode n "-")
		lstTemp (_expandNumbers (atoi (car lstTemp))(atoi (last lstTemp)))
		lstExpandedNumbers (append lstExpandedNumbers lstTemp))
	  (setq lstExpandedNumbers (append lstExpandedNumbers (list (atoi n))))
	)
      )
    )
  )
  (IntegerList->TextRanges (vl-remove intNumber lstExpandedNumbers))
)
