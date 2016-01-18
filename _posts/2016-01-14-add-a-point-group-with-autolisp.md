---
layout: post
title: Add a Point Group with AutoLISP
published: true
tags: [AutoLISP, Civil 3D, Point Groups]
author: Richard Lawrence
---
![Point Groups]({{ site.url }}/assets/pointgroups.png) For many years, I have tinkered with customizing AutoCAD using AutoLISP.  Once I moved to Civil 3D, I was limited in using AutoLISP to continue writing routines to automate tedious tasks.  As the Civil 3D has matured, the AutoLISP access to Civil 3D items in the drawings has increased.

Today, I need to create a point group to organize some points in my drawing.  The [current method](https://forums.autodesk.com/t5/autocad-civil-3d-general/add-points-to-point-group/m-p/2025721#M50725) OOTB requires one to right-click the Point Groups branch found in the Tool Space.  This is one of those tedious tasks, which can't be automated if it must use the mouse or a dialog box to interact.  BTW, you can also [create new Point Groups](http://www.cadtutor.net/forum/showthread.php?68683-Add-cogo-points-to-point-group&p=470352&viewfull=1#post470352) with the `CreatePointGroup` command.

Fortunately, the Point Groups property can be retrieve from the active Civil 3D document.  First, we need to retrieve the active Civil 3D document.  To do that, we can use this routine.

### <a name="c3ddoc">Get Active Civil 3D Document Object</a>
{% include samples/c3ddoc.html %}

According to some, this may not be the most efficient code to retrieve the active Civil 3D document, but my purpose for this routine is not currently meant to run numerous times at once.  Naturally, it is still faster than completing the tasks manually.  In the future, I may see where this can be improved without requiring an edit for each release of Civil 3D.

Now that we have a routine to retrieve the active Civil 3D document, we can retrieve the Point Groups property.  This would be a simple one line function.

### <a name="pointgroups">Get Point Groups Property</a>

{% include samples/getpointgroups.html %}

The Point Groups property is actually a collection of the point groups in the drawing.  There are many other collections used in AutoCAD and many of it's verticals.  Therefore, I came up with this function to either add a new item to the collection or get the specificly named item from the collection.

### <a name="addorgetitem">Add or Get Item from Collection</a>

{% include samples/addorgetitem.html %}

Finally, we can pull all of this together to add or get an existing point group.

### <a name="addpointgroup">Add Point Group</a>

{% include samples/addpointgroup.html %}

This will return the Point Group object.