---
layout: post
title: Change Pipe Network Flow Direction
published: true
tags: [AutoLISP, Pipe Networks]
author: Richard Lawrence
---
Can I get a show of hands for how many of you wish you could set the default Flow Direction Method when creating pipes? That's a lot of raised hands.  Of course, you can [create a pipe rule in VBA or .NET](http://forums.autodesk.com/t5/autocad-civil-3d-general/pipe-flow-direction-method-by-slope/m-p/2255461#M76514) to have this automated.  But that turns into a lot of steps, just to change this one setting for each pipe. Thankfully, Autodesk has allowed access to this property through AutoLISP.

The property "FlowDirection" is a read-only property of the queried pipe.  But there is another property of the pipe named "FlowDirectionMethod" which is writable.

The FlowDirectionMethod property requires an integer.  The allowable integers range from 0 to 3 and represent "Bi-Directional" at 0, "Start to End", "End to Start", and finally "By Slope" at 3.

<div class="highlight"><pre>
<span class="brkt">(</span><span class="func">defun</span> OP:setFlowMethod	<span class="brkt">(</span>oPipe iMethod <span class="func">/</span> eSetPropertyAttempt<span class="brkt">)</span>
  <span class="cmt">;; Change flow direction method of supplied pipe object</span>
  <span class="cmt">;;_ Copyright &copy; 2016 by Richard Lawrence</span>
  <span class="brkt">(</span><span class="func">setq</span>	eSetPropertyAttempt
	 <span class="brkt">(</span><span class="func">vl-catch-all-apply</span>
	   <span class="quot">'</span><span class="func">vlax-put-property</span>
	   <span class="brkt">(</span><span class="func">list</span> oPipe
		 <span class="quot">'</span>FlowDirectionMethod
		 iMethod
	   <span class="brkt">)</span>
	 <span class="brkt">)</span>
  <span class="brkt">)</span>
  <span class="brkt">(</span><span class="func">if</span> <span class="brkt">(</span><span class="func">vl-catch-all-error-p</span> eSetPropertyAttempt<span class="brkt">)</span>
    <span class="brkt">(</span><span class="func">vl-catch-all-error-message</span> eSetPropertyAttempt<span class="brkt">)</span>
    <span class="func">t</span>
  <span class="brkt">)</span>
<span class="brkt">)</span>
</pre><a href="#" onclick="selectCode(this); return false;">Select all</a></div>

This is intended as a sub-routine.  One would need to supply the associated pipe object and the corresponding integer to this routine.