(defun IntegerList->TextRanges (intlist / range txt); = Integer List to Text with Range(s)
  ;; Code retrieve from 
  ;; https://forums.autodesk.com/t5/visual-lisp-autolisp-and-general/convert-list-of-numbers-to-a-range-of-missing-numbers/m-p/4335437#M313320
  ;; Author: Kent Cooper
  ;; command renamed from IL2TR
  (setq txt (itoa (car intlist))); start with first number
  (while intlist ; still anything left in list
    (while
      (and
	(> (length intlist) 1)		; still at least two terms left
	(= (1+ (car intlist)) (cadr intlist))
					; first 2 remaining integers are consecutive
      )					; and
       (setq range   "-"		; [will replace itself if more than two consecutive]
	     intlist (cdr intlist)	; take off first remaining number
       )
    )
    (if (not range) (setq intlist (cdr intlist)))
    (if intlist ; still anything left in list [wiped out at last item by above line]
      (setq txt	  (strcat txt
			  (cond	(range)
				(",")
			  )		; hyphen or comma, depending
			  (itoa (car intlist)) ; next remaining number
		  )			; strcat & txt
	    range nil			; reset for continuation
      )
    )
  )
  txt
)

