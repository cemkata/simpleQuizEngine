<!DOCTYPE html>
<html>
<head>
<title>Set new name</title>
<link rel='stylesheet' href='/static/style.css'>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style>
/*<!--https://www.w3schools.com/css/css_form.asp -->*/
</style>

</head>
<body>
<h3>Name:</h3>
<div>


<form action="./{{action}}" method="post">

	<label for="name">Name:</label><label style="color:red">*</label>
% if defined('name'):
	<input type="text" id="name" name="name" value="{{name}}" required>
% else:
	<input type="text" id="name" name="name" required>
% end
	<br><br>

% if defined('cid'):
	<input type="hidden" id="cid" name="cid" value="{{cid}}">
% end
% if defined('quiz_id'):
	<input type="hidden" id="qid" name="qid" value="{{quiz_id}}">
% end
	<input type="submit" value="Submit">
</form>
</div>
<input type="button" id = "backButton" onclick="window.history.back();" value="Back" />
</body>
</html>
% include('footer.tpl')