---
layout: post
title: Revision to Add C3D Note Label Routine
published: true
tags: [Annotation, AutoLISP, Civil 3D]
author: Richard Lawrence
---
Looks like the [method I used yesterday]({% post_url 2018-10-30-add-c3d-note-label %}) to add note labels with a predefined style didn't work.

That method attempted to set the default note label style before adding the note label.  This worked initially in testing, but did not work for others.

To remedy this, I removed the change to the default style.  Then made a change of the assigned label style of the recently inserted note label.  This appears to be more reliable.  Unfortunately, this still limits this to one note label per use.

This is still intended as a sub-routine.  Usage as follows...

`(op:addnotelabel "_O_General Note")`

### <a name="addnotelabel"></a>Revised Add Note Label
{% include samples/OP_AddNoteLabel_1_0_1.html %}

If you have suggestions to improve this code, leave a comment below.