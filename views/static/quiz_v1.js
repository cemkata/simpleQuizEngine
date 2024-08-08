  var myQuestions;
 
/**
Based on the turorial 
https://www.sitepoint.com/simple-javascript-quiz/
*/ 
 
  // Functions
  function buildQuiz(){
    // variable to store the HTML output
    const output = [];

    // for each question...
    myQuestions.forEach(
      (currentQuestion, questionNumber) => {

        if(Object.keys(currentQuestion.answers).length == 0){ //Fill the blank question
            i = 1;
			//todo
              // ...add an HTML radio button
              const answers = [];
              answers.push(
                `<label>
                  <input name="question${questionNumber}">
                </label>`
              );
            // add this question and its answers to the output
            output.push(
              `<div class="slide">
                <div class="question"> ${currentQuestion.question} </div>
                <div class="answers"> ${answers.join("")} </div>
                
                <div class="explanation hidden"> Correct answer: ${currentQuestion.correctAnswer}</br>${currentQuestion.explanation} </div>
              </div><hr>`
            );

        }else{
            // variable to store the list of possible answers
            const answers = [];
            if(currentQuestion.correctAnswer.length == 1){
                inputType = "radio";
            }else{
                inputType = "checkbox";
            }
            // and for each available answer...
            for(letter in currentQuestion.answers){

              // ...add an HTML radio button
              answers.push(
                `<label>
                  <input type="${inputType}" name="question${questionNumber}" value="${letter}">
                  ${currentQuestion.answers[letter]}
                </label>`
              );
            }
            // add this question and its answers to the output
            output.push(
              `<div class="slide">
                <div class="question"> ${currentQuestion.question} </div>
                <div class="answers"> ${answers.join("")} </div>
                
                <div class="explanation hidden"> ${currentQuestion.explanation} </div>
              </div>`
            );
        }
      }
    );

    // finally combine our output list into one string of HTML and put it on the page
    quizContainer.innerHTML = output.join('');
  }

  function showResults(){
    // keep track of user's answers
    let numCorrect = 0;

    // for each question...
    myQuestions.forEach((currentQuestion, questionNumber) => {
        if (checkAnswer(currentQuestion, questionNumber)){
            numCorrect++;
        }
            
    });

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
    resultsContainer.innerHTML = `${numCorrect} out of ${myQuestions.length}`;
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

var answerContainers;
var previousButton;
var nextButton;
var slides;

let currentSlide = 0;
          
xmlhttp.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {
        myQuestions = JSON.parse(this.responseText);
          // Variables
          quizContainer = document.getElementById('quiz');
          resultsContainer = document.getElementById('results');
          pagesContainer = document.getElementById('pages');
          submitButton = document.getElementById('submit');
          answerButton = document.getElementById('answer');

          // Kick things off
          buildQuiz();
          
          // gather answer containers from our quiz
          answerContainers = quizContainer.querySelectorAll('.answers');
            
          // Pagination
          previousButton = document.getElementById("previous");
          nextButton = document.getElementById("next");
          slides = document.querySelectorAll(".slide");
          
          
          // Event listeners
          submitButton.addEventListener('click', showResults);
          previousButton.addEventListener("click", showPreviousSlide);
          nextButton.addEventListener("click", showNextSlide);
          answerButton.addEventListener("click", showAnswer);
          
          // Show the first slide
          showSlide(currentSlide);
    }
};
xmlhttp.open("GET", url, true);
xmlhttp.send();

