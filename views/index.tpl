<!DOCTYPE html>
<html>
<head>
<title>Test engine</title>
<link rel='stylesheet' href='/static/style_main.css'>
<style>
/*<!--https://www.w3schools.com/css/css_form.asp -->*/
</style>
</head>
<html>
   <body>
	    %if comand == 1:
	<h3>Select course</h3>
		%else:
	<h3>Select dump</h3>
		% end
<div>
 <table>
 	%if comand == 4:
		 <tr><td colspan="3"><input type="button" class="btnDarkRed" onclick="location.href='./addquiz?courseID={{cid}}';" value="Add new quiz" /></td></tr>
    %end ##%if comand == 4:
	%if comand == 3:
		 <tr><td colspan="3"><input type="button" class="btnDarkRed" onclick="location.href='./addcategory';" value="Add new category" /></td></tr>
    %end ##%if comand == 3:

	% for i in items:
	   <tr>
	    %if comand == 1:
		 <td><input type="button" class="btnGreen" onclick="location.href='./showDumps?courseID={{i}}';" value="{{i}}" /></td>
		%elif comand == 2:
		 <td><input type="button" class="btnGreen" onclick="location.href='./start?courseID={{cid}}&examID={{i}}';" value="{{i}}" /></td>
		%elif comand == 3:
		 <td><input type="button" class="btnGreen" onclick="location.href='./showDumps?courseID={{i}}';" value="{{i}}" /></td>
		 <td><input type="button" class="btnRed" onclick="location.href='./editCategory?courseID={{i}}';" value="Edit" /></td>
		 <td><input type="button" class="btnRed" onclick="confirmDelete('./deleteCategory?courseID={{i}}');" value="Delete" /></td>
		%elif comand == 4:
		 <td><input type="button" class="btnGreen" onclick="location.href='./listquestions?courseID={{cid}}&examID={{i}}';" value="{{i}}" /></td>
		 <td><input type="button" class="btnRed" onclick="location.href='./editDump?courseID={{cid}}&examID={{i}}';" value="Edit" /></td>
		 <td><input type="button" class="btnRed" onclick="confirmDelete('./deleteDump?courseID={{cid}}&examID={{i}}');" value="Delete" /></td>
		% end
		</tr>
	% end
	
	    %if comand == 2 or comand == 4:
		<tr><td colspan="3"><input type="button" id="backButton" onclick="window.history.back();" value="Back" /></td></tr>
		% end
		
	    %if comand == 3 or comand == 4:
		<script>
		function confirmDelete(url) {
			if (confirm('Are you sure you want to delete this?')) {
			  location.href = url;
			}
		}
		</script>
		% end
		
		
	    %if comand == 4:
		<tr><td colspan="3"><input type="button" id="uploadButton" onclick="upload(`{{cid}}`);" value="Upload" /></td></tr>
		
		<script>
		function upload(courseID){
			var input = document.createElement('input');
			input.type = 'file';
			input.click();
			input.onchange = e => { 
				const inputFile = e.target.files[0];
				const fd = new FormData();

				fd.append("file", inputFile);
				fd.append("courseID", courseID);

				fetch("./importFile", {
					method: "post",
					body: fd,
				}).then((response) => {
					if(response.status == 200){
						location.reload();
					}else if(response.status == 403){
						alert("File with this name exist")
					}else{
						alert("Error")
					}
				}).catch((error) => (alert("Something went wrong!\n" + error)));
			}
		}
		</script>
		
		% end
	</table>
</div>
   </body>
</html>
% include('footer.tpl')