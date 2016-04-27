---
layout: post
title: Reformatting DMS Bearings in the Surveyor's Certificate Report
published: true
tags: [XSL, Civil 3D, Reports]
author: Richard Lawrence
---
Recently, I was tasked with modifying the Metes and Bounds report found in the Toolbox of the Toolspace palette.  This report is generated using an XSL template and also uses some javascript for some formatting.

This report is found in the XSL sub-folder of the Reports folder.  This folder is found in at this path C:\ProgramData\Autodesk\C3D 20XX\enu\Data\Reports\  Of course, you will want to change the "C3D 20XX" portion to the latest version of the Civil 3D installed on your machine.  Each new version changes the reporting path for LandXML reporting.

Before continuing, I would recommend copying the original reports you wish to modify and work on the copy.  You can then create a new branch in your Toolbox to point to your edited reports.

The first complaint of this report was the bearings were separated with dashes instead of the typical degree minutes seconds annotation.  This formatting can be found in the formatAngleToDMS function, which is found in the General_Formatting_JScript.xsl file.

<div class="highlight"><pre>function formatAngleToDMS(angle)
{
	var degrees = Math.floor(angle);

	var dMin = 60. * (angle - degrees);
	var minutes = Math.floor(dMin);

	var dSec = 60. * (dMin - minutes);
	var seconds = formatAngleNumber(dSec);

	return degrees + "-" + minutes + "-" + seconds;
}</pre></div>

This function converts an angle in decimal degrees into a the typical degrees minutes seconds format. I'm not going to get into the math on this one.

The last line of this function returns the three elements with the dash separators.  We will need to change these dashes to the appropriate characters.

<div class="highlight"><pre>
	return degrees + "°" + minutes + "'" + seconds + "\"";
</pre></div>

I would recommend saving these changes to a new files.

One of the downsides to this, though, is the need to edit the JavaScript includes located at the top of your customized XSL reports.