---
layout: post
title: Add a Point to a Point Group with AutoLISP
published: true
tags: [AutoLISP, Civil 3D, Point Groups, Points]
---
![Points]({{ site.url }}/assets/points.png) With [last week's post]({% post_url 2016-01-14-add-a-point-group-from-the-command-line %}), I showed how to add a Point Group to your Civil 3D drawing.  Of course, only creating point groups isn't the most useful automation tool.  We need a way to add points to point groups without going through all of the manual steps.

Before we start adding points to a point group, we probably should check to see if the points are already contained in the point group.  To do this, we need to see what properties or methods are available with point groups.  Let's dump a point group object to see what it holds.

```lisp
Command: (vlax-dump-object objPointGroup t)
```

```text
; IAeccPointGroup: IAeccPointGroup Interface
; Property values:
;   Application (RO) = #<VLA-OBJECT IAeccApplication 000000df110f00f0>
;   Description = ""
;   Document (RO) = #<VLA-OBJECT IAeccDocument 000000df110f00c0>
;   DrawPriority (RO) = 324
;   Elevation = 0.0
;   Handle (RO) = "81D1"
;   HasExtensionDictionary (RO) = 0
;   IsUpToDate (RO) = -1
;   Name = "Tom"
;   ObjectID (RO) = 250
;   ObjectName (RO) = "AeccDbPG"
;   OverrideElevation = 0
;   OverridePointLabelStyle = 0
;   OverridePointStyle = 0
;   OverrideRawDescription = 0
;   OwnerID (RO) = 48
;   PointCount (RO) = 2
;   PointLabelStyle = #<VLA-OBJECT IAeccLabelStyle 000000df3e140d50>
;   Points (RO) = (105 106)
;   PointStyle = #<VLA-OBJECT IAeccPointStyle 000000dee5d2e060>
;   QueryBuilder (RO) = #<VLA-OBJECT IAeccPointGroupQueryBuilder 000000df110eff70>
;   RawDescription = ""
; Methods supported:
;   ContainsPoint (1)
;   Delete ()
;   GetExtensionDictionary ()
;   GetUserDefinedPropertyClassification (1)
;   GetXData (3)
;   SetUserDefinedPropertyClassification (2)
;   SetXData (2)
;   Update ()
```

With this object dump, we can see we have a couple of points in this group.  However, the Points property is marked read-only `(RO)`.  Is we retrieve the point property, the returned value will be a variant, which will need additional simplification down to a list.

If we keep looking at the properties and methods, we can see the point group has a method of `ContainsPoints (1)`.  The 1 following the name means we must supply one argument to this method for it to work.  Consulting the [Civil 3D .NET API Reference](http://docs.autodesk.com/CIV3D/2015/ENU/API_Reference_Guide/html/57e2c379-a23b-fa8d-943d-c34b6b9d7142.htm), we can see the argument should be an integer.  I guess that means we should supply the method with a point number.

### <a name="containspoint">Contains Point</a>

```lisp
(defun ContainsPoint (objGroup intPoint /)
  (if (and (= (type intPoint) 'INT)
       (= (type objGroup) 'VLA-OBJECT)
       (= (vla-get-ObjectName objGroup) "AeccDbPG")
      )
    (= -1 (vlax-invoke objGroup 'ContainsPoint intPoint))
  )
)
```

This subroutine is looking for the point group object to query and the point number to search.  The return value will be T when the point is found and nil otherwise.  Now that we can check to see if a point is in the point group.

To add points to a point group, we must first access the `QueryBuilder` property.  We can do that with the `vlax-get-property` function.  This routine will return the QueryBuilder property object of the provided point group.

### <a name="getquerybuilder">Get Query Builder</a>

```lisp
(defun GetQueryBuilder (objGroup)
  (if (and (= (type objGroup) 'VLA-OBJECT)
           (= (vla-get-ObjectName objGroup) "AeccDbPG")
      )
    (vlax-get-property objGroup 'QueryBuilder)
  )
)
```

The properties for the QueryBuilder are shown in this object dump.

```text
; IAeccPointGroupQueryBuilder: IAeccPointGroupQueryBuilder Interface
; Property values:
;   ExcludeElevations = ""
;   ExcludeFullDescriptions = ""
;   ExcludeNames = ""
;   ExcludeNumbers = ""
;   ExcludeRawDescriptions = ""
;   IncludeAllPoints (RO) = ...Indexed contents not shown...
;   IncludeElevations = ""
;   IncludeFullDescriptions = ""
;   IncludeNames = ""
;   IncludeNumbers = ""
;   IncludePointGroups = ""
;   IncludeRawDescriptions = ""
;   QueryStatement (RO) = #<VLA-OBJECT IAeccQueryStatement 00000266bf8bdc70>
;   UseCaseSensitiveMatching = 0
```

We can look through the properties and see we have an `IncludeNumbers` property.  This property requires a string.  Therefore, we can add a point number to the point group with this routine.

### <a name="addpointtogroup">Add Point To Group</a>

```lisp
(defun AddPointToGroup (intPoint objGroup / objQB)
  (if (and (= (type intPoint) 'INT)
           (= (type objGroup) 'VLA-OBJECT)
           (= (vla-get-ObjectName objGroup) "AeccDbPG")
           (zerop (ContainsPoint objGroup intPoint))
      )
    (progn
      (setq objQB         (GetQueryBuilder objGroup)
        strIncludeNumbers (vlax-get-property objQB 'IncludeNumbers)
      )
      (if (> (strlen strIncludedNumbers) 0)
        (vlax-put-property objQB 'IncludeNumbers (strcat strIncludedNumbers "," (itoa intPoint)))
        (vlax-put-property objQB 'IncludeNumbers (itoa intPoint))
      )
    )
  )
)
```

In my next post, I'll pull it all together for daily use.