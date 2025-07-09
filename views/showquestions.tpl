<!DOCTYPE html>
<html lang="en" class="">
	<head>
	  <meta charset="UTF-8">
	  <title>Editing Dump {{cid + " " + dump}}</title>
	  <meta name="robots" content="noindex">
	  <link rel='stylesheet' href='/static/style.css'>
	<script>
	const RELOAD_ON_DELETE = {{web_editor_conf['RELOAD_ON_DELETE']}};
	function confirmEdit(qid) {
		var cource = document.getElementById("courseID").value;
		var quiz = document.getElementById("quizID").value;
		url = '/editor/editQuestion?courseID=' + cource + "&quizID=" + quiz + "&questionID=" + qid;
		//window.location.href = url
		var win = window.open(url, '_blank');
		win.focus();
		var timer = setInterval(function() {
			if (win.closed) {
				clearInterval(timer);
				location.reload();
			}
		}, 500);
	}
	function confirmDelete(qid) {
		if (confirm(`Are you sure you want to delete question ${qid}?`)) {
		  var cource = document.getElementById("courseID").value;
		  var quiz = document.getElementById("quizID").value;
		  url = '/editor/deleteQuestion?courseID=' + cource + "&quizID=" + quiz + "&questionID=" + qid;
		
		  const xhr = new XMLHttpRequest();
		  xhr.open("DELETE", url);
		  xhr.send();
		  xhr.onload = () => {
		    if (xhr.readyState == 4 && xhr.status == 200) {
		  	    //alert(xhr.response);
				if(RELOAD_ON_DELETE){
					location.reload();
				}else{
					let questionRow = document.getElementById("q_" + qid);
					var currentRow = questionRow.nextElementSibling.nextElementSibling;
					questionRow.nextElementSibling.outerHTML="";
					questionRow.outerHTML="";
					let questionCount = document.getElementById("question_count");
					let text_str_list = questionCount.innerText.split(":")
					totalCount = parseInt(text_str_list[1]);
					totalCount--;
					questionCount.innerText = text_str_list[0] + ": " + totalCount;
					while(currentRow != null){
						if(currentRow.classList.contains("question_rows")){
							let new_id = parseInt(currentRow.id.split("_")[1]) - 1;
							const cell_index = 1;
							currentRow.id = "q_" + new_id;
							let cells = currentRow.getElementsByTagName("td");
							q_number = parseInt(cells[cell_index + 0].childNodes[1].innerText.replace("Question ", "").replace(":", "")) - 1;
							cells[cell_index + 0].childNodes[1].childNodes[1].innerText = "Question " + q_number + ":";
							cells[cell_index + 1].childNodes[0].childNodes[0].setAttribute('onclick',`confirmEdit(${q_number})`)
							cells[cell_index + 2].childNodes[0].childNodes[0].setAttribute('onclick',`confirmDelete(${q_number})`)
						}
						currentRow = currentRow.nextElementSibling.nextElementSibling;
					}
				}
		    } else {
		  	    alert(`Error: ${xhr.status}`);
		    }
		  };
		}
	}
	
	function goToTop(){
		scrollTo(0, 0);
	}
	</script>
	</head>
	<body>
		<input type="hidden" id="cid" value="{{cid}}">
		<input type="hidden" id="dump" value="{{dump}}">
		<h1><a href="./" id="homeLink">Home</a> <b>|</b> Dump {{cid + " " + dump}}</h1>
		
<div>
<input type="hidden" id="quizID" value="{{dump}}">
<input type="hidden" id="courseID" value="{{cid}}">
<table style="width:100%" class="pretyPrint">
  <tr><button class="newQuestion_btn" style="width:100%" onclick="confirmEdit(-1)">&#10001; New question &#10002;</button> </tr>
  <tr>
    <th class="w3-dark-grey">&nbsp;</th>
    <th colspan="4" class="w3-dark-grey" id="question_count">Total number of question(s): {{len(questions)}}</th>
  </tr>
  <tr><td colspan="5"><hr></td></tr>
  <tr>
    <th class="w3-dark-grey">&nbsp;</th>
    <th class="w3-dark-grey">Question</th>
    <th class="w3-dark-grey" colspan="3">Action</th>
  </tr>
  <tr><td colspan="5"><hr></td></tr>
% for qstn in questions:
  <tr class="question_rows" id ="q_{{qstn["id"]}}">
    <td>&nbsp;</td>
    <td>
		<div class="table_cell_div">
		<h2>Question {{qstn["id"]}}:</h2><hr>
		  %if type(qstn["question"]) is list:
			%for q in qstn["question"]:
				{{!q}}</br>
			%end ##for q in qstn["question"]
		  % else:
			{{!qstn["question"]}}
		  %end ## if type(qstn["question"]) is list:
		<br><h3>Answer(s):</h3><hr>
		  %if len(qstn["answers"]) == 0:
				<input type="text" size="80" value="{{qstn["correctAnswer"]}}" readonly>
		  %else:
				%if type(qstn["question"]) is list:
					<p><u>Correct answers:</u></p>
					%for answer in qstn["correctAnswer"]:
					<label> {{answer}}</label><br>
					%end ## for answer in qstn["correctAnswer"]:
					<p><u>Possible answers:</u></p>
					%for answer in qstn["answers"]:
					<label> {{answer}}</label><br>
					%end ## for answer in qstn["answers"]:
				%else:
					%if len(qstn["correctAnswer"]) != 1:
						%j = 0
						%for i in range(len(qstn["answers"])):
						  %if str(i) == qstn["correctAnswer"][j]:
							 <input type="checkbox" checked disabled>
							 <label> {{qstn["answers"][str(i)]}}</label><br>
							 %j = j + 1
							 %if j >= len(qstn["correctAnswer"]):
							 %j = j - 1
							 %end ##if j >= len(qstn["correctAnswer"]):
						  %elif chr(65+i) == qstn["correctAnswer"][j]:
							 <input type="checkbox" checked disabled>
							 <label> {{qstn["answers"][chr(65+i)]}}</label><br>
							 %j = j + 1
							 %if j >= len(qstn["correctAnswer"]):
							 %j = j - 1
							 %end ##if j >= len(qstn["correctAnswer"]):
						  %else:
							 <input type="checkbox" disabled>
							 %try:
							 <label> {{qstn["answers"][str(i)]}}</label><br>
							 %except:
							 <label> {{qstn["answers"][chr(65+i)]}}</label><br>
							 %end #%try:
						  %end ##%if str(i) == qstn["correctAnswer"]:
						%end ##%for i in range(len(answers)):
					%else:
						%for i in range(len(qstn["answers"])):
						  %if str(i) == qstn["correctAnswer"]:
							 <input type="radio" checked disabled>
							 <label> {{qstn["answers"][str(i)]}}</label><br>
						  %elif chr(65+i) == qstn["correctAnswer"]:
							 <input type="radio" checked disabled>
							 <label> {{qstn["answers"][chr(65+i)]}}</label><br>
						  %else:
							 <input type="radio" disabled>
							 %try:
							 <label> {{qstn["answers"][str(i)]}}</label><br>
							 %except:
							 <label> {{qstn["answers"][chr(65+i)]}}</label><br>
							 %end #%try:
						  %end ##%if str(i) == qstn["correctAnswer"]:
						%end ##%for i in range(len(answers)):
					%end ##if len(qstn["correctAnswer"]) != 1:
				%end ##if type(qstn["question"]) is list:
		  %end ##if len(qstn["answers"]) == 0:
		  <br><br><h3>Explanation:</h3><hr>
		  <div>{{!qstn["explanation"]}}</div>
		  <br><h3>Extenls URL:</h3><hr>
		  <input type="text" size="80" value="{{qstn["referenceLink"]}}" readonly>
		</div>
	</td>
    <td><div class="float"><button style="width:100%" onclick="confirmEdit({{qstn["id"]}})">&#9998; Edit</button></div> </td>
    <td><div class="float"><button style="width:100%" onclick="confirmDelete({{qstn["id"]}})">&#128465; Delete</button></div> </td>
    <td>&nbsp;</td>
  </tr>
  <tr>
  <td colspan="5"><hr>
  </td>
  </tr>
% end ##% for qstn in questions:
</table>
%if len(questions) > 3:
  <tr><button class="newQuestion_btn" style="width:100%" onclick="confirmEdit(-1)">&#10001; New question &#10002;</button> </tr>
% end ##% if len(questions) > 3:
</div>
<button id="scrollToTopDesktop" class="scroll-to-top" onclick="goToTop()" title="Go to top"><i>Top</i></button>
<script>
	let collection = document.getElementsByClassName("newQuestion_btn");
	if(collection.length != 2){
		let body = document.body,
			html = document.documentElement;

		let height = Math.max( body.scrollHeight, body.offsetHeight, 
							   html.clientHeight, html.scrollHeight, html.offsetHeight );
		let window_height = window.innerHeight;
		if(height > window_height * 2){
		    let pretyPrint = document.getElementsByClassName("pretyPrint");
			pretyPrint = pretyPrint[0];
			let btn = document.createElement("button");
			btn.innerHTML = "&#10001; New question &#10002;";
			btn.setAttribute('class', "newQuestion_btn");
			btn.setAttribute('style', "width:100%");
			btn.setAttribute('onclick', "confirmEdit(-1)");
			pretyPrint.after(btn);
		}
	}
	collection = null;

	var hidden = true;
	document.addEventListener("scroll", (event) => {
		window.requestAnimationFrame(() => {
		  if(window.scrollY < 120){
			document.getElementById("scrollToTopDesktop").style = "display: none;";
			hidden = true;
		  }else{
			if(hidden){
				hidden = false;
				document.getElementById("scrollToTopDesktop").style = "display: block;";
			}
		  }
		});
	});
	
	document.onkeydown = function(evt) {
		if(event.ctrlKey && event.altKey && evt.key === "g"){
			var selection = parseInt(prompt("Jump to question:", "Type a number!"), 10);
			if (isNaN(selection)){
			  alert('Type a number');
			} else {
				const a = document.createElement("a");
				a.href = "#q_"+ selection;
				document.body.appendChild(a);
				a.click();
				document.body.removeChild(a);
			}
		}
	};

	document.dispatchEvent(new Event('scroll'));
</script>
	</body>
</html>
% include('footer.tpl')
