---
layout: post
title: User Prompt with Keywords and a Default Option
published: true
tags: [AutoLISP]
author: Richard Lawrence
---
A lot of routines need to request user input.  Fortunately, AutoLISP allows for this through the many getxxx functions.  There is even a way to restrict user input to predefined values. The getkword function allows the programmer to specify these predefined values.

The talented Lee Mac explains this method in the tutorial on [Prompting with a Default Option](http://www.lee-mac.com/promptwithdefault.html).  Yet, I would prefer to reuse this method. Thus, we will need a routine which is generic enough for repeat use.

In making this routine, I foresee the need for about three arguments (a list of keywords, a string prompt to the user, and which keyword is the default option).

The first argument, a list of keywords, is simple.  Create a list containing each keyword.

<div class="highlight"><pre>
	 <span class="brkt">(</span><span class="func">setq</span> lOptions <span class="func">'</span><span class="brkt">(</span><span class="str">"Alpha" "Beta" "Gamma"</span><span class="brkt">))</span>
</pre><a href="#" onclick="selectCode(this); return false;">Select all</a></div>

Now that we have a list of keywords, we will need to transform them into a combined string.  For that, I'll use the following routine.

<div class="highlight"><pre>
	<span class="brkt">(</span><span class="func">defun</span> op:implode <span class="brkt">(</span>data delim <span class="func">/</span> str n<span class="brkt">)</span>
		<span class="cmt">;; Join list items into string with delimiter string</span>
		<span class="cmt">;;_ Copyright © 2013-2016 by Richard Lawrence</span>
		<span class="brkt">(</span><span class="func">if</span> <span class="brkt">(</span><span class="func">and</span> <span class="brkt">(</span><span class="func">=</span> <span class="brkt">(</span><span class="func">type</span> data<span class="brkt")</span> <span class="quot">'</span><span class="func">LIST</span><span class="brkt">)</span>
				<span class="brkt">(</span><span class="func">=</span> <span class="brkt">(</span><span class="func">type</span> delim<span class="brkt">)</span> <span class="quot">'</span>STR<span class="brkt">)</span>
				<span class="brkt">(</span><span class="func">></span> <span class="brkt">(</span><span class="func">strlen</span> delim<span class="brkt">)</span> 0<span class="brkt">)</span>
			<span class="brkt">)</span>
			<span class="brkt">(</span><span class="func">foreach</span> n data
				<span class="brkt">(</span><span class="func">if</span> str
					<span class="brkt">(</span><span class="func">setq</span> str <span class="brkt">(</span><span class="func">strcat</span> str delim n<span class="brkt">)</span><span class="brkt">)</span>
					<span class="brkt">(</span><span class="func">setq</span> str n<span class="brkt">)</span>
				<span class="brkt">)</span>
			<span class="brkt">)</span>
		<span class="brkt">)</span>
	<span class="brkt">)</span>
</pre><a href="#" onclick="selectCode(this); return false;">Select all</a></div>

This routine requires two arguments (the list data and a string delimiter).  The routine will cycle through the list items concatenating each with the delimiter.  It will then return a combined string of keywords separated by a delimiter.

Our next argument, the string prompt, is a simple string.  We will combine this prompt with the delimited keyword string.  But we are not done yet.

We still do not know which keyword is the default option. So, we need our last argument, the default option.  We will need this argument specified as an integer.  This argument will correspond to one of the keywords in our list. 

<div class="highlight"><pre>
	<span class="brkt">(</span><span class="func">if</span> <span class="brkt">(</span><span class="func">and</span> <span class="brkt">(</span><span class="func">>=</span> iDefault <span class="brkt">(</span><span class="func">length</span> lTypes<span class="brkt">))</span>
		<span class="brkt">(</span><span class="func"><=</span> iDefault <span class="int">0</span><span class="brkt">)</span>
		<span class="brkt">)</span>
		<span class="cmt">;; Error check to verify the default</span>
		<span class="cmt">;; integer is within parameters</span>
		<span class="brkt">(</span><span class="func">setq</span> iDefault <span class="brkt">(</span><span class="func">1-</span> <span class="brkt">(</span><span class="func">length</span> lTypes<span class="brkt">)))</span>
		<span class="brkt">(</span><span class="func">setq</span> iDefault <span class="brkt">(</span><span class="func">1-</span> iDefault<span class="brkt">))</span>
	<span class="brkt">)</span>
</pre><a href="#" onclick="selectCode(this); return false;">Select all</a></div>

Unlike most lists which start counting at 0, I chose to make this argument start at 1.  If this argument is out of range of the length of the keyword list, it will assign the last keyword as the default.

Now that we have all three arguments, we can create the strings for the initget function and the user prompt.

<div class="highlight"><pre>
  <span class="brkt">(</span><span class="func">initget</span> <span class="brkt">(</span><span class="func">op:implode</span> lTypes <span class="str">" "</span><span class="brkt">))</span>
  <span class="cmt">;; sets the initget values</span>
  <span class="brkt">(</span><span class="func">setq</span>	X <span class="brkt">(</span><span class="func">getkword</span>
	    <span class="brkt">(</span><span class="func">strcat</span> <span class="str">"\n"</span>
		    sPrompt
		    <span class="str">" ["</span>
		    <span class="brkt">(</span><span class="func">op:implode</span> lTypes <span class="str">"/"</span><span class="brkt">)</span>
		    <span class="str">"] &lt;"</span>
		    <span class="brkt">(</span><span class="func">nth</span> iDEFAULT lTypes<span class="brkt">)</span>
		    <span class="str">"&gt;: "</span>
	    <span class="brkt">)</span>
	  <span class="brkt">)</span>
  <span class="brkt">)</span>
</pre><a href="#" onclick="selectCode(this); return false;">Select all</a></div>

You can download the completed code below.

{% include samples/snippet/_kp/OP_KWordPrompt.html %}

