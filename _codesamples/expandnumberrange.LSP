(defun _expandNumberRange (lstRange /)
  (_expandnumbers
    (atoi (car lstRange))
    (atoi (last lstRange))
  )
)