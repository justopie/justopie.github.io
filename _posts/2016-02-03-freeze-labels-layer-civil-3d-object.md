---
layout: post
title: Freeze the Label's layer of a Civil 3D Object
published: true
tags: [AutoLISP, Civil 3D, Layers, Labels, Annotation]
author: Richard Lawrence
---
Many times I'll need to freeze Civil 3D labels found in referenced drawings (XREF). Unfortunately, the layer assigned to the label may not match the object's layer.  This means the AutoCAD LAYFRZ command will not freeze the expected layer.

To remedy this, we need to first access the object data containing the label.  We can do this with the nentselp AutoLISP function.  You can read up on the [documentation](https://knowledge.autodesk.com/search-result/caas/CloudHelp/cloudhelp/2016/ENU/AutoCAD-AutoLISP/files/GUID-5CE182FE-6455-4C62-B953-B1CA441455C1-htm.html) to see how it works.

Once we have the object selected, we can query it to see what type we are working with. Using the ObjectName property, we can then retrieve the label's layer.

For example, the LableStyle property references the label object of a COGO point.

{% include samples/snippet/olf/__cogo.html %}

The Note object also uses the LabelStyle property reference.

{% include samples/snippet/olf/__note.html %}

A Parcel object uses the AreaLabelStyle property to reference the label.

{% include samples/snippet/olf/__parcel.html %}

While the Parcel Segment labels use the LineLabelStyle and the CurveLabelStyle.

Now that we have the label style reference, we need to explore the actual style.  We can find the assigned layer several levels down.

{% include samples/snippet/olf/_LabelPropertyValue.html %}

I prefer to only freeze the layer in the viewport.  This allows me to still view it in model space, as needed.

{% include samples/snippet/olf/_FreezeLabelLayer.html %}

You can download the completed code below.

{% include samples/snippet/olf/ObjectLayerFreeze.html %}

This may not work as expected if the assigned layer is "0" in the label style.

If you have any other Civil 3D objects you feel may work with this method, leave me a note in the comments.