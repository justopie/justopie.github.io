---
layout: post
title: Freeze Object Label's layer - Revised
published: true
tags: [AutoLISP, Civil 3D, Layers, Labels, Annotation]
author: Richard Lawrence
---
Last week, I showed how to freeze the assigned layer of an object label.  Unfortunately, I missed a check within the code when the layer is also the current layer.

To correct this, we will examine the _FreezeLabelLayer sub-routine.  This routine requires three arguments, a string, a list, and a boolean.

The string argument specifies the object type associated with the label.   The message to the user on a successful operation includes this string. 

<Insert code here showing the object type string>

The list contains two strings.  This list has the label's assigned layer name and the label style name.  We should instead remove this list and supply the two strings as arguments.

<Insert Code Here showing the conversion of the list to strings>

The boolean is never used in the original code. The intent of this boolean to determined the type of layer freeze (VPLAYER or LAYER).  Now, we will put a check when the current view is within a paperspace viewport.

<Insert code here showing the new conditional branch for vpfreeze \ layer>

In the first if logic test, we verify the list argument is a list a list.  Yet, we converted the list to a couple of strings.  Thus, we can repurpose this logic test to check against the current layer.  When doing this, we then need to add a second branch to alert the user when the layer matches the current layer.

Prior to the next if branch we should add a test the layer against the current layer name. If it is a match, skip the layer freeze and report to the user of the situation.

Now that we have found the missing test, I think we should review the arguments for the sub-routine.