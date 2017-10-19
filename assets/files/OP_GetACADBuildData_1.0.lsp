(defun OP:GetBuildData (/ lBuildData sProdKey lData)
  ;|

OP_GetACADBuildData_1_0.lsp

Version History
1.0		October 19, 2017 Initial Release

Dependencies: none
Usage:        (op:getbuilddata)
Arguments:    none
Returns:      list containing current computer name and ProductInfo
              registry key of currently running AutoCAD product

Copyright © 2017 by Richard Lawrence

Written permission must be obtained to copy, modify, and distribute 
this software. Permission to use this software for any purpose and 
without fee is hereby granted, provided that the above copyright 
notice appears in all copies and that both the copyright notice and 
the limited warranty and restricted rights notice below appear in 
all supporting documentation.

THIS PROGRAM IS PROVIDED "AS IS" AND WITH ALL FAULTS.  ANY IMPLIED 
WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR USE ARE 
HEREIN DISCLAIMED. THERE IS NO WARRANTY THAT THE OPERATION OF THE 
PROGRAM WILL BE UNINTERRUPTED OR ERROR FREE.  USAGE OF THIS PROGRAM 
IS AT YOUR OWN RISK.

|;

  (setq	lBuildData (list (getenv "COMPUTERNAME"))
	sProdKey   (strcat
		     "HKEY_LOCAL_MACHINE\\"
		     (substr (vlax-machine-product-key)
			     1
			     (vl-string-search ":" (vlax-machine-product-key))
		     )
		     "\\ProductInfo"
		   )
  )
  (foreach n (vl-registry-descendents sProdKey)
    (setq lData	     (list (cons n
				 (list (vl-registry-read
					 (strcat sProdKey "\\" n)
					 "BuildVer"
				       )
				       (vl-registry-read
					 (strcat sProdKey "\\" n)
					 "SPNum"
				       )
				 )
			   )
		     )
	  lBuildData (append lBuildData lData)
    )
  )
)
