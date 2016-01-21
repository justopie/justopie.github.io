---
layout: post
title: Add a Point to a Point Group with AutoLISP - Continued
published: true
tags: [AutoLISP, Civil 3D, Point Groups, Points]
author: Richard Lawrence
---
![Points]({{ site.url }}/assets/addpoints.png) Building on [last week's post]({% post_url 2016-01-18-add-a-point-to-a-point-group-with-autolisp %}), we came to a point with a routine to add a point number to a point group with AutoLISP.  The routine was complete, however it required one to know the point number and also have a reference to the Point Group object.

The routine would be easier to the user if a selection set was allowed to select the points.  This subroutine will ask the user to select COGO Points from the drawing.

### <a name="SelectPointsToList">Select Points to List</a>

{% include samples/containspoint.html %}

This subroutine is looking for the point group object to query and the point number to search.  The return value will be T when the point is found and nil otherwise.  Now we can check to see if a point is in the point group.

To add points to a point group, we must first access the `QueryBuilder` property.  We can do that with the `vlax-get-property` function.  This routine will return the QueryBuilder property object of the provided point group.

### <a name="getquerybuilder">Get Query Builder</a>

{% include samples/getquerybuilder.html %}

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

{% include samples/addpointtogroup.html %}

In my next post, I'll pull it all together for daily use.