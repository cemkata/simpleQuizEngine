<!DOCTYPE html>
<html>
<head>
<title>Test engine 0.4</title>
<link rel='stylesheet' href='/static/style_main.css'>
<style>
/*<!--https://www.w3schools.com/css/css_form.asp -->*/
</style>
</head>
<html>
   <body>
	    %if comand == 1:
	<h3>Select corse</h3>
		%else:
	<h3>Select dump</h3>
		% end

<div>
	% for i in items:
	    %if comand == 1:
		 <input type="button" onclick="location.href='./showDumps?courseID={{i}}';" value="{{i}}" />
		%elif comand == 2:
		 <input type="button" onclick="location.href='./start?courseID={{cid}}&examID={{i}}';" value="{{i}}" />
		% end
	% end
	
	    %if comand == 2:
	<input type="button" id = "backButton" onclick="window.history.back();" value="Back" />
		% end
</div>
   </body>
</html>
<!-- © Copyright 2021, Angel Garabitov -->