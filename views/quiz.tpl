<html lang="en" class="">
	<head>
      <meta charset="UTF-8">
      <title>Exam - {{tittle}}</title> 
<style>
/*@import url(https://fonts.googleapis.com/css?family=Work+Sans:300,600);*/
html {
    font-size: calc(15px + 0.390625vw);
}

body{
	font-size: 20px;
	font-family: 'Work Sans', sans-serif;
	color: #333;
  font-weight: 300;
  text-align: left;
  background-color: #f8f6f0;
    margin:0;
    font-family:-apple-system, BlinkMacSystemFont, “Segoe UI”, Roboto, Helvetica, Arial, sans-serif;
    line-height:1.5;
}
h1{
  font-weight: 300;
  margin: 0px;
  padding: 10px;
  font-size: 20px;
  background-color: #444;
  color: #fff;
}

#config{
  /*display: none;*/
  font-family: 'Work Sans', sans-serif;
	font-size: 22px;
}

.quzControl{
  display: none;	
}

.question{
  margin-bottom: 20px;
}

.exponention{
  font-size: 25px;
  margin-bottom: 10px;
}
#homeLink{color: #ddd;}

 .s4 { color: black; font-family:"Courier New", monospace; font-style: normal; font-weight: normal; text-decoration: none; /*font-size: 10pt;*/ }
.answers {
  margin-bottom: 20px;
  text-align: left;
  display: inline-block;
}
.answers label{
  display: block;
  margin-bottom: 10px;
}
.answers pre{
  margin: 0px;
}
button{
  font-family: 'Work Sans', sans-serif;
	font-size: 22px;
	background-color: #279;
	color: #fff;
	border: 0px;
	border-radius: 3px;
	padding: 20px;
	cursor: pointer;
	margin-bottom: 20px;
}
button:hover{
	background-color: #38a;
}

.hidden{
	display:none;
}

.slide{
  position: absolute;
  left: 0px;
  top: 0px;
  width: 100%;
  z-index: 1;
  opacity: 0;
  transition: opacity 0.5s;
}
.active-slide{
  opacity: 1;
  z-index: 2;
}

.quiz-container{
  position: relative;
  /*height: 700px;
  width: 600px;
  height: 75%;
  height: 50%;
  width: 60%;
  margin-top: 30px;*/
  margin-bottom: 30px;
  /*margin-left: 10px;
  margin-right: 10px;*/
  overflow-y: auto;
}

.pages{
  position: relative;
  height: 450px;
  margin-top: 30px;
  margin-bottom: 30px;
}

.question_rows{
  border: 10px solid black;
  background-color:#f2f2f2 ;
}

.pretyPrint{
 img{	
	object-fit: scale-down;
	max-width: 100%;
	height: auto;
 }
  tr>th:first-child,tr>td:first-child {
    word-break: break-all;
  }
}
input[type=text], input[type=number], select, textarea {
  width: 100%;
  padding: 12px 20px;
  margin: 8px 0;
  display: inline-block;
  border: 1px solid #ccc;
  border-radius: 4px;
  box-sizing: border-box;
}

input[type=submit], input[type=button] {
  width: 100%;
  background-color: #4CAF50;
  /* font-size: 1.1em;
  font-size: 0.75vw; */
  color: white;
  padding: 14px 20px;
  margin: 8px 0;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

#backButton {
  background-color: darkblue;
}

input[type=submit]:hover {
  background-color: #45a049;
}

.answers_container{
    display: inline-block;
    padding: 15px;
    margin: 10px;
    border: 1px solid black;
    border-radius: 5px;
    box-sizing: border-box;
}

.dragtarget {
    background-color: #222;
    padding: 5px;
    border-radius: 5px;
    color: #fff;
    font-weight: bold;
    text-align: center;
}

.droptarget {
    display: inline-block;
    min-width: 50px;
    height: 25px;
    border: 1px solid #aaaaaa;
    color: #000;
    text-align: center;
}

.question_box {
    display: inline-block;
    /*padding: 15px;
    margin: 10px;*/
}

.scroll-to-top {
    display: none;
    position: fixed;
    bottom: 17px;
    right: 25px;
    z-index: 9999;
    font-size: 21px;
    border: none;
    outline: 0;
    background: rgba(170, 170, 170, .75);
    color: #fff;
    cursor: pointer;
    border-radius: 50%;
    vertical-align: middle;
    width: 56px;
    height: 56px;
    padding: 0;
    box-shadow: var(--scrollToTopShadow);
}

#pages{
	display:inline-block;
	color:#000000;
	/*position:absolute;*/
	left:65%;
	top:20%;
	font-size:25px;
}

#showTimer{
	display:inline-block;
	color:#000000;
	/*position:absolute;*/
	left:65%;
	top:30%;
	font-size:25px;	
}

#container{
    min-height: 83vh;
    max-height: 83vh;
}

/* grid container */
.right-sidebar-grid {
    display:grid;
    grid-template-areas:
        'header'
        'right-sidebar'
        'main-content'
        'footer';
}

/* general column padding */
.right-sidebar-grid > * {
    padding:1rem;
}

/* assign columns to grid areas */
.right-sidebar-grid > .header {
    grid-area:header;
	padding: 0.0rem;
    /*background:#f97171;*/
}
.right-sidebar-grid > .main-content {
    grid-area:main-content;
    /*background:#fff;*/
}
.right-sidebar-grid > .right-sidebar {
    grid-area:right-sidebar;
    /*background:#f5d55f;*/
}
.right-sidebar-grid > .footer {
    grid-area:footer;
    /*background:#72c2f1;*/
}

/* tablet breakpoint */
@media (min-width:768px) {
    .right-sidebar-grid {
        grid-template-columns:repeat(3, 1fr);
        grid-template-areas:
            'header header header'
            'main-content main-content right-sidebar'
            'footer footer footer';
    }
}
</style>
      <meta name="robots" content="noindex">
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <meta http-equiv="content-language" content="en">
	</head>
	<body>
	<div class="right-sidebar-grid">
        <header class="header">
			<h1>Exam - {{tittle}}</h1>
		</header>
		<main class="main-content">
		<div id="container">
			<div class="quiz-container">
		      <div id="quiz"></div>
			</div>
			<button class="quzControl" id="restart">Restart quiz</button>
			<button class="quzControl" id="previous">Previous Question</button>
			<!-- if this button is hidden the answer is not shown -->
			<button class="quzControl" id="answer">Show answer</button> 
			<button class="quzControl" id="next">Next Question</button>
			<button class="quzControl" id="submit">Submit Quiz</button>
			<div id="config">
			  <div id="loader"></div>
				<label>Randomize question</label><input type="checkbox" id="random"><span>&nbsp;&nbsp;&nbsp;&nbsp;</span>
				<label>Exsam mode</label><input type="checkbox" id="hide_answer_btn"><br>
				<label>How many question:</label><input type="number" id="n_of_que"><br>
				<label>Start:</label><input type="number" id="start_of_que"><br>
				<label>End:</label><input type="number" id="end_of_que"><br>
				<label>Time in minutes:</label><input type="number" id="timeInmunites">
				<button id="start">Start Quiz</button>
			</div>
		</div>
		</main>
		<section class="right-sidebar">
			<h4 style="display:none" align="center" id="showTimer"><span id="iTimeShow">Time Remaining: </span><br/><span id='timer' style="font-size:25px;">No limit</span></h4>
			<br>
			<div id="pages"></div>
			<div id="results"></div>
		</section>
		<script>
  var myQuestions;
 
/**
Based on the turorial 
https://www.sitepoint.com/simple-javascript-quiz/
*/ 
 
  // Functions
  function prepareQuiz(){
    // variable to store the HTML output
    const output = [];

    // for each question...
	let nOfQuesions = parseInt(numberOfQuestion.value) + parseInt(startOfQuestion.value)
	let _beginOfQuesions = parseInt(startOfQuestion.value);
	if (_beginOfQuesions > 0){
		_beginOfQuesions--;
	}
    for(let i = _beginOfQuesions; i<nOfQuesions; i++){
		
		if(typeof myQuestions[i].question == 'object'){ //drag-drop question
			const questions = [];
			for(let j = 0; j < myQuestions[i].question.length; j++){
			      if (myQuestions[i].question[j].endsWith("$?__")){
				      questions.push(
						`<div class="dragdrop_question">${myQuestions[i].question[j].replace("$?__", "")}&nbsp;<div class="droptarget"></div></div>`
				      );
			      }else{
				      questions.push(
						`<div>${myQuestions[i].question[j]}</div>`
				      );
			      }
			}
			const question_box = `<div class="question_box">${questions.join("")}</div>`
			
			const answers = []
			for(let j = 0; j < myQuestions[i].answers.length; j++){
		      answers.push(
				`<p draggable="true" class="dragtarget">${myQuestions[i].answers[j]}</p>`
		      );
			}
			const answer_box = `<div class="answers_container" id="drag_drop-answer_slide${i}"><p>Answers:</p>${answers.join("")}</div>`

			if(myQuestions[i].referenceLink != ""){reftxt = `<p>Reference:</p><a href="${myQuestions[i].referenceLink}"  target="_blank">link</a>`}
			else{reftxt = ""}
			
			const correctAnsweredQuestions = []
			for(let j = 0; j < myQuestions[i].question.length; j++){
			      if (myQuestions[i].question[j].endsWith("$?__")){
				      correctAnsweredQuestions.push(
						`<div class="dragdrop_question">${myQuestions[i].question[j].replace("$?__", "")}&nbsp;<div class="droptarget">${myQuestions[i].correctAnswer[j]}</div></div>`
				      );
			      }else{
				      correctAnsweredQuestions.push(
						`<div>${myQuestions[i].question[j]}</div>`
				      );
			      }
			}
			
            output.push(
              `<div class="slide">
                <div class="answers"> ${question_box} </div>
                <div class="question"> ${answer_box} </div>
                
                <div class="explanation hidden"> Correct answer: </br>${correctAnsweredQuestions.join("")}</br>${myQuestions[i].explanation} ${reftxt}</div><hr>
              </div>`
            );
		}else if(Object.keys(myQuestions[i].answers).length == 0){ //Fill the blank question
              const answers = [];
              answers.push(
                `<label>
                  <input name="question${i}">
                </label>`
              );
            // add this question and its answers to the output
			if(myQuestions[i].referenceLink != ""){reftxt = `<p>Reference:</p><a href="${myQuestions[i].referenceLink}"  target="_blank">link</a>`}
			else{reftxt = ""}
            output.push(
              `<div class="slide">
                <div class="question"> ${myQuestions[i].question} </div>
                <div class="answers"> ${answers.join("")} </div>
                
                <div class="explanation hidden"> Correct answer: ${myQuestions[i].correctAnswer}</br>${myQuestions[i].explanation} ${reftxt}</div><hr>
              </div>`
            );
        }else{
            // variable to store the list of possible answers
            const answers = [];
            if(myQuestions[i].correctAnswer.length == 1){ // ...add an HTML radio button
                inputType = "radio";
            }else{
                inputType = "checkbox";
            }
            // and for each available answer...
            for(letter in myQuestions[i].answers){
              answers.push(
                `<label>
                  <input type="${inputType}" name="question${i}" value="${letter}">
                  ${myQuestions[i].answers[letter]}
                </label>`
              );
            }
            // add this question and its answers to the output
			if(myQuestions[i].referenceLink != ""){reftxt = `<p>Reference:</p><a href="${myQuestions[i].referenceLink}"  target="_blank">link</a>`}
			else{reftxt = ""}
            output.push(
              `<div class="slide">
                <div class="question"> ${myQuestions[i].question} </div>
                <div class="answers"> ${answers.join("")} </div>
                
                <div class="explanation hidden"> ${myQuestions[i].explanation} ${reftxt}</div><hr>
              </div>`
            );
        }
    }
    // finally combine our output list into one string of HTML and put it on the page
    quizContainer.innerHTML = output.join('');
  }

  function showResults(){
    // keep track of user's answers
    let numCorrect = 0;

    // for each question...
    for(let i = 0; i<numberOfQuestion.value; i++){
        if (checkAnswer(myQuestions[i], i)){
            numCorrect++;
        }
    }
 
    slides.forEach(s => {
        s.classList.remove('active-slide');
        s.classList.remove('slide');
    });

    submitButton.style.display = 'none';
    answerButton.style.display = 'none';
    nextButton.style.display = 'none';
    previousButton.style.display = 'none';

    //resultsContainer.classList.add('hidden');
    pagesContainer.classList.add('hidden');

    // show number of correct answers out of total
    resultsContainer.innerHTML = `${numCorrect} out of ${numberOfQuestion.value}`;
	clearTimeout(timer);
	timerTxt.textContent = "";
  }

  function checkAnswer(currentQuestion, questionNumber){


      // find selected answer
      const answerContainer = answerContainers[questionNumber];
      const selector = `input[name=question${questionNumber}]:checked`;
      const selectorAll = `input[name=question${questionNumber}]`;
      var userAnswer = "";
      answerContainer.querySelectorAll(selector).forEach(ans => {
              userAnswer += (ans || {}).value;
          }
      );
      if(userAnswer === ""){
          var tmpQuestion = answerContainer.querySelectorAll(selectorAll);
          if(tmpQuestion.length < 2){ //if there is only text box there will be only one input
	          if (tmpQuestion.length == 0){
					// here should be the logic to check the answer
					let result = true
					dragDropAnswers = answerContainer.getElementsByTagName("p");
					
					if(dragDropAnswers.length == 0){
						result = false
					}else{
						dragDropQuestions = answerContainer.getElementsByClassName("dragdrop_question");
						for (let i = 0; i < currentQuestion.correctAnswer.length; i++) {
							currentAnswer = dragDropQuestions[i].getElementsByClassName("dragtarget");
							if(currentAnswer.length == 0){
								result = false;
								continue;
							}else{
								currentAnswer = currentAnswer[0];
							}
							if(currentAnswer.textContent === currentQuestion.correctAnswer[i]){
								currentAnswer.style.color = 'lightgreen'; // color the answers green
							}else{
								currentAnswer.style.color = 'red'; // color the answers red
								result = false;
							}
						}
					}
					return result;
		      }
              if(tmpQuestion[0].value === currentQuestion.correctAnswer){
                tmpQuestion[0].style.color = 'lightgreen'; // color the answers green
                return true;
            }else{
                tmpQuestion[0].style.color = 'red'; // color the answers red
                return false;
            }
          }
      }

      // if answer is correct
      if(userAnswer === currentQuestion.correctAnswer){
        answerContainer.querySelectorAll('label').forEach(ans => {
                if(currentQuestion.correctAnswer.includes((ans.querySelector(selector) || {}).value)){
                      ans.style.color = 'lightgreen'; // color the answers green
                }
            }
          );
        return true;
      }
      // if answer is wrong or blank
      else{

          answerContainer.querySelectorAll('label').forEach(ans => {
                  //if answer is in the correct color it green
                  if(currentQuestion.correctAnswer.includes((ans.querySelector(selectorAll) || {}).value)){
                      ans.style.color = 'lightgreen'; // color the answers green
                  }else{
                      ans.style.color = 'red'; // color the answers red
                  }
              }
          );

      }
      return false;
  }

  function debug_showSlide(n){
      if(!quizStarted){return};
      if(n == -1){restartQuiz()}
      n--;
      slides[currentSlide].classList.remove('active-slide');
      slides[n].classList.add('active-slide');
      currentSlide = n;
      pagesContainer.innerText = (n + 1) + " / " + slides.length;
      return;
  }

  function showSlide(n) {
    if(!quizStarted){return};
    if(n == -1){restartQuiz()}
    slides[currentSlide].classList.remove('active-slide');
    slides[n].classList.add('active-slide');
    currentSlide = n;
    if(currentSlide === 0){
      previousButton.style.display = 'none';
      restartButton.classList.remove("quzControl");
      restartButton.style.display = 'inline-block';
    }
    else{
      previousButton.style.display = 'inline-block';
      restartButton.style.display = 'none';
    }
    if(currentSlide === slides.length-1){
      nextButton.style.display = 'none';
      submitButton.style.display = 'inline-block';
    }
    else{
      nextButton.style.display = 'inline-block';
      submitButton.style.display = 'none';
    }
    pagesContainer.innerText = (n + 1) + " / " + slides.length;
  }

  function showNextSlide() {
    showSlide(currentSlide + 1);
  }

  function showPreviousSlide() {
    showSlide(currentSlide - 1);
  }

  function showAnswer() {
    for (var i = 0; i < slides[currentSlide].children.length; i++) {
        if (slides[currentSlide].children[i].className == "explanation hidden") {
          slides[currentSlide].children[i].classList.remove("hidden");
          checkAnswer(myQuestions[currentSlide], currentSlide)
        }
    }
  }
  
  function shuffle(array) {
    let currentIndex = array.length,  randomIndex;

    // While there remain elements to shuffle...
    while (currentIndex != 0) {

      // Pick a remaining element...
      randomIndex = Math.floor(Math.random() * currentIndex);
      currentIndex--;

      // And swap it with the current element.
      [array[currentIndex], array[randomIndex]] = [
        array[randomIndex], array[currentIndex]];
    }

    return array;
  }

  function restartQuiz(){
      currentSlide = 0;
      quizStarted = false;
      clearTimeout(timer);
      nextButton.classList.add("quzControl");
      nextButton.style.display = 'none';
      submitButton.classList.add("quzControl");
      previousButton.classList.add("quzControl");
      answerButton.classList.add("quzControl");
      document.getElementById("config").classList.remove("quzControl");
      document.getElementById("pages").innerHTML = "";
      restartButton.classList.add("quzControl");
      restartButton.style.display = 'none';
      // Show empty slide
      slidesContainer[0].style.height = '0%';
      slidesContainer[0].innerHTML=`<div id="quiz"></div>`;
      //showSlide(currentSlide);
      timerTxt.textContent = "No limit";
      document.getElementById("showTimer").style = "display:none"
      
      startQuiz = document.getElementById("start");
      randomQuestion = document.getElementById("random");
      hideAnserBtn = document.getElementById("hide_answer_btn");
      numberOfQuestion = document.getElementById("n_of_que");
      startOfQuestion = document.getElementById("start_of_que");
      countDown = document.getElementById("timeInmunites");
      timerTxt = document.getElementById("timer");
  }

  function buildQuiz(){
      document.getElementById("loader").style.display = "block";
      if(randomQuestion.checked){
          myQuestions = shuffle(myQuestions)
      }
      if(numberOfQuestion.value > myQuestions.length || numberOfQuestion.value < 0 || numberOfQuestion.value == ''){
          numberOfQuestion.value = myQuestions.length
      }
      if(startOfQuestion.value > myQuestions.length || startOfQuestion.value < 0 || startOfQuestion.value == ''){
          startOfQuestion.value = 0;
      }
      if(endOfQuestion.value > myQuestions.length || endOfQuestion.value < 0){
          endOfQuestion.value = myQuestions.length
      }
	  if(startOfQuestion.value != '' && endOfQuestion.value != ''){
		  numberOfQuestion.value = Math.abs(startOfQuestion.value - endOfQuestion.value)
		  if(numberOfQuestion.value < 0){
			  numberOfQuestion.value = myQuestions.length;
		  }
	  }
	  
      if(countDown.value == '' || countDown.value == 0){
          countDown = -1;
      }else{
          countDown = parseInt(countDown.value) * 60;
          if (!isNaN(countDown)) timedCount();
          document.getElementById("showTimer").style.display = "inline-block";
      }
      // Variables
      quizContainer = document.getElementById('quiz');
      resultsContainer = document.getElementById('results');
      pagesContainer = document.getElementById('pages');
      submitButton = document.getElementById('submit');
      answerButton = document.getElementById('answer');
      restartButton = document.getElementById('restart');
      slidesContainer = document.getElementsByClassName("quiz-container");
      
      prepareQuiz()

      // gather answer containers from our quiz
      answerContainers = quizContainer.querySelectorAll('.answers');
        
      // Pagination
      previousButton = document.getElementById("previous");
      nextButton = document.getElementById("next");
      
      // Event listeners
      submitButton.addEventListener('click', showResults);
      previousButton.addEventListener("click", showPreviousSlide);
      nextButton.addEventListener("click", showNextSlide);
      if(hideAnserBtn.checked){
          answerButton.addEventListener("click", showAnswer);
      }
      restartButton.addEventListener("click", restartQuiz);

      slides = document.querySelectorAll(".slide");
      submitButton.classList.remove("quzControl");
      previousButton.classList.remove("quzControl");
      nextButton.classList.remove("quzControl");
      if(!hideAnserBtn.checked){
          answerButton.classList.remove("quzControl");
      }
      restartButton.classList.remove("quzControl");
      slidesContainer[0].style.height = '95%';
      document.getElementById("config").classList.add("quzControl");
      // Show empty slide
      document.getElementById("loader").style.display = "none";
      quizStarted = true;
      showSlide(currentSlide);
  }

  function timedCount(){
    var hours = parseInt(countDown / 3600) % 24;
    var minutes = parseInt(countDown / 60) % 60;
    var seconds = countDown % 60;
    var result = (hours < 10 ? "0" + hours : hours) + ":" + (minutes < 10 ? "0" + minutes : minutes) + ":" + (seconds  < 10 ? "0" + seconds : seconds);
    timerTxt.textContent = result;
    if(countDown == 0 ){
        showResults();
        return false;
    }

    countDown = countDown - 1;
    timer = setTimeout(function(){
        timedCount()
    },1000);
  }

// Variables
var countDown=-1; //time in seconds
var timer;

var quizContainer;
var resultsContainer;
var pagesContainer;
var submitButton;
var answerButton;
var restartButton;

var answerContainers;
var previousButton;
var nextButton;
var slides;

var randomQuestion;
var hideAnserBtn;
var numberOfQuestion;
var startOfQuestion;
var endOfQuestion;
var startQuiz;

var timerTxt;

var slidesContainer;

let currentSlide = 0;

var quizStarted = false;

var myQuestions = {{!json_Output['dump']}};

// Quiz settings
startQuiz = document.getElementById("start");
randomQuestion = document.getElementById("random");
hideAnserBtn = document.getElementById("hide_answer_btn");
numberOfQuestion = document.getElementById("n_of_que");
startOfQuestion = document.getElementById("start_of_que");
endOfQuestion = document.getElementById("end_of_que");
countDown = document.getElementById("timeInmunites");
timerTxt = document.getElementById("timer");

// Kick things off
//buildQuiz();
startQuiz.addEventListener('click', buildQuiz);

var dragP;
/* Events fired on the drag target */
document.addEventListener("dragstart", function (event) {
    // The dataTransfer.setData() method sets the data type and the value of the dragged data
    // event.dataTransfer.setData("Text", event.target.id);
    dragP = event.target;

    // Output some text when starting to drag the p element
    //document.getElementById("demo").innerHTML = "Started to drag the p element.";

    // Change the opacity of the draggable element
    event.target.style.opacity = "0.4";
});

// While dragging the p element, change the color of the output text
document.addEventListener("drag", function (event) {
    //document.getElementById("demo").style.color = "red";
});

// Output some text when finished dragging the p element and reset the opacity
document.addEventListener("dragend", function (event) {
    //document.getElementById("demo").innerHTML = "Finished dragging the p element.";
    event.target.style.opacity = "1";
});

/* Events fired on the drop target */

// When the draggable p element enters the droptarget, change the DIVS's border style
document.addEventListener("dragenter", function (event) {
    if (event.target.className == "droptarget") {
        event.target.style.border = "3px dotted red";
    }
});

// By default, data/elements cannot be dropped in other elements. To allow a drop, we must prevent the default handling of the element
document.addEventListener("dragover", function (event) {
    event.preventDefault();
});

// When the draggable p element leaves the droptarget, reset the DIVS's border style
document.addEventListener("dragleave", function (event) {
    if (event.target.className == "droptarget") {
        event.target.style.border = "";
    }
});

/* On drop - Prevent the browser default handling of the data (default is open as link on drop)
   Reset the color of the output text and DIV's border-color
   Get the dragged data with the dataTransfer.getData() method
   The dragged data is the id of the dragged element ("drag1")
   Append the dragged element into the drop element
*/
document.addEventListener("drop", function (event) {
    event.preventDefault();
    let targetDiv = event.target;
    if (targetDiv.className == "droptarget") {
        //document.getElementById("demo").style.color = "";
        targetDiv.style.border = "hidden";
        if (targetDiv.childElementCount != 0){
            let childP = targetDiv.getElementsByTagName("p")[0];
            document.getElementById("drag_drop-answer_slide"+currentSlide).appendChild(childP);
        }
        targetDiv.appendChild(dragP);
        dragP = null;
    }
});

document.onkeydown = function(evt) {
    evt = evt || window.event;
	switch(evt.keyCode){
		case 37: showSlide(currentSlide - 1); return; //left arrow
		case 39: showSlide(currentSlide + 1); return; //rigth arrow
		case 13:
		case 32: if(!hideAnserBtn.checked){showAnswer();} return; //spacebar 
		default: if(event.ctrlKey && event.altKey && evt.key === "d"){
			var selection = parseInt(prompt("Jump to question:", "Type a number!"), 10);
			if (isNaN(selection)){
			  alert('Type a number');
			} else {
			  debug_showSlide(selection)
			}
		}
	}
};
</script>
	</div>
	</body>
</html>