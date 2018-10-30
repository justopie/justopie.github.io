---
layout: post
title: Add C3D Note Label
published: true
tags: [Annotation, AutoLISP, Civil 3D]
author: Richard Lawrence
---
I recently ran across a post on the Facebook group [CAD Managers Unite!](https://www.facebook.com/groups/CADManagersUnite/permalink/2563012547049879/) inquiring how to place a Civil 3D command on the tool palette with a specific settings.

As with most things Civil 3D, this is not a trivial task.

My first suggestion to do this is to create a drawing with the desired style.  This could be done either by using the AutoCAD [WBLOCK](https://knowledge.autodesk.com/support/autocad/learn-explore/caas/CloudHelp/cloudhelp/2019/ENU/AutoCAD-Core/files/GUID-297ED4C5-DADC-4C3B-B4FA-94C56A04721B-htm.html?st=wblock) command, or using the Civil 3D [IMPORTSTYLESANDSETTINGS](https://knowledge.autodesk.com/support/civil-3d/learn-explore/caas/sfdcarticles/sfdcarticles/How-to-copy-a-style-from-one-drawing-to-another-drawing-in-Civil-3D.html) command.  This method would allow you to place the drawing onto the Tool Palette for later execution.  I would suggest setting the block to explode upon insertion to reduce clutter within the drawing.  Once the note label is within the drawing, the contents may need to be edited as needed.

Be aware, if the drawing is created with the WBLOCK command, additional objects may be included if they are referenced in your chosen style.

Another method would be to automate this task with AutoLISP.  Fortunately, this is one area of Civil 3D that is partially available to AutoLISP.

We will first need to again reuse some [code I previously posted](http://justopie.github.io/blog/2016/01/how-to-add-a-point-group-with-autolisp/#c3ddoc) to retrieve the current Civil 3D drawing document.  This will allow us to inspect the drawing for the available note label styles.

We will then check the available note label styles.  These would be found in the `General Note Label Styles` property. (I've spaced out the property name for readability.)  In most AutoCAD collections, the desired item can be found easily with the `vla-item` If our specified note label style name is present  We wouldn't want to add a new label with a style that doesn't exist.  That may cause a problem down the line.

### <a name="getobjectproperty"></a>Get Object Property
{% include samples/snippet/anl/__OP_GetObjProperty_1_0.html %}

If the style is available, we need to change the default note label style setting.  This setting is buried a bit within the document properties.  It can be found at `Settings` -> `General Settings` -> `Style Settings` -> `Note Label Style` -> `Value`.  Again, I've spaced out the property names to aid in readability.

### <a name="setobjectproperty"></a>Set Object Property
{% include samples/snippet/anl/__OP_SetObjProperty_1_0.html %}

And now back to the partial availability part.  We will use the `Command` AutoLISP function to call the Civil 3D command of `AddNoteLabel`.

### <a name="addnotelabel"></a>Add Note Label
{% include samples/OP_AddNoteLabel_1_0.html %}

This is intended as a sub-routine.  One would need to supply the note label style to use as a string.  One could then add this to the Tool Palette multiple times with differing styles.

If you have suggestions to improve this code, leave a comment below.