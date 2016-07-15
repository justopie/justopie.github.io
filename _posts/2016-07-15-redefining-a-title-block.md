---
layout: post
title: Redefining a Title Block
published: true
tags: [AutoCAD, Blocks]
author: Richard Lawrence
---
Several years back I found a great write-up on STB plotting.  Unfortunately, the bookmark I had was lost after a hard drive crash.  I won't debate the pros and cons here as it has been done numerous times on several web blogs and forums in the past. [CADDManager Blog](http://www.caddmanager.com/CMB/2009/08/cad-standards-ctb-vs-stb/), [AUGI](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=8&cad=rja&uact=8&ved=0ahUKEwj24cfK8PXNAhUCQyYKHeT1BgEQFghaMAc&url=http%3A%2F%2Fforums.augi.com%2Fshowthread.php%3F72105-CTB-vs-STB&usg=AFQjCNH1iyGMUz0YV--FRsfkb6YrUVwV9Q&sig2=qkwh8knqN1hrqxgYUeBRig), [Autodesk](http://forums.autodesk.com/t5/autocad-2007-2008-2009/age-old-question-ctb-vs-stb/td-p/2641972) and [CADTutor](http://www.cadtutor.net/forum/showthread.php?21647-CTB.-vs-STB.-plot-styles) Anyway, that article prompted me to move my firm to STB plotting.

With that move, I found I needed to update our title block to use the new STB plot styles.  As we also insert our title block in each drawing as opposed to creating a reference to it.  (There is a debate for that method, too.)  It just means I need to update more drawings.

To update the drawings, I worked up a bit of AutoLISP code to query the possible block names that represent our titleblock blocks.

### <a name="possibleblocks">Titleblock Drawing Names</a>
{% include samples/snippets/rt/__PossibleBlocks.html %}

The list of possible block names will need to be edited in this routine.  One will only want to update this list to include each drawing file needed for redefining existing blocks in the current drawing.

### <a name="queryblocksloop">Loop Through Inserted Blocks</a>
{% include samples/snippets/rt/__QueryBlocksLoop.html %}

This foreach loop cycles through the provided list of block names. It then searches the inserted blocks for that name.

### <a name="queryplotstyle">Query Plot Style</a>
{% include samples/snippets/rt/__QueryPlotStyle.html %}

Now that we have determined the block is in the drawing, we move on to check the drawing plotting style.  This will determine if a STB based drawing block is used to reinsert the block definition.

We will also want to check if a drawing with a the same filename but with an "-STP" suffix is available.  Otherwise, the original filename will be used.

### <a name="redeftitle">Redefine Titleblock Definition</a>
{% include samples/OP_RedefTitle_1.1.html %}

This routine is intended to run once per drawing.  It should not hurt to run it multiple times, though.