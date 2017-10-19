---
layout: post
title: Retrieve AutoCAD Build Data using AutoLISP
published: true
tags: [AutoCAD, AutoLISP]
author: Richard Lawrence
---
I noticed earlier today a post on [Facebook](https://www.facebook.com/groups/CADManagersUnite/permalink/1919418878075919/) asking for a programmatic method to query the service pack, update, hotfix, etc. of multiple seats of AutoCAD Civil 3D.  I'm not certain this bit of code satisfies all of this request, but it may help.

The AutoCAD vlax-machine-product-key provides a string containing a portion of the Windows registry for the current running AutoCAD.  In the post above, a registry path name to the Release key provided a value that may be different from the current version of AutoCAD.  This is caused by patches and updates to the program.

With some testing it turns out the current patched version number is located in the Windows Registry.  However, it is not on the same registry branch (ACAD-0000:409) as mentioned in the Facebook post.  The branch containing the current version does not include the LocaleID (409).  Therefore, removing the LocaleID from the product key registry path, a ProductInfo registry branch can be found.

This ProductInfo registry branch contains the name of each installed version of the current product key in addition to the BuildVer and SPNum.  My assumption is these last two items are the Build Version and the Service Pack number, but that is pure speculation.

The ProductInfo registry branch is found in AutoCAD version ranging from 2016 to 2018.  Earlier versions did not include this registry branch.

The code below returns a list of information from the ProductInfo registry branch. It also includes the computer name, because it wouldn't make much sense to provide a list of information

### <a name="getbuilddata"></a>Get AutoCAD Build Data
{% include samples/OP_GetACADBuildData_1.0.html %}

How you may document this information is up to the user.  

Remember, modifying the Windows Registry is a dangerous task.  The code posted with this post is designed to only read from the Windows Registry.

If you have suggestions to improve this code, please leave a comment.
