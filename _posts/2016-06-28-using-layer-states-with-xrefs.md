---
layout: post
title: Using Layer States with XREFs
published: true
tags: [AutoCAD, XREF, Layer States]
author: Richard Lawrence
---
In the past, I've seen requests to use Layer States in a drawing that contains reference drawings, also known as XREFs.  The requests typically want to reuse those layer states for additional drawings, however, they always seem to fail when dealing with XREF layers.

The reason the layer states are failing is due to the XREF layers having different prefixes.  Unless the XREF was renamed in the drawing, the layer prefix will be set to the file name of the associated XREF.  Unless the same file name is used for each project, the next drawing would reference a differently named XREF. Thus, the layer names are also different.

Fortunately, XREF drawings are handled by AutoCAD in a similar fashion to blocks.  Just like a block, the RENAME command will allow a name change of any attached XREFs.

## In Practice

In my line of work, we typically have two or three base drawings we use for referencing.  The base drawings all have a prefix associated with the project number.  This allows for file searches against the project number.  A sample base drawing with project number could be *XYZ-Design.dwg*.

Creating a XREF to that sample base drawing would create a reference name of *XYZ-Design*.  This reference would create a layer name of *XYZ-Design|Defpoints*. (I don't recommend using Defpoints for drawing, but it may actually be in the base drawing.)

For my next project, my design base drawing could be name *ABC-Design.dwg*.  Naturally, the *XYZ* and *ABC* prefixes do not match.  This causes the previously exported layer states to not work.

To remedy this, I will remove the *XYZ* or *ABC* prefix.  Thus the design base drawing would now have a reference name of *Design*.  This name change now provides a standard layer name (i.e.: Design|Defpoints) between projects.  With the standard layer name, you can now import layer states between projects.