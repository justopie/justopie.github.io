---
layout: post
title: Freeze Object Label's layer - Revised
published: true
tags: [AutoLISP, Civil 3D, Layers, Labels, Annotation]
author: Richard Lawrence
---
[last week]({% post_url 2016-02-03-freeze-labels-layer-civil-3d-object %})Last week, I showed how to freeze the assigned layer of an object label.  Unfortunately, I missed a check within the code when the layer is also the current layer.

To correct this, we will examine the _FreezeLabelLayer sub-routine.  The first <code>if</code> branch, a check to see if we are dealing with a list of the label's data.  This list consists of the layer and the label style name.

Prior to the next <code>if</code> branch we should add a test of the layer against the current layer name. If it is a match, skip the layer freeze and report the situation to the user.

Now that we have found the missing test, I think we should review the arguments for the sub-routine.  There are three different arguments, a string, a list, and a boolean.

The string argument specifies the object type associated with the label.   The message to the user on a successful operation contains this string. 

The list contains two strings.  This list has the label's assigned layer name and the label style name.  We should remove this list and supply the two strings as arguments.

The boolean is never used. Originally, this boolean was intended to determine which type of freeze (VPLAYER or LAYER) to use in handling the layer.  I think I'll remove this at this time.