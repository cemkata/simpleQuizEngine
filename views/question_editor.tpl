<html>
  <head>
    <title>Edit question</title>
    <link rel="stylesheet" href="/static/editor.css">
  </head>
  <body>
    <br />


<div>
  <div class="column left">
%# if defined('questionID'):
    <input type="hidden" id="questionID" value="{{questionID}}">
%# end
    <input type="hidden" id="courseID" value="{{courseID}}">
    <input type="hidden" id="quizID" value="{{quizID}}">
    <p>Question </p>
	  %if type(questionContent['question']) is list:
	    %ansrStr = ""
	    %for q in questionContent['question']:
		    %ansrStr += q+'''</br>'''
		%end
		<textarea id="area_question" class = "area">{{ansrStr}}</textarea>
	  % else:
        <textarea id="area_question" class = "area">{{questionContent['question']}}</textarea>
	  %end
     <p>Answer(s)</p>
	<div class="w3-panel w3-red w3-display-container" id="error_no_answer">
		<span onclick="this.parentElement.style.display='none'" class="w3-button w3-large w3-display-topright">&times;</span>
		<h3>!</h3>
		<p>No answer given.</p>
	</div>
    <div id="answers_area">
  % if len(questionContent['answers']) == 0:
      <input type="text" id="freeTextAns" style = "width: 100%;" value="{{questionContent['correctAnswer']}}">
      % selcDropDown = ['selected', '', '', '']
  % else:
      % if type(questionContent['question']) is list:
	  % selcDropDown = ['', '', '', 'selected']
	  % # TODO add the drag-drop functions
		   <div id="select_answers">
		   <p>Selectable answers</p>
			%for answer in questionContent['answers']:
			<div class="showinline"><input type="text" class="textAns" style="width: 100%;" value="{{answer}}"></div><br>
			%end
		   </div>
		   <div id="correct_answers">
		   <p>Correct answers</p>
			%for answer in questionContent['correctAnswer']:
			<div class="showinline"><input type="text" class="textAns" style="width: 100%;" value="{{answer}}"></div><br>
			%end
		   </div>
	  % else:
		  % if len(questionContent['correctAnswer']) == 1:
		  % type = "radio"
		  % selcDropDown = ['', 'selected', '', '']
		  % else:
		  % type = "checkbox"
		  % selcDropDown = ['', '', 'selected', '']
		  % end
			  % for key in questionContent['answers'].keys():
			  <div class="showinline">
				% if key in questionContent['correctAnswer']:
				<span><input type="{{type}}" name="chBoxGrup" checked/>
				% else:
				<span><input type="{{type}}" name="chBoxGrup"/>
				% end
				</span><input type="text" class="textAns" style = "width: 100%;" name="answer" value="{{questionContent['answers'][key]}}">
			  </div><br>
			  % end
	  % end
  % end
  </div>
  <p>Explanation</p>
      <textarea id="area_explanation" class = "area">{{questionContent['explanation']}}</textarea>
	</p>
  <p>Refrence link</p>
  <div class="showinline">
          <input type="text" id="referenceLink" style = "width: 100%;" value="{{questionContent['referenceLink']}}">
  </div>
  <br>
<div><button class="btn btn-primary" onclick="saveQuestion()">Save</button> <button class="btn btn-secondary" onclick="clearPage()">Clear</button></div>
</div> <div class="column right">
    <p><b>Question settings:</b></p>
    <table id = "questionOptions">
    <tr>
      <td><span>Answert type:</span></td >
      <td><select id="questionType" onchange="changeAnswerType(this)">
        <option value="0" {{selcDropDown[0]}}>Free text</option>
        <option value="1" {{selcDropDown[1]}}>Single choice</option>
        <option value="2" {{selcDropDown[2]}}>Multiple choice</option>
        <option value="3" {{selcDropDown[3]}}>Drag-n-drop</option>
        </select></td>
    </tr>
    <tr>
      <td><span>Number of choices:</span></td><td><input type="number" onchange="changeAnswerCount()" id="noQuestion" min="2" value="{{len(questionContent['answers'])}}"></td>
    </tr>
    </table>
    <p><b>Help:</b></p>
     <table id = "help">
	  <tr>
        <td>You can save using the icon of the formaing</td>
      </tr>
	  <tr>
        <td> area or the button at the bottom</td>
      </tr>
	  <tr>
        <td></td>
      </tr>
	  <tr>
        <td><b>Applys only to Single/Multiple choice<b></td>
      </tr>
	  <tr>
        <td>Supports manual html in following format
	  <tr>
        <td>&lt;tag&gt;Some text&lt;/tag&gt;</td>
      </tr>
	  <tr>
        <td>Supported formats:</td>
      </tr>
	  <tr>
        <td><ul>
 <li><code class="w3-codespan">&lt;b&gt;</code> <b>- Bold text</b></li>
 <li><code class="w3-codespan">&lt;strong&gt;</code> <strong>- Important text</strong></li>
 <li><code class="w3-codespan">&lt;i&gt;</code> <i>- Italic text</i></li>
 <li><code class="w3-codespan">&lt;em&gt;</code> <em>- Emphasized text</em></li>
 <li><code class="w3-codespan">&lt;mark&gt;</code> <mark>- Marked text</mark></li>
 <li><code class="w3-codespan">&lt;small&gt;</code> <small>- Smaller text</small></li>
 <li><code class="w3-codespan">&lt;del&gt;</code> <del>- Deleted text</del></li>
 <li><code class="w3-codespan">&lt;ins&gt;</code> <ins>- Inserted text</ins></li>
 <li><code class="w3-codespan">&lt;sub&gt;</code> <sub>- Subscript text</sub></li>
 <li><code class="w3-codespan">&lt;sup&gt;</code> <sup>- Superscript text</sup></li>
 <li><code class="w3-codespan">&lt;br&gt;</code> - Will insert new line</li>
</ul></td>
      </tr>
	  <tr>
        <td></td>
      </tr>
      <tr>
        <td><b>Applys only to drag and drop<b></td>
	  </tr>
	  <tr>
        <td>The questions and the answers are in order</td>
	  </tr>
	  <tr>
        <td>You can have more posible answers than answers</td>
	  </tr>
	  <tr>
        <td><u>!!The questions must end with</u> $?__</td>
      </tr>
     </table>
  </div>
</div>
    <script src='/static/nicEdit.js' type='text/javascript'></script>
    <script src='/static/nicEditorMyExtension.js' type="text/javascript"></script>
    <script src="/static/nicEditorRightColumn.js" type="text/javascript"></script>
    <script type="text/javascript">
      bkLib.onDomLoaded(function() {
          new nicEditor({fullPanel : true, /*uploadImgURI : '/be/nicUploadImg',*/ 
          onSave : saveQuestion,
          iconsPath : '/static/nic/new_nicEditorIcons.png',
          tableURL : '/be/nicShowFiles'}).panelInstance('area_question');

          new nicEditor({fullPanel : true, /*uploadImgURI : '/be/nicUploadImg',*/ 
          onSave : saveQuestion,
          iconsPath : '/static/nic/new_nicEditorIcons.png',
          tableURL : '/be/nicShowFiles'}).panelInstance('area_explanation');
          nicEdit_Scroll_Patch();
      });

      function saveQuestion(content, id, instance) {
         var questionID = document.getElementById("questionID").value;
         var courseID = document.getElementById("courseID").value;
         var quizID = document.getElementById("quizID").value;
		 
		 let tmpHolder = document.getElementsByClassName(' nicEdit-main ');

         //var questionTxt = document.getElementById("area_question").value; //do not use the area, but the div and the inner text
         var questionTxt = tmpHolder[0].innerHTML; 
         //var explnTxt = document.getElementById("area_explanation").value; //do not use the area, but the div and the inner text
         var explnTxt = tmpHolder[1].innerHTML;
         var referenceLink = document.getElementById("referenceLink").value;
		 
		if(document.getElementById("select_answers") != null){ //Drag-drop answers
			selc_ans = document.getElementById("select_answers");
			posb_ans = document.getElementById("correct_answers");
			var answers_html = selc_ans.getElementsByClassName("showinline");
			answers = [];
			for(let i = 0; i < answers_html.length; i++){
			    answers.push(answers_html[i].firstChild.value)
			}
			var answers_html = posb_ans.getElementsByClassName("showinline");
			correctAnswer = [];
			for(let i = 0; i < answers_html.length; i++){
			    correctAnswer.push(answers_html[i].firstChild.value)
			}
			correctAnswer = JSON.stringify(correctAnswer)
			//TODO
		}else{ //free text
			 var freetext = document.getElementById("freeTextAns");
			 if(freetext == null){
			   //Not free text question
			   var answers_html = document.getElementsByClassName("showinline");
			   var correctAnswer = ""
			   var answers = {};
			   // -1 becasue the reference link adds one more line
			   for(let i = 0; i < answers_html.length - 1; i++){
				 var tmp_ans = answers_html[i].getElementsByTagName("input");
				 if(tmp_ans[0].checked){
				   correctAnswer+=i;
				 }
				 answers[i] = tmp_ans[1].value
			   }
			 }else{
			   var answers = {};
			   var correctAnswer = document.getElementById("freeTextAns").value;
			 }
		 }

         var fd = new FormData(); // https://hacks.mozilla.org/2011/01/how-to-develop-a-html5-image-uploader/
         fd.append("courseID", courseID);
         fd.append("quizID", quizID);
         fd.append("questionID", questionID);
         fd.append("questionTxt",  questionTxt);
         fd.append("explnTxt", explnTxt);
         fd.append("referenceLink", referenceLink);
         fd.append("answers", JSON.stringify(answers));
         fd.append("correctAnswer", correctAnswer);
         if(correctAnswer.length <= 0){ //add validation
           alert("Please fill the correct answer!")
           errorDiv = document.getElementById("error_no_answer");
           errorDiv.style.setProperty('display','block','')
           return;
         }
			 
         var xhr = new XMLHttpRequest();
         xhr.open("POST", "./saveQuestion");

         xhr.onload = function() {
                 alert("Status: " + xhr.responseText);
                 if(xhr.status == 200){
                   titletextLength = document.getElementById("area_question").value.length
                   descriptiontextLength = document.getElementById("area_explanation").value.length
                 }
                 errorDiv = document.getElementById("error_no_answer");
                 errorDiv.style.display='none'
         };
         xhr.onerror = xhr.onload;
         //xhr.setRequestHeader('Authorization', 'Client-ID c37fc05199a05b7');
         xhr.send(fd);
      }      
	  
	  function clearPage(){
        var options = document.getElementById("questionType").options;
        options[0].selected = true;
        let tmpHolder = document.getElementsByClassName(' nicEdit-main ');
        //var questionTxt = document.getElementById("area_question").value; //do not use the area, but the div and the inner text
        tmpHolder[0].innerHTML = ""; 
        //var explnTxt = document.getElementById("area_explanation").value; //do not use the area, but the div and the inner text
        tmpHolder[1].innerHTML = ""; 
        var ansArea = document.getElementById("answers_area");
        newHtml = `<input type="text" id="freeTextAns" style = "width: 100%;" value="">`;
        ansArea.innerHTML = newHtml;
        document.getElementById("noQuestion").value = 0;
        document.getElementById("referenceLink").value = ""
        errorDiv = document.getElementById("error_no_answer");
        errorDiv.style.display='none'
	  }
	  
	  function nicEdit_Scroll_Patch(){
		let tmpHolder = document.getElementsByClassName(' nicEdit-main ')
		var body = document.body,
			html = document.documentElement;
		var width = tmpHolder[0].clientWidth;

		var height = Math.max( body.scrollHeight, body.offsetHeight, 
							   html.clientHeight, html.scrollHeight, html.offsetHeight ) / 4;
		for (let i = 0; i < tmpHolder.length; i++){
			tmpHolder[i].style.setProperty('max-height',height,'');
			tmpHolder[i].style.setProperty('overflow-y','scroll','');
			//tmpHolder[i].style.setProperty('max-width',width,'');
			//tmpHolder[i].style.setProperty('overflow-x','scroll','');
		}
	  }
	  
	  document.addEventListener('keydown', e => {
	    if (e.ctrlKey && e.key === 's') {
	      // Prevent the Save dialog to open
	      e.preventDefault();
	      // Place your code here
	      //console.log('CTRL + S');
		  saveQuestion();
	    }
	  });
    </script>
  </body>
</html>
