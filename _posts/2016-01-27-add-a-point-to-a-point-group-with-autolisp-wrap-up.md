---
layout: post
title: Add a Point to a Point Group with AutoLISP - Wrap-up
published: true
tags: [AutoLISP, Civil 3D, Point Groups, Points]
author: Richard Lawrence
---
![Points]({{ site.url }}/assets/addpoints.png) Building on [last week's post]({% post_url 2016-01-18-add-a-point-to-a-point-group-with-autolisp %}), we came to a point with a routine to add a point number to a point group with AutoLISP.  The routine was complete, however it required one to know the point number and also have a reference to the Point Group object.

The routine would be easier to the user if a selection set was allowed to select the points.  This subroutine will ask the user to select COGO Points from the drawing.

### <a name="SelectPointsToList">Select Points to List</a>

{% include samples/selectpointtolist.html %}

Once we select the points, we then need to display a dialog box listing the available point groups.  Dialog boxes have not one of those tools I choose to use in the majority of my routines.  However, this routine needs a dialog box as the dynamic input available with the <code>[getkword](https://knowledge.autodesk.com/search-result/caas/CloudHelp/cloudhelp/2016/ENU/AutoCAD-AutoLISP/files/GUID-9F940144-0D7B-4DA1-BF50-BBF8FB8DFF21-htm.html)</code> function does not work as expected with the variable names allowed with point groups.

### <a name="createdialog">Create a Dialog</a>

{% include samples/createDialog.html %}

We also need to retrieve the names of the available Point Groups in the current drawing.  To do this we can query the Point Groups collection.

### <a name="getpointgroupnames">Get Point Group Names</a>

{% include samples/getPointGroupNames.html %}

We'll also need to parse the collection to retrieve all of the item names.

### <a name="collectionnamestolist">Collection Names to List</a>

{% include samples/collectionnamestolist.html %}

With all of the subroutines worked out, we can now put it all together.  Once saved as a file, you can load this file into AutoCAD Civil 3D and use the <code>AddToPG</code> command to start.

### <a name="AddToPG">Add to Point Group</a>

{% include samples/addPG.html %}