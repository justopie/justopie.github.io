---
layout: post
title: Retrieve COGO Point Object
published: true
tags: [AutoCAD, AutoLISP, Civil 3D, Points]
author: Richard Lawrence
---
Usually, when attempting to modify objects within drawings, one must ensure the object exists within the drawing.  If the object doesn't exist, but code attempts to modify it, your code will probably not complete as expected.

Today's code does just that for Civil 3D point objects.

Using the [code I previously posted](http://justopie.github.io/blog/2016/01/how-to-add-a-point-group-with-autolisp/#c3ddoc) to retrieve the current Civil 3D drawing document allows us to retrieve the Point Collection.  We can then query the collection with the supplied point ID.  The result of that query would return the existing point object or nil for non-existing point ids.

### <a name="getpoint"></a>Get Point Object
{% include samples/OP_GetPoint_1.0.html %}

This is intended as a sub-routine. One would need to supply the point id to this routine as an integer or string.

If you have suggestions to improve this code, leave a comment below.