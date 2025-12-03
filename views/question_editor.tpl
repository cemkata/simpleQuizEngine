<!DOCTYPE html>
<html>
  <head>
%if questionID != -1:
    <title>Edit question - {{questionID}} from {{quizID}}</title>
%else:
    <title>Adding new question in {{quizID}}</title>
%end
    <link rel="stylesheet" href="/static/editor.css">
	<meta charset="UTF-8">
  </head>
  <body>
    <br />


<div>
  <div class="column left">
    <input type="hidden" id="questionID" value="{{questionID}}">
    <input type="hidden" id="courseID" value="{{courseID}}">
    <input type="hidden" id="quizID" value="{{quizID}}">
<% 
selectionDropDownMenu = [{'value':0, 'text':"Free text", 'selected':""},
                 {'value':1, 'text':"Single choice", 'selected':""},
                 {'value':2, 'text':"Multiple choice", 'selected':""},
                 {'value':3, 'text':"Drag-n-drop", 'selected':""},
                 {'value':4, 'text':"Dropdown selection", 'selected':""}
]
%>
	
%if questionID != -1:
    <p>Edit question <i>{{questionID}}</i> from quiz <b>{{quizID}}</b> in course <u>{{courseID}}</u></p>
%else:
    <p>Adding new question in <b>{{quizID}}</b> in course <u>{{courseID}}</u></p>
%end
    <p>Question </p>
	<div class="editor_holder">
	  % if questionContent['category'] == 3: #Drag-drop
	    %ansrStr = ''.join("<div>%s</div>" % "".join(s) for s in questionContent['question'])
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
  % if questionContent['category'] == 0:
      % selectionDropDownMenu[0]['selected'] = 'selected'
      <input type="text" id="freeTextAns" style = "width: 100%;" value="{{questionContent['correctAnswer']}}">
  % elif questionContent['category'] == 3: #Drag-drop
      % selectionDropDownMenu[3]['selected'] = 'selected'
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
		  <%
		    if questionContent['category'] == 1:
		       selectionDropDownMenu[1]['selected'] = 'selected'
		       type = "radio"
		    elif questionContent['category'] == 2:
		       selectionDropDownMenu[2]['selected'] = 'selected'
		       type = "checkbox"
			end
		    %>
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
  % elif questionContent['category'] == 4:
      % selectionDropDownMenu[4]['selected'] = 'selected'
		   <div id="correct_answers">
		   <p>Correct answers</p>
			%for answer in questionContent['correctAnswer']:
			<div class="showinline"><input type="text" class="textAns" style="width: 100%;" value="{{answer}}"></div><br>
			%end
		   </div>
  % else:
  % #Here add new type of questions
			  <div class="showinline">
				Select type of question
			  </div><br>
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
	  <%
	  if questionID == -1:
	     selectionDropDownMenu.insert(0, {'value':-1, 'text':"Please select", 'selected':""})
	  end
	  %>
      <td><span>Answert type:</span></td >
      <td><select id="questionType" onchange="changeAnswerType(this)">
	    % for opt in selectionDropDownMenu:
            <option value="{{opt['value']}}" {{opt['selected']}}>{{opt['text']}}</option>
		% end
        </select></td>
    </tr>
    <tr>
      <td><span>Number of choices:</span></td><td><input type="number" onchange="changeAnswerCount()" id="noQuestion" min="1" value="{{len(questionContent['answers'])}}"></td>
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
        <td><b>Keyboard shortcuts:<b></td>
	  </tr>
	  <tr>
        <td><em>Ctrl+s</em> = Save question</td>
      </tr>
	  <tr>
        <td><em>Ctrl+q</em> = Clear question</td>
      </tr>
	  <tr>
        <td><em>Ctrl+shift+v</em> = paste as text (built-in in most browsers)</td>
      </tr>
	  <tr>
        <td></td>
      </tr>
	  <tr class = "selectable_answ">
        <td><b>Applys only to Single/Multiple choice<b></td>
      </tr>
	  <tr class = "selectable_answ">
        <td>Supports manual html in following format</td>
	  </tr>
	  <tr class = "selectable_answ">
        <td>&lt;tag&gt;Some text&lt;/tag&gt;</td>
      </tr>
	  <tr class = "selectable_answ">
        <td>To use this formatoing the answer needs to start with ¶</td>
	  </tr>
	  <tr class = "selectable_answ">
        <td>Supported formats:</td>
      </tr>
	  <tr class = "selectable_answ">
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
 <li><code class="w3-codespan">class="s4"</code> - Mark the text as code:</br><code class="w3-codespan">&lt;span class="s4"&gt;text&lt;/span&gt;</code></li>
</ul></td>
      </tr>
	  <tr class = "selectable_answ">
        <td></td>
      </tr>
      <tr class = "dragNdrop_answ">
        <td><b>Applys only to drag and drop<b></td>
	  </tr>
	  <tr class = "dragNdrop_answ">
        <td>If the order of answers should be grouped set same number</td>
      </tr>
	  <tr class = "dragNdrop_answ">
        <td>Otherwise</td>
      </tr>
	  <tr class = "dragNdrop_answ">
        <td>The questions and the answers are in order</td>
	  </tr>
	  <tr class = "dragNdrop_answ">
        <td>You can have more posible answers than answers</td>
	  </tr>
	  <tr class = "dragNdrop_answ">
        <td><u>!!The drag target is specified with</u> ↨</td>
      </tr>
	  <tr class = "dragNdrop_answ">
        <td>Put  at least one empty space bofore <em>↨</em></td>
      </tr>
	  <tr class = "dragNdrop_answ">
        <td>Or else you will get unexpected results.</td>
      </tr>
      <tr class = "freetext_answ">
        <td><b>Applys only to free text<b></td>
	  </tr>
	  <tr class = "freetext_answ">
        <td>If you want multiple line answer use 🠇 to mark end of</td>
      </tr>
	  <tr class = "freetext_answ">
        <td>answer (divider)</em></td>
      </tr>
      <tr class = "dropdown_answ">
        <td><b>Applys only drop down selection<b></td>
	  </tr>
	  <tr class = "dropdown_answ">
        <td>To insert drop down selection:</td>
      </tr>
	  <tr class = "dropdown_answ">
        <td>Encase the answers in &#8261; &#8262;</td>
      </tr>
	  <tr class = "dropdown_answ">
        <td>Use &#10081; as delimator. Smaple:</td>
      </tr>
	  <tr class = "dropdown_answ">
        <td>&#8261;a&#10081;b&#10081;c&#8262;</td>
      </tr>
	  <tr class = "dropdown_answ">
        <td><u>Mind the spaces when entering answer (not needed)</u> </td>
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
	  
	  show_help(document.getElementById("questionType").value);
    </script>
  </body>
</html>
% include('footer.tpl')
