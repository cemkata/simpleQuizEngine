<html lang="en" class="">
	<head>
	  <meta charset="UTF-8">
	  <title>Editing Dump {{cid + " " + dump}}</title>
	  <meta name="robots" content="noindex">
	  <link rel='stylesheet' href='/static/style.css'>
	<script>
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
		if (confirm('Are you sure you want to delete this question?')) {
		  var cource = document.getElementById("courseID").value;
		  var quiz = document.getElementById("quizID").value;
		  url = '/editor/deleteQuestion?courseID=' + cource + "&quizID=" + quiz + "&questionID=" + qid;
		
		  const xhr = new XMLHttpRequest();
		  xhr.open("GET", url);
		  xhr.send();
		  xhr.onload = () => {
		    if (xhr.readyState == 4 && xhr.status == 200) {
		  	    alert(xhr.response);
				location.reload();
		    } else {
		  	    alert(`Error: ${xhr.status}`);
		    }
		  };
		  //window.location.href = url
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
  <tr><button style="width:100%" onclick="confirmEdit(-1)">New question</button> </tr>
  <tr>
    <th class="w3-dark-grey">Total number of question(s): {{len(questions)}}</th>
  </tr>
  <tr><td colspan="3"><hr></td></tr>
  <tr>
    <th class="w3-dark-grey">Question</th>
    <th class="w3-dark-grey" colspan="2">Action</th>
  </tr>
  <tr><td colspan="3"><hr></td></tr>
% for qstn in questions:
  <tr class="question_rows">
    <td>
	<br><h2>Question {{qstn["id"]}}:</h2><hr>
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
					  %else:
						 <input type="checkbox" disabled>
						 <label> {{qstn["answers"][str(i)]}}</label><br>
					  %end ##%if str(i) == qstn["correctAnswer"]:
					%end ##%for i in range(len(answers)):
				%else:
					%for i in range(len(qstn["answers"])):
					  %if str(i) == qstn["correctAnswer"]:
						 <input type="radio" checked disabled>
						 <label> {{qstn["answers"][str(i)]}}</label><br>
					  %else:
						 <input type="radio" disabled>
						 <label> {{qstn["answers"][str(i)]}}</label><br>
					  %end ##%if str(i) == qstn["correctAnswer"]:
					%end ##%for i in range(len(answers)):
				%end ##if len(qstn["correctAnswer"]) != 1:
			%end ##if type(qstn["question"]) is list:
	  %end ##if len(qstn["answers"]) == 0:
	  <br><br><h3>Explanation:</h3><hr>
	  <div style="width: 75%;">{{!qstn["explanation"]}}</div>
	  <br><h3>Extenls URL:</h3><hr>
	  <input type="text" size="80" value="{{qstn["referenceLink"]}}" readonly>
	  <br><br>
    </td>
    <td><button style="width:100%" onclick="confirmEdit({{qstn["id"]}})">Edit</button> </td>
    <td><button style="width:100%" onclick="confirmDelete({{qstn["id"]}})">Delete</button> </td>
  </tr>
  <tr>
  <td colspan="3"><hr>
  </td>
  </tr>
% end ##% for qstn in questions:
</table>
%if len(questions) > 3:
  <tr><button style="width:100%" onclick="confirmEdit(-1)">New question</button> </tr>
% end ##% if len(questions) > 3:
</div>
<button id="scrollToTopDesktop" class="scroll-to-top" onclick="goToTop()" title="Go to top" style="display: block;"><i>Top</i></button>
	</body>
</html>
% include('footer.tpl')