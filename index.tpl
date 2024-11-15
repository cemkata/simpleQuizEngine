<!DOCTYPE html>
<html>
<head>
<title>Test engine</title>
<link rel='stylesheet' href='/static/style_main.css'>
	    %if comand == 4:
<link rel='stylesheet' href='/static/progressbar.css'>
		% end
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
		 <tr><td colspan="4"><input type="button" class="btnDarkRed" onclick="location.href='./addquiz?courseID={{cid}}';" value="&#10001; Add new quiz &#10002;" /></td></tr>
    %end ##%if comand == 4:
	%if comand == 3:
		 <tr><td colspan="3"><input type="button" class="btnDarkRed" onclick="location.href='./addcategory';" value="&#10001; Add new category &#10002;" /></td></tr>
    %end ##%if comand == 3:

	% for i in items:
	   <tr>
	    %if comand == 1:
		 <td><input type="button" class="btnGreen" onclick="location.href='./showDumps?courseID={{i}}';" value="{{i}}" /></td>
		%elif comand == 2:
		 <td><input type="button" class="btnGreen" onclick="location.href='./start?courseID={{cid}}&examID={{i}}';" value="{{i}}" /></td>
		%elif comand == 3:
		 <td><input type="button" title="List quizes" class="btnGreen" onclick="location.href='./showDumps?courseID={{i}}';" value="{{i}}" /></td>
		 <td><input type="button" title="Edit" class="btnRed smallBtn" onclick="location.href='./editCategory?courseID={{i}}';" value="&#9998;" /></td>
		 <td><input type="button" title="Delete" class="btnRed smallBtn" onclick="confirmDelete('./deleteCategory?courseID={{i}}');" value="&#128465;" /></td>
		%elif comand == 4:
		 <td><input type="button" title="List questions" class="btnGreen" onclick="location.href='./listquestions?courseID={{cid}}&examID={{i}}';" value="{{i}}" /></td>
		 <td><input type="button" title="Edit" class="btnRed smallBtn" onclick="location.href='./editDump?courseID={{cid}}&examID={{i}}';" value="&#9998;" /></td>
		 <td><input type="button" title="Delete" class="btnRed smallBtn" onclick="confirmDelete('./deleteDump?courseID={{cid}}&examID={{i}}');" value="&#128465;" /></td>
		 <td><input type="button" title="Export" class="btnOrange smallBtn" onclick="saveFile('/main/get?courseID={{cid}}&examID={{i}}&fileDownload=true');" value="&#9660;" /></td>
		% end
		</tr>
	% end
	
	    %if comand == 2:
		<tr><td colspan="3"><input type="button" id="backButton" onclick="window.history.back();" value="Back" /></td></tr>
		%elif  comand == 4:
		<tr><td colspan="4"><input type="button" id="backButton" onclick="window.history.back();" value="Back" /></td></tr>
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
		<tr><td colspan="4"><input type="button" id="uploadButton" class="btnOrange" onclick="upload(`{{cid}}`);" value="&#9650; Upload &#9650" /></td></tr>
<div id="overlay">
<div class="demo-container">
  <center>Uploading exam file please wait.</center>
</div>
<div class="demo-container">
  <div class="progress-bar">
    <div class="progress-bar-value"></div>
  </div>
</div>

</div>
		<script>
		function upload(courseID){
			var input = document.createElement('input');
			input.type = 'file';
			input.click();
			input.onchange = e => {
				document.getElementById("overlay").style.display = "block";
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
		function saveFile(url, filename) {
			const a = document.createElement("a");
			a.href = url + filename;
			document.body.appendChild(a);
			a.click();
			document.body.removeChild(a);
		}
		</script>
		
		% end
	</table>
</div>
   </body>
</html>
% include('footer.tpl')