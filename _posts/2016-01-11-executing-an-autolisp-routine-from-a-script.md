---
layout: post
title: Executing an AutoLISP routine from a Script
published: true
tags: [scripting, AutoLISP, AutoCAD]
author: Richard Lawrence
---
Do you need to run a script on multiple AutoCAD drawings?  One can do that with [ScriptPro](https://knowledge.autodesk.com/support/autocad/downloads/caas/downloads/content/autodesk-customization-conversion-tools.html).

But what if you need to rename a all of the layers in a drawing?  If you only use a script file, you wouldn't be able to loop through all of the layers in the drawing, nor would you be able to use the [-RENAME](http://help.autodesk.com/view/ACD/2016/ENU/?guid=GUID-3C68B0FF-A56F-401E-A58B-6174259252A6) command at the command line as it does not allow for wildcard replacements.

You will need to add an additional programming language to assist your script.  A fairly easy language would be AutoLISP.  You could also use other more powerful languages, such as .NET or ObjectARX. I feel the more powerful languages may be a bit much when developing a script for quick edits on multiple drawings.

Now, over on the Autodesk forums, BlackBox shared an AutoLISP routine to [add a prefix to all of the layers](https://forums.autodesk.com/t5/visual-lisp-autolisp-and-general/batch-rename-layer-lisp-for-autocad-mac/m-p/3876845#M310526).  For this example, we would want to copy all of the code and save it in a file where we can find it with a *.lsp* extension.  Knowing where we saved it will allow us to tell the script where to find this file.  We will also need to know the name of the AutoLISP command, which is *LayPrefix*, to add to our script.

Adding this line to the script will load the file into your current session of AutoCAD. The double back slashes in the code are necessary as the back slash is an control character.

```lisp
(load "X:\\Path\\To\\Saved\\File\\LayPrefix.lsp")
```

Once our routine is loaded, we can then add the name of the routine, *LayPrefix*, to our script and follow it with the prefix we wish to add to the layer names.

```text
LayPrefix
EXISTING-
```

We can now run our script across multiple drawings with the help of ScriptPro and AutoLISP.