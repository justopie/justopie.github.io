(progn
  (setq	h (vl-filename-directory
	    (getfiled "Select a Lisp File" "c:/CAD/" "lsp" 16)
	  )
  )
  (foreach n (vl-directory-files h "*.lsp")
    (LM:LISPStyler
      (strcat h "\\" n)
      '(
	("<div class=\"highlight\"><pre>" "</pre><a href=\"#\" onclick=\"selectCode(this); return false;\">Select all</a></div>") ;_ Container
	("<span class=\"quot\">" "</span>") ;_ Quotes/Dots
	("<span class=\"brkt\">" "</span>") ;_ Brackets
	("<span class=\"cmt\">" "</span>") ;_ Multiline Comments
	("<span class=\"cmt\">" "</span>") ;_ Single Comments
	("<span class=\"str\">" "</span>") ;_ Strings
	("<span class=\"func\">" "</span>") ;_ Protected Symbols
	("<span class=\"int\">" "</span>") ;_ Integers
	("<span class=\"rea\">" "</span>") ;_ Reals
       )
      ".html"
      T
    )
  )
)
(command
  "shell"
  (strcat h "\\robosamplestoincludes.bat")
)