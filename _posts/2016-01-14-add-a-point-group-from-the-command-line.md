---
layout: post
title: Add a Point Group from the command line
published: true
tags: [Point Group, Civil 3D]
---
For many years, I have tinkered with customizing AutoCAD using AutoLISP.  Once I moved to Civil 3D, I was limited in using AutoLISP to continue writing routines to automate tedious tasks.  As the Civil 3D has matured, the AutoLISP access to Civil 3D items in the drawings has increased.

Today, I need to create a point group to organize some points in my drawing.  The current method OOTB requires one to right-click the Point Groups branch found in the Tool Space.  This is one of those tedious tasks, which can't be automated if it must use the mouse to interact.<!--more-->

Fortunately, the Point Groups property can be retrieve from the active Civil 3D document.  First, we need to retrieve the active Civil 3D document.  To do that, we can use this routine.

[Civil 3D Active Document](#c3ddoc)

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

According to some, this may not be the most efficient code to retrieve the active Civil 3D document, but my purpose for this routine is not currently meant to run numerous times at once.  Naturally, it is still faster than completing the tasks manually.  In the future, I may see where this can be improved without requiring an edit for each release of Civil 3D.

Now that we have a routine to retrieve the active Civil 3D document, we can retrieve the Point Groups property.  This would be a simple one line function.

[Point Groups Property](#pointgroups)

```lisp
(vlax-get-property (OP:c3ddoc) 'PointGroups)
```

The Point Groups property is actually a collection of the point groups in the drawing.  There are many other collections used in AutoCAD and many of it's verticals.  Therefore, I came up with this function to either add a new item to the collection or get the specificly named item from the collection.

[Add or Get Item From A Collection](#addorgetitem)

```lisp
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
```

Finally, we can pull all of this together to add or get an existing point group.

```lisp
(defun AddPointGroup (strName / objGroup objGroups)
  (if (and (setq objGroups (vlax-get-property (op:c3d) 'PointGroups))
	   (setq objGroup (addorgetitem objGroups strName))
      )
    objGroup
  )
)
```

This will return the Point Group object.