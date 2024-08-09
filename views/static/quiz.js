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
		
		if(typeof myQuestions[i].question == 'object'){ //drag-drop question
			const questions = [];
			for(let j = 0; j < myQuestions[i].question.length; j++){
				  if (myQuestions[i].question[j].endsWith("$?__")){
					  questions.push(
						`<h5 class="dragdrop_question">${myQuestions[i].question[j].replace("$?__", "")}<div class="droptarget"></div>`
					  );
				  }else{
					  questions.push(
						`<h5>${myQuestions[i].question[j]}`
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
						`<h5 class="dragdrop_question">${myQuestions[i].question[j].replace("$?__", "")}<div class="droptarget">${myQuestions[i].correctAnswer[j]}</div>`
					  );
				  }else{
					  correctAnsweredQuestions.push(
						`<h5>${myQuestions[i].question[j]}`
					  );
				  }
			}
			
            output.push(
              `<div class="slide">
                <div class="answers"> ${question_box} </div>
                <div class="question"> ${answer_box} </div>
                
                <div class="explanation hidden"> Correct answer: </br>${correctAnsweredQuestions.join("")}</br>${myQuestions[i].explanation} ${reftxt}</div><hr>
              </div>`
			  //TODO
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
	  restartButton.classList.remove("quzControl");
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
      clearTimeout(timer);
      nextButton.classList.add("quzControl");
      nextButton.style.display = 'none';
      submitButton.classList.add("quzControl");
      previousButton.classList.add("quzControl");
      answerButton.classList.add("quzControl");
      document.getElementById("config").classList.remove("quzControl");
      document.getElementById("pages").innerHTML = "";
      restartButton.classList.add("quzControl");
      // Show empty slide
      slidesContainer = document.getElementsByClassName("quiz-container");
      slidesContainer[0].innerHTML=`<div id="quiz"></div>`;
      //showSlide(currentSlide);
      timerTxt.textContent = "No limit";
      document.getElementById("showTimer").style = "display:none"
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
          if (!isNaN(countDown)) {
			timedCount();
		  }else{
			countDown = document.getElementById("timeInmunites");
			countDown = parseInt(countDown.value) * 60;
			timedCount();
		  }
          document.getElementById("showTimer").style = "display:inline-block;color:#000000;position:absolute;left:65%;top:30%;"
      }
      // Variables
      quizContainer = document.getElementById('quiz');
      resultsContainer = document.getElementById('results');
      pagesContainer = document.getElementById('pages');
      submitButton = document.getElementById('submit');
      answerButton = document.getElementById('answer');
      restartButton = document.getElementById('restart');
      
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
      restartButton.addEventListener("click", restartQuiz);

      slides = document.querySelectorAll(".slide");
      submitButton.classList.remove("quzControl");
      previousButton.classList.remove("quzControl");
      nextButton.classList.remove("quzControl");
      answerButton.classList.remove("quzControl");
	  restartButton.classList.remove("quzControl");
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

var countDown=-1; //time in seconds
var timer;

var xmlhttp = new XMLHttpRequest();
var cource = document.getElementById("cid").value;
var dump = document.getElementById("dump").value;
var url = `/get?courseID=${cource}&examID=${dump}`;

// Variables
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
var numberOfQuestion;
var startQuiz;

var timerTxt;

let currentSlide = 0;

xmlhttp.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {
          myQuestions = JSON.parse(this.responseText)['dump'];
          
          // Quiz settings
          startQuiz = document.getElementById("start");
          randomQuestion = document.getElementById("random");
          numberOfQuestion = document.getElementById("n_of_que");
          countDown = document.getElementById("timeInmunites");
          timerTxt = document.getElementById("timer");
          // Kick things off
          //buildQuiz();
          startQuiz.addEventListener('click', buildQuiz);
    }
};
xmlhttp.open("GET", url, true);
xmlhttp.send();

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