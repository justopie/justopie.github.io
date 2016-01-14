---
layout: post
title: Add a Point Group from the command line
published: true
tags: [Point Group, Civil 3D]
---
For many years, I have tinkered with customizing AutoCAD using AutoLISP.  Once I moved to Civil 3D, I was limited in using AutoLISP to continue writing routines to automate tedious tasks.  As the Civil 3D has matured, the AutoLISP access to Civil 3D items in the drawings has increased.

Today, I need to create a point group to organize some points in my drawing.  The current method OOTB requires one to right-click the Point Groups branch found in the Tool Space.  This is one of those tedious tasks, which can't be automated if it must use the mouse to interact.

Fortunately, the Point Groups property can be retrieve from the active Civil 3D document.  First, we need to retrieve the active Civil 3D document.  To do that, we can use this routine.

```lisp
(defun OP:c3ddoc (/ prod verstr C3DDoc c3dver)
  (defun c3dver	(/ c3d *acad*)
    (setq C3D (strcat "HKEY_LOCAL_MACHINE\\"
		      (if vlax-user-product-key
			(vlax-user-product-key)
			(vlax-product-key)
		      )
	      )
	  C3D (vl-registry-read C3D "Release")
	  c3d (substr
		C3D
		1
		(vl-string-search "." C3D (+ (vl-string-search "." C3D) 1))
	      )
    )
    c3d
  )
  (setq
    C3Ddoc (vla-get-activedocument
	     (vla-getinterfaceobject
	       (vlax-get-acad-object)
	       (strcat "AeccXUiLand.AeccApplication." (c3dver))
	     )
	   )
  )
)
```