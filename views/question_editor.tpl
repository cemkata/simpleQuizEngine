<html>
  <head>
%if questionID != -1:
    <title>Edit question - {{questionID}} from {{quizID}}</title>
%else:
    <title>Adding new question in {{quizID}}</title>
%end
    <link rel="stylesheet" href="/static/editor.css">
  </head>
  <body>
    <br />


<div>
  <div class="column left">
    <input type="hidden" id="questionID" value="{{questionID}}">
    <input type="hidden" id="courseID" value="{{courseID}}">
    <input type="hidden" id="quizID" value="{{quizID}}">
    
%if questionID != -1:
    <p>Edit question <i>{{questionID}}</i> from quiz <b>{{quizID}}</b> in course <u>{{courseID}}</u></p>
%else:
    <p>Adding new question in <b>{{quizID}}</b> in course <u>{{courseID}}</u></p>
%end
    <p>Question </p>
	<div class="editor_holder">
	  %if type(questionContent['question']) is list:
	    %ansrStr = ""
	    %for q in questionContent['question']:
		    %ansrStr += '''<div>'''+ q +'''</div>'''
		%end
		<textarea id="area_question" class = "area">{{ansrStr}}</textarea>
	  % else:
        <textarea id="area_question" class = "area">{{questionContent['question']}}</textarea>
	  %end
	</div>
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
		   <div id="select_answers">
		   <p>Selectable answers</p>
			%for idx, answer in enumerate(questionContent['answers']):
				% try:
			<div class="showinline"><input type="text" class="textAns" style="width: 100%;" value="{{answer}}">Count:<input type="number" value="{{questionContent['answersCount'][idx]}}" min="1" max="99"></div><br>
				% except:
			<div class="showinline"><input type="text" class="textAns" style="width: 100%;" value="{{answer}}">Count:<input type="number" value="1" min="1" max="99"></div><br>
				%end
			%end
			
		   </div>
		   <div id="correct_answers">
		   <p>Correct answers</p>
			%for idx, answer in enumerate(questionContent['correctAnswer']):
				% try:
			<div class="showinline"><input type="text" class="textAns" style="width: 100%;" value="{{answer}}">Group:<input type="number" value="{{questionContent['answersGroups'][idx]}}" min="0" max="99"></div><br>
				% except:
			<div class="showinline"><input type="text" class="textAns" style="width: 100%;" value="{{answer}}">Group:<input type="number" value="{{idx}}" min="0" max="99"></div><br>
				%end
			
			%end
		   </div>
	  % elif questionContent['category'] == 1 or questionContent['category'] == 2:
		  % if len(questionContent['correctAnswer']) == 1:
		    % type = "radio"
		    % selcDropDown = ['', 'selected', '', '']
		  % elif questionContent['category'] == 2:
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
	  % else:
	     % selcDropDown = ['', '', '', '']
			  <div class="showinline">
				New type of question
			  </div><br>
	  % end
  % end
  </div>
  <p>Explanation</p>
  <div class="editor_holder">
      <textarea id="area_explanation" class = "area">{{questionContent['explanation']}}</textarea>
	</p>
  </div>
  <p>Refrence link</p>
  <div class="showinline">
          <input type="text" id="referenceLink" style = "width: 100%;" value="{{questionContent['referenceLink']}}">
  </div>
  <br>
<div id="buttonHolder"><button class="btn btn-primary" onclick="saveQuestion()">Save</button> <button class="btn btn-secondary" onclick="clearPage()">Clear</button></div>
</div> 
<div class="column right">
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
        <td>Supports manual html in following format</td>
	  <tr>
        <td>&lt;tag&gt;Some text&lt;/tag&gt;</td>
      </tr>
	  <tr>
        <td>To use this formatoing the answer needs to start with ¶</td>
	  <tr>
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
        <td>If the order of answers should be grouped set same number</td>
      </tr>
	  <tr>
        <td>Otherwise</td>
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
	  <tr>
        <td>Put  at least one empty space bofore <em>$?__</em></td>
      </tr>
	  <tr>
        <td>Or else you will get unexpected results.</td>
      </tr>
     </table>
  </div>
</div>
    <script src='/static/nicEdit.js' type='text/javascript'></script>
    <script src='/static/nicEditorMyExtension.js' type="text/javascript"></script>
    <script src="/static/nicEditorRightColumn.js" type="text/javascript"></script>
    <script type="text/javascript">
      bkLib.onDomLoaded(function() {
		initEditors()
      });
	
	  document.addEventListener('keydown', e => {
	    if (e.ctrlKey && (e.key === 's' || e.key === 'S')) {
	      // Prevent the Save dialog to open
	      e.preventDefault();
	      // Place your code here
	      //console.log('CTRL + S');
		  saveQuestion();
	    }else if (e.ctrlKey && (e.key === 'q' || e.key === 'Q')) {
	      // Prevent the Save dialog to open
	      e.preventDefault();
	      // Place your code here
	      //console.log('CTRL + Q');
		  clearPage();
	    }
	  });
	
	  window.addEventListener('resize', e => {
        let tmpHolder = document.getElementsByClassName(' nicEdit-main ');
        let value_0 = tmpHolder[0].innerHTML;
        let value_1 = tmpHolder[1].innerHTML;
		
		let newtmpHolder = document.getElementsByClassName('editor_holder');
		
        newtmpHolder[0].innerHTML = `<textarea id="area_question" class = "area"></textarea>`;
        newtmpHolder[1].innerHTML = `<textarea id="area_explanation" class = "area"></textarea>`;
		initEditors();
        tmpHolder = document.getElementsByClassName(' nicEdit-main ');
		tmpHolder[0].innerHTML = value_0;
		tmpHolder[1].innerHTML = value_1;
	  }, true);
    </script>
  </body>
</html>
% include('footer.tpl')