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
    for(let i = _beginOfQuesions; i<nOfQuesions; i++){

        if(typeof myQuestions[i].question == 'object'){ //drag-drop question
            const questions = [];
            let k = 0;
            for(let j = 0; j < myQuestions[i].question.length; j++){
                  if (myQuestions[i].question[j].endsWith("$?__")){
                      if (Object.hasOwn(myQuestions[i], 'answersGroups')){
                        var questionStr = `<div class="dragdrop_question" data-group-id="${myQuestions[i].answersGroups[k]}">${myQuestions[i].question[j].replace("$?__", "")}&nbsp;<div class="droptarget"></div></div>`
                      }else{
                        var questionStr = `<div class="dragdrop_question" data-group-id="${j}">${myQuestions[i].question[j].replace("$?__", "")}&nbsp;<div class="droptarget"></div></div>`
                      }
                      questions.push(questionStr);
                      k++;
                  }else{
                      questions.push(
                        `<div>${myQuestions[i].question[j]}</div>`
                      );
                  }
            }
            const question_box = `<div class="question_box">${questions.join("")}</div>`

            var answers = []
            for(let j = 0; j < myQuestions[i].answers.length; j++){
              if (Object.hasOwn(myQuestions[i], 'answersCount')){
                totalSelection = myQuestions[i].answersCount[j]
              }else{
                totalSelection = 1;
              }
              for(let k = 0; k<totalSelection; k++){
                  answers.push(
                    `<span draggable="true" class="dragtarget">${myQuestions[i].answers[j]}</span>`
                  );
              }
            }
            if(randomAnswer.checked){
              answers = shuffle(answers);
            }
            const answer_box = `<div class="answers_container" id="drag_drop-answer_slide${i}"><p>Answers:</p>${answers.join("")}</div>`

            if(myQuestions[i].referenceLink != ""){reftxt = `<p>Reference:</p><a href="${myQuestions[i].referenceLink}"  target="_blank">link</a>`}
            else{reftxt = ""}

            const correctAnsweredQuestions = []
            k = 0;
            for(let j = 0; j < myQuestions[i].question.length; j++){
                  if (myQuestions[i].question[j].endsWith("$?__")){
                      correctAnsweredQuestions.push(
                        `<div class="dragdrop_question">${myQuestions[i].question[j].replace("$?__", "")}&nbsp;<div class="droptarget">${myQuestions[i].correctAnswer[k]}</div></div>`
                      );
                       k++;
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
        }else if (myQuestions[i].category == 1 || myQuestions[i].category == 2){
            // variable to store the list of possible answers
            const answers = [];
            if(myQuestions[i].correctAnswer.length == 1){ // ...add an HTML radio button
                inputType = "radio";
            }else{
                inputType = "checkbox";
            }
            if(randomAnswer.checked){
              var tempHolder = [];
              var firstLeterDigit_IN_CorrectAnswer = " "
                for(letter in myQuestions[i].answers){
                    var isCorrect = false;
                    if (firstLeterDigit_IN_CorrectAnswer == " "){
                        firstLeterDigit_IN_CorrectAnswer = letter.charCodeAt(0);
                    }
                    if (myQuestions[i].correctAnswer.includes(letter)){
                        isCorrect = true;
                    }
                    let tempCell = [myQuestions[i].answers[letter], isCorrect];
                    tempHolder.push(tempCell);
                }
              tempHolder = shuffle(tempHolder);
              var newAnswDict = {};
              var newCorrectAnswer = ""
              for (let k = 0; k < tempHolder.length; k++){
                  let inx = String.fromCharCode(firstLeterDigit_IN_CorrectAnswer + k);
                  newAnswDict[inx] = tempHolder[k][0];
                  if (tempHolder[k][1]){
                      newCorrectAnswer += inx;
                  }
              }
              myQuestions[i].correctAnswer = newCorrectAnswer;
              myQuestions[i].answers = newAnswDict;
            }
            // and for each available answer...
            for(letter in myQuestions[i].answers){
              answers.push(
                `<label>
                  <input type="${inputType}" name="question${i}" value="${letter}">
                  ${escapeHtml(myQuestions[i].answers[letter])}
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
        }else{
			alert(`Question No ${i} - new question type\nNot implemented`);
		}
    }
    // finally combine our output list into one string of HTML and put it on the page
    quizContainer.innerHTML = output.join('');
  }
  
  function escapeHtml(unsafe){
	if(unsafe[0] == '¶') return unsafe.substring(1);
    return unsafe
         .replace(/&/g, "&amp;")
         .replace(/</g, "&lt;")
         .replace(/>/g, "&gt;")
         .replace(/"/g, "&quot;")
         .replace(/'/g, "&#039;");
  }
 
  function prepareImgs(){
      let imgs = document.getElementsByClassName("popImage");
      for(let i =0; i<imgs.length; i++){
          if(imgs[i].onclick == null){
              imgs[i].onclick = function(){
                let parentDIV = this.parentElement;
                for(;;){
                    if(parentDIV.classList.length != 0){
                        if(parentDIV.classList.contains("active-slide")){
                            break;
                        }
                    }
                    parentDIV = parentDIV.parentElement;
                    if(parentDIV.id == "quiz"){return}
                }
                modal.style.display = "block";
                modalImg.src = this.src;
                captionText.innerHTML = this.alt;
              }
          }
      }
      // When the user clicks on <span> (x), close the modal
      span.onclick = function() {
        modal.style.display = "none";
      }

      // When the user clicks somewhere in the modal, close the modal
      modal.onclick = function() {
        modal.style.display = "none";
      }
  }

  function showResults(){
      if (confirm("Grade the quiz?") != true) {
        return
      }
    // keep track of user's answers
    let numCorrect = 0;
    clearTimeout(timer);
	paused = false;
    // for each question...
    var nextWrongAncor = "";
    var holdPrevWrong;
    for(let i = _beginOfQuesions, j = 0; i<nOfQuesions; i++, j++){
        let answerContainer = answerContainers[j];
        let holderDiv = document.createElement("div")
        let childP = document.createElement("p");
        childP.innerText = "Question " + (j + 1);
        if (checkAnswer(myQuestions[i], j)){
            numCorrect++;
            holderDiv.appendChild(childP)
        }else{
            if (nextWrongAncor == ""){
                nextWrongAncor = "wrong" + (j + 1);
                if(j != 0){
                    let tmpDivHolder = document.getElementById("quiz").childNodes[0];
                    let linkText_first = document.createTextNode("First wrong");
                    let childA_first = document.createElement('a');
                    childA_first.appendChild(linkText_first);
                    childA_first.title = "First";
                    childA_first.href = "#"+ nextWrongAncor;
                    childA_first.classList.add("wrongAnswer");
                    tmpDivHolder.insertBefore(childA_first, tmpDivHolder.firstChild);
                }
                childP.id = nextWrongAncor;
                holderDiv.appendChild(childP)
            }else{
                var linkText_prev = document.createTextNode("Previous wrong");
                var childA_prev = document.createElement('a');
                childA_prev.appendChild(linkText_prev);
                childA_prev.title = "Previous";
                childA_prev.href = "#"+ nextWrongAncor;
                childA_prev.classList.add("wrongAnswer");

                let divider = document.createElement("span");
                divider.innerText = "   ";

                nextWrongAncor = "wrong" + (j + 1);

                var linkText_next = document.createTextNode("Next wrong");
                var childA_next = document.createElement('a');
                childA_next.appendChild(linkText_next);
                childA_next.title = "Next";
                childA_next.href = "#"+ nextWrongAncor;
                childA_next.classList.add("wrongAnswer");

                childP.id = nextWrongAncor;
                holderDiv.appendChild(childP)
                holderDiv.appendChild(childA_prev);
				/***Old aragment -> "Previous wrong"   "Next wrong" */
                /*holderDiv.appendChild(divider);
                /holdPrevWrong.parentElement.childNodes[0].appendChild(childA_next)*/
				let tmp_hold = holdPrevWrong.parentElement.childNodes[0];
				tmp_hold.insertBefore(divider, tmp_hold.childNodes[1]);
				tmp_hold.insertBefore(childA_next, tmp_hold.childNodes[1]);
            }
            holdPrevWrong = answerContainer;
        }
        answerContainer.parentElement.insertBefore(holderDiv, answerContainer.parentElement.firstChild);
    }

    slides.forEach(s => {
        s.classList.remove('active-slide');
        s.classList.remove('slide');
    });

    nextButton.classList.add("quzControl");
    submitButton.classList.add("quzControl");
    previousButton.classList.add("quzControl");
    answerButton.classList.add("quzControl");

    //resultsContainer.classList.add('hidden');
    pagesContainer.classList.add('hidden');
    selectedQuestionContainer.classList.add('hidden');

    // show number of correct answers out of total
    resultsContainer.innerHTML = `Result: ${numCorrect} out of ${numberOfQuestion.value}`;
    timerTxt.textContent = "";
    let grade = numCorrect/numberOfQuestion.value * 100
    pagesContainer.innerText = `Grade: ${grade.toFixed(2)}%`;
  }

  function checkAnswer(currentQuestion, questionNumber){
      // find selected answer
      const answerContainer = answerContainers[questionNumber];
      const selector = `input[name=question${questionNumber + _beginOfQuesions}]:checked`;
      const selectorAll = `input[name=question${questionNumber + _beginOfQuesions}]`;
      var userAnswer = "";
      answerContainer.querySelectorAll(selector).forEach(ans => {
              userAnswer += (ans || {}).value;
          }
      );
      if(userAnswer === ""){
          var tmpQuestion = answerContainer.querySelectorAll(selectorAll);
          if(tmpQuestion.length < 2){ //if there is only text box there will be only one input
              if (tmpQuestion.length == 0){
                    // here should be the logic to check the drag and drop answer
                    let result = true
                    dragDropAnswers = answerContainer.getElementsByTagName("span");
                    correctAnswers = [];
                    if(dragDropAnswers.length == 0){
                        dragDropAnswers = answerContainer.getElementsByClassName("dragdrop_question");
                        for (let i = 0; i < currentQuestion.correctAnswer.length; i++) {
                            currentAnswer = dragDropAnswers[i].getElementsByClassName("droptarget");
                            currentAnswer = currentAnswer[0];
                            currentAnswer.textContent = currentQuestion.correctAnswer[i];
                            currentAnswer.style.color = 'red'; // color the answers red
                        }
                        result = false
                    }else{
                        dragDropQuestions = answerContainer.getElementsByClassName("dragdrop_question");
                        correctAnswers.push(false)
                        for (let i = 0; i < currentQuestion.correctAnswer.length; i++) {
                            currentAnswer = dragDropQuestions[i].getElementsByClassName("dragtarget");
                            currentGroup = dragDropQuestions[i].dataset.groupId
                            if(currentAnswer.length == 0){
                                currentAnswer = dragDropQuestions[i].getElementsByClassName("droptarget");
                                currentAnswer = currentAnswer[0];
                                currentAnswer.textContent = currentQuestion.correctAnswer[i];
                                currentAnswer.style.color = 'red'; // color the answers red
                                result = false;
                                continue;
                            }else{
                                currentAnswer = currentAnswer[0];
                            }
                            if (Object.hasOwn(currentQuestion, 'answersGroups')){
                                for(let j = 0; j < currentQuestion.answersGroups.length; j++){
                                    if(currentGroup == currentQuestion.answersGroups[j]){
                                        if(currentAnswer.textContent === currentQuestion.correctAnswer[j]){
                                            correctAnswers[i]=true;
                                        }
                                    }
                                }
                            }else{
                                if(currentAnswer.textContent === currentQuestion.correctAnswer[i]){
                                    correctAnswers[i]=true;
                                }
                            }
                        }
                        for (let i = 0; i < currentQuestion.correctAnswer.length; i++) {
                            currentAnswer = dragDropQuestions[i].getElementsByClassName("dragtarget");
                            currentAnswer = currentAnswer[0];
                            if (correctAnswers[i]){
                                currentAnswer.style.color = 'lightgreen'; // color the answers green
                            }else{
                                if (currentAnswer !== undefined){
                                    currentAnswer.style.color = 'red'; // color the answers red
                                }
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
      else if (currentQuestion.category == 1 || currentQuestion.category == 2){

          answerContainer.querySelectorAll('label').forEach(ans => {
                  //if answer is in the correct color it green
                  if(currentQuestion.correctAnswer.includes((ans.querySelector(selectorAll) || {}).value)){
                      ans.style.color = 'lightgreen'; // color the answers green
                  }else{
                      ans.style.color = 'red'; // color the answers red
                  }
              }
          );

      }else{
			alert("new question type\nNot implemented");
      }
      return false;
  }

  function debug_showSlide(n){
      if(n <= 0){return}
      n--;
      if(n >= slides.length){return}
      showSlide(n);
  }

  function showSlide(n){
    if(n == -1){restartQuiz(); return;}
    if(n == slides.length){showResults(); return;}
    slides[currentSlide].classList.remove('active-slide');
    slides[n].classList.add('active-slide');
    modal.style.display = "none";
    currentSlide = n;
    if(currentSlide === 0){
      previousButton.classList.add("quzControl");
      restartButton.classList.remove("quzControl");
      /*restartButton.style.display = 'inline-block';*/
    }
    else{
      /*previousButton.style.display = 'inline-block';*/
      previousButton.classList.remove("quzControl");
      restartButton.classList.add("quzControl");
      /*restartButton.style.display = 'none';*/
    }
    if(currentSlide === slides.length-1){
      /*nextButton.style.display = 'none';*/
      nextButton.classList.add("quzControl");
      submitButton.classList.remove("quzControl");
      /*submitButton.style.display = 'inline-block';*/
    }
    else{
      /*nextButton.style.display = 'inline-block';*/
      nextButton.classList.remove("quzControl");
      submitButton.classList.add("quzControl");
      /*submitButton.style.display = 'none';*/
    }
    pagesContainer.innerText = "Questions: " + (n + 1) + " / " + slides.length;
    goToTop.scrollTop = 0;
    goToTop.scrollLeft=0;
  }

  function showNextSlide() {
   if(paused) showSlide(currentSlide + 1);
  }

  function showPreviousSlide() {
   if(paused) showSlide(currentSlide - 1);
  }

  function showAnswer() {
    if(!paused) return;
    for (var i = 0; i < slides[currentSlide].children.length; i++) {
        if (slides[currentSlide].children[i].className == "explanation hidden") {
          slides[currentSlide].children[i].classList.remove("hidden");
          checkAnswer(myQuestions[currentSlide + _beginOfQuesions], currentSlide)
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
      if (confirm("Restart the quiz?") != true) {
        return
      }
      currentSlide = 0;
      quizStarted = false;
      paused = true;
      clearTimeout(timer);
      nextButton.classList.add("quzControl");
      submitButton.classList.add("quzControl");
      previousButton.classList.add("quzControl");
      answerButton.classList.add("quzControl");
      document.getElementById("config").classList.remove("quzControl");
      document.getElementById("pages").innerHTML = "";
      restartButton.classList.add("quzControl");
      /*restartButton.style.display = 'none';*/
      // Show empty slide
      slidesContainer[0].style.height = '0%';
      slidesContainer[0].innerHTML=`<div id="quiz"></div>`;
      //showSlide(currentSlide);
      timerTxt.textContent = "No limit";
      document.getElementById("showTimer").style = "display:none"

      initPage();
      resultsContainer.innerHTML = ""
      selectedQuestionContainer.innerText = ""
  }

  function buildQuiz(){
    document.getElementById("loader").style.display = "block";
    document.body.style.cursor = "wait";
    let timeout_in_ms = 100;
    setTimeout(function(){ //wait for few ms to render the waiting animation
          if(randomQuestion.checked){
              myQuestions = shuffle(myQuestions)
          }
          if(numberOfQuestion.value > myQuestions.length || numberOfQuestion.value < 0 || numberOfQuestion.value == ''){
              numberOfQuestion.value = myQuestions.length;
          }
          if(startOfQuestion.value > myQuestions.length || startOfQuestion.value < 0 || startOfQuestion.value == ''){
              startOfQuestion.value = 0;
          }
          if(endOfQuestion.value > myQuestions.length || endOfQuestion.value < 0 || endOfQuestion.value == ''){
              endOfQuestion.value = myQuestions.length
          }
          if(startOfQuestion.value != '' && endOfQuestion.value != ''){
              if(numberOfQuestion.value == '' || numberOfQuestion.value == myQuestions.length){
                  numberOfQuestion.value = Math.abs(startOfQuestion.value - endOfQuestion.value)
                  if(numberOfQuestion.value < 0){
                      numberOfQuestion.value = myQuestions.length;
                  }
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
          selectedQuestionContainer = document.getElementById('selection');
          submitButton = document.getElementById('submit');
          answerButton = document.getElementById('answer');
          restartButton = document.getElementById('restart');
          slidesContainer = document.getElementsByClassName("quiz-container")

          nOfQuesions = parseInt(startOfQuestion.value) + parseInt(numberOfQuestion.value)
          if(nOfQuesions > myQuestions.length){
             nOfQuesions = myQuestions.length;
          }
          _beginOfQuesions = parseInt(startOfQuestion.value);
          if (_beginOfQuesions > 0){
              _beginOfQuesions--;
          }

          prepareQuiz();
          prepareImgs();
          // gather answer containers from our quiz
          answerContainers = quizContainer.querySelectorAll('.answers');


          // Pagination
          previousButton = document.getElementById("previous");
          nextButton = document.getElementById("next");

          // Event listeners
          submitButton.addEventListener('click', showResults);
          previousButton.addEventListener("click", showPreviousSlide);
          nextButton.addEventListener("click", showNextSlide);
          if(!hideAnserBtn.checked){
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
          // Show the first slide
          document.getElementById("loader").style.display = "none";
          document.body.style.cursor = "auto";
          if(_beginOfQuesions != 0 || nOfQuesions != myQuestions.length){
              if(randomQuestion.checked){
                  selectedQuestionContainer.innerText = "Selected random questions";
              }else{
                  selectedQuestionContainer.innerText = "Selected questions between " + (_beginOfQuesions + 1) + " and " + (slides.length + _beginOfQuesions);
              }
          }
          goToTop = document.getElementsByClassName("quiz-container")[0];
          showSlide(currentSlide);
          setTimeout(function(){quizStarted = true;}, timeout_in_ms/10)
    }, timeout_in_ms);
  }

function timedCount(){
    if(paused){
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
    }else{
        timer = setTimeout(function(){
            timedCount()
        },1000);
    }
}

var countDown=-1; //time in seconds
var timer;
var paused = true;

// Variables
var quizContainer;
var resultsContainer;
var pagesContainer;
var selectedQuestionContainer;
var submitButton;
var answerButton;
var restartButton;

var answerContainers;
var previousButton;
var nextButton;
var slides;
var goToTop;

var randomQuestion;
var randomAnswer;
var hideAnserBtn;
var numberOfQuestion;
var startOfQuestion;
var endOfQuestion;
var startQuiz;

var timerTxt;

var slidesContainer;

var quizStarted = false;

let currentSlide = 0;
var _beginOfQuesions;
var nOfQuesions;

// Get the modal
var modal = document.getElementById("myModal");
// Get the image and insert it inside the modal - use its "alt" text as a caption
var modalImg = document.getElementById("img01");
var captionText = document.getElementById("caption");

// Get the <span> element that closes the modal
var span = document.getElementsByClassName("close")[0];

function initPage(){
      // Quiz settings
      startQuiz = document.getElementById("start");
      randomQuestion = document.getElementById("random");
      randomAnswer = document.getElementById("random_answ");
      hideAnserBtn = document.getElementById("hide_answer_btn");
      numberOfQuestion = document.getElementById("n_of_que");
      numberOfQuestion.value = myQuestions.length;
      startOfQuestion = document.getElementById("start_of_que");
      endOfQuestion = document.getElementById("end_of_que");
      countDown = document.getElementById("timeInmunites");
      timerTxt = document.getElementById("timer");
      // Kick things off
      //buildQuiz();
      if(myQuestions.length != 0){
          startQuiz.addEventListener('click', buildQuiz);
      }else{
            showError();
            return;
      }
      document.getElementById("loader").style.display = "none";
}

function showError(){
    document.getElementById("loader").style.display = "none";
    document.getElementById("error_loader").style.display = "block";
    numberOfQuestion = document.getElementById("n_of_que");
    numberOfQuestion.style.color = 'red'; // color the answers red
    numberOfQuestion.type = 'text';
    numberOfQuestion.value = "Error loading quiz";
    alert("Something went wrong! :(")
}

if (location.protocol == 'http:' ||  location.protocol == 'https:'){
    var xmlhttp = new XMLHttpRequest();
    var cource = document.getElementById("cid").value;
    var dump = document.getElementById("dump").value;
    var url = `./get?courseID=${cource}&examID=${dump}`;

    xmlhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
            myQuestions = JSON.parse(this.responseText)['dump'];
            initPage();
        }else if (this.readyState == 4 && this.status != 200){
            showError()
        }
    };
    xmlhttp.open("GET", url, true);
    document.getElementById("loader").style.display = "block";
    xmlhttp.send();
}else if (location.protocol == 'file:'){
    // Quiz settings
    document.getElementById("loader").style.display = "block";
    let timeout_in_ms = 1000; //1 second
    setTimeout(function(){ //wait for few ms to render the waiting animation
          initPage();
    }, timeout_in_ms);
}else{
    alert("Failed to init the quiz.")
}

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
        if(event.target.children.length == 0){
            event.target.style.border = "";
        }else{
            event.target.style.border = "hidden";
        }
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
        let slideId = _beginOfQuesions + currentSlide;
        if (targetDiv.childElementCount != 0){
            let childP = targetDiv.getElementsByTagName("span")[0];
            document.getElementById("drag_drop-answer_slide"+slideId).appendChild(childP);
        }
        targetDiv.appendChild(dragP);
        dragP = null;
        dragTaggets = document.getElementsByClassName("slide active-slide")[0].getElementsByClassName("question_box")[0].getElementsByClassName("droptarget")
        for(let i = 0; i < dragTaggets.length; i++){
            if(dragTaggets[i].children.length == 0){
                dragTaggets[i].style.removeProperty('border');
            }
        }
    }
});

document.onkeydown = function(evt) {
    if(!quizStarted){return};
    evt = evt || window.event;
    switch(evt.keyCode){
        case 37: showPreviousSlide(); evt.preventDefault(); return; //left arrow
        case 39: showNextSlide(); evt.preventDefault(); return; //rigth arrow
        case 13:                                                                        //enter
        case 32: if(!hideAnserBtn.checked){showAnswer();} evt.preventDefault(); return; //spacebar
        default: if(event.ctrlKey && event.altKey && evt.key === "d"){
            var selection = parseInt(prompt("Jump to question:", "Type a number!"), 10);
            if (isNaN(selection)){
              alert('Type a number');
            } else {
              debug_showSlide(selection)
            }
        }else if(event.ctrlKey && event.altKey && evt.key === "r"){
            restartQuiz()
        }else if(event.ctrlKey && event.altKey && evt.key === "p"){
            if(countDown != -1) {
                paused = !paused;
                timerTxt.textContent = "Paused!";
            }
        }
    }
};
