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
    i=0;
    myQuestions.forEach(
      (currentQuestion, questionNumber) => {
        if(i == numberOfQuestion.value){return}
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
                
                <div class="explanation hidden"> Correct answer: ${currentQuestion.correctAnswer}</br>${currentQuestion.explanation} </div><hr>
              </div>`
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
                
                <div class="explanation hidden"> ${currentQuestion.explanation} </div><hr>
              </div>`
            );
        }
        i++;
      }
    );

    // finally combine our output list into one string of HTML and put it on the page
    quizContainer.innerHTML = output.join('');
  }

  function showResults(){
    // keep track of user's answers
    let numCorrect = 0;

    // for each question...
	i=0;
    myQuestions.forEach((currentQuestion, questionNumber) => {
		if(i == numberOfQuestion.value){return}
        if (checkAnswer(currentQuestion, questionNumber)){
            numCorrect++;
        }
		i++;    
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

var randomQuestion;
var numberOfQuestion;
var startQuiz;

let currentSlide = 0;

xmlhttp.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {
          myQuestions = JSON.parse(this.responseText);
          
          // Quiz settings
          startQuiz = document.getElementById("start");
          randomQuestion = document.getElementById("random");
          numberOfQuestion = document.getElementById("n_of_que");
          
          // Kick things off
          //buildQuiz();
          startQuiz.addEventListener('click', buildQuiz);
    }
};
xmlhttp.open("GET", url, true);
xmlhttp.send();

