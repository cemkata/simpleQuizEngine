<html lang="en" class="">
	<head>
	  <meta charset="UTF-8">
	  <title>Exam - {{tittle}}</title> 
<style>
/*@import url(https://fonts.googleapis.com/css?family=Work+Sans:300,600);*/

body{
	font-size: 20px;
	font-family: 'Work Sans', sans-serif;
	color: #333;
  font-weight: 300;
  text-align: left;
  background-color: #f8f6f0;
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
  width: 600px;*/
  height: 75%;
  width: 60%;
  margin-top: 30px;
  margin-bottom: 30px;
  margin-left: 10px;
  margin-right: 10px;
  overflow-y: auto;
}

.pages{
  position: relative;
  height: 450px;
  margin-top: 30px;
  margin-bottom: 30px;
}
</style>
	</head>
	<body>
		<div class="quiz-container">
		  <div id="quiz"></div>
		</div>
		<h4 style="display:none" align="center" id="showTimer"><span id="iTimeShow">Time Remaining: </span><br/><span id='timer' style="font-size:25px;">No limit</span></h4>
		<button class="quzControl" id="previous">Previous Question</button>
		<!-- if this button is hidden the answer is not shown -->
		<button class="quzControl" id="answer">Show answer</button> 
		<button class="quzControl" id="next">Next Question</button>
		<button class="quzControl" id="submit">Submit Quiz</button>
		<div id="results"></div>
		<div id="pages"></div>
		<div id="config">
			<label>Randomize question</label><input type="checkbox" id="random">
			<label>How many question:</label><input type="number" id="n_of_que">
			<label>Time in minutes:</label><input type="number" id="timeInmunites">
			<button id="start">Start Quiz</button>
		</div>
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
    for(let i = 0; i<numberOfQuestion.value; i++){
        if(Object.keys(myQuestions[i].answers).length == 0){ //Fill the blank question
              const answers = [];
              answers.push(
                `<label>
                  <input name="question${i}">
                </label>`
              );
            // add this question and its answers to the output
            output.push(
              `<div class="slide">
                <div class="question"> ${myQuestions[i].question} </div>
                <div class="answers"> ${answers.join("")} </div>
                
                <div class="explanation hidden"> Correct answer: ${myQuestions[i].correctAnswer}</br>${myQuestions[i].explanation} </div><hr>
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
            output.push(
              `<div class="slide">
                <div class="question"> ${myQuestions[i].question} </div>
                <div class="answers"> ${answers.join("")} </div>
                
                <div class="explanation hidden"> ${myQuestions[i].explanation} </div><hr>
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
      n--;
      slides[currentSlide].classList.remove('active-slide');
      slides[n].classList.add('active-slide');
      currentSlide = n;
      pagesContainer.innerText = (n + 1) + " / " + slides.length;
      return;
  }

  function showSlide(n) {
    slides[currentSlide].classList.remove('active-slide');
    slides[n].classList.add('active-slide');
    currentSlide = n;
    if(currentSlide === 0){
      previousButton.style.display = 'none';
    }
    else{
      previousButton.style.display = 'inline-block';
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


  function buildQuiz(){
      if(randomQuestion.checked){
          myQuestions = shuffle(myQuestions)
      }
      if(numberOfQuestion.value > myQuestions.length || numberOfQuestion.value < 0 || numberOfQuestion.value == ''){
          numberOfQuestion.value = myQuestions.length
      }
      if(countDown.value == '' || countDown.value == 0){
          countDown = -1;
      }else{
          countDown = parseInt(countDown.value) * 60;
          if (!isNaN(countDown)) timedCount();
          document.getElementById("showTimer").style = "display:inline-block;color:#000000;position:absolute;left:65%;top:30%;"
      }
      // Variables
      quizContainer = document.getElementById('quiz');
      resultsContainer = document.getElementById('results');
      pagesContainer = document.getElementById('pages');
      submitButton = document.getElementById('submit');
      answerButton = document.getElementById('answer');
      
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
      answerButton.addEventListener("click", showAnswer);

      slides = document.querySelectorAll(".slide");
      submitButton.classList.remove("quzControl");
      previousButton.classList.remove("quzControl");
      nextButton.classList.remove("quzControl");
      answerButton.classList.remove("quzControl");
      document.getElementById("config").classList.add("quzControl");
      // Show the first slide
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

var answerContainers;
var previousButton;
var nextButton;
var slides;

var randomQuestion;
var numberOfQuestion;
var startQuiz;

var timerTxt;

let currentSlide = 0;

var responseText = `
{{!json_Output}}
`;

myQuestions = JSON.parse(responseText);

// Quiz settings
startQuiz = document.getElementById("start");
randomQuestion = document.getElementById("random");
numberOfQuestion = document.getElementById("n_of_que");
countDown = document.getElementById("timeInmunites");
timerTxt = document.getElementById("timer");

// Kick things off
//buildQuiz();
startQuiz.addEventListener('click', buildQuiz);
</script>

	</body>
</html>