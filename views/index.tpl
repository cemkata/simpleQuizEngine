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
 <table>
 	%if comand == 4:
		 <tr><td colspan="3"><input type="button" style="background-color: darkred;" onclick="location.href='./addquiz?courseID={{cid}}';" value="Add new quiz" /></td></tr>
    %end ##%if comand == 4:
	%if comand == 3:
		 <tr><td colspan="3"><input type="button" style="background-color: darkred;" onclick="location.href='./addcategory';" value="Add new category" /></td></tr>
    %end ##%if comand == 3:
  
	% for i in items:
	   <tr>
	    %if comand == 1:
		 <td><input type="button" onclick="location.href='./showDumps?courseID={{i}}';" value="{{i}}" /></td>
		%elif comand == 2:
		 <td><input type="button" onclick="location.href='./start?courseID={{cid}}&examID={{i}}';" value="{{i}}" /></td>
		%elif comand == 3:
		 <td><input type="button" onclick="location.href='./showDumps?courseID={{i}}';" value="{{i}}" /></td>
		 <td><input type="button" style="background-color: red;" onclick="location.href='./editCategory?courseID={{i}}';" value="Edit" /></td>
		 <td><input type="button" style="background-color: red;" onclick="location.href='./deleteCategory?courseID={{i}}';" value="Delete" /></td>
		%elif comand == 4:
		 <td><input type="button" onclick="location.href='./listquestions?courseID={{cid}}&examID={{i}}';" value="{{i}}" /></td>
		 <td><input type="button" style="background-color: red;" onclick="location.href='./editDump?courseID={{cid}}&examID={{i}}';" value="Edit" /></td>
		 <td><input type="button" style="background-color: red;" onclick="location.href='./deleteDump?courseID={{cid}}&examID={{i}}';" value="Delete" /></td>
		% end
		</tr>
	% end
	
	    %if comand == 2 or comand == 4:
		<tr><td colspan="3"><input type="button" id = "backButton" onclick="window.history.back();" value="Back" /></td></tr>
		% end
	</table> 
</div>
   </body>
</html>
<!-- © Copyright 2021, Angel Garabitov -->