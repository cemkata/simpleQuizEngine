<html lang="en" class="">
	<head>
	  <meta charset="UTF-8">
% if defined('OFFLINE'):
	  <title>Exam - {{tittle}}</title>
% else:
	  <title>Dump {{cid + " " + dump}}</title>
% end #% if defined('OFFLINE'):
	  <meta name="robots" content="noindex">
% if defined('OFFLINE'):
<style>
% include('static/style.css')
</style>
% else:
	  <link rel='stylesheet' href='/static/style.css'>
% end #% if defined('OFFLINE'):
	  <meta name="viewport" content="width=device-width, initial-scale=1">
	  <meta http-equiv="content-language" content="en">
	</head>
	<body>
	<div class="right-sidebar-grid">
	    <header class="header">
% if defined('OFFLINE'):
			<h1>Exam - {{tittle}}</h1>
% else:
			<input type="hidden" id="cid" value="{{cid}}">
			<input type="hidden" id="dump" value="{{dump}}">
			<h1><a href="./showDumps?courseID={{cid}}" id="homeLink">Home</a> <b>|</b> Dump {{cid + " " + dump}}</h1>
% end #% if defined('OFFLINE'):
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
			  <div id="error_loader">
					<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1" width="120" height="120" viewBox="0 0 256 256" xml:space="preserve">
					<defs>
					</defs>
					<g style="stroke: none; stroke-width: 0; stroke-dasharray: none; stroke-linecap: butt; stroke-linejoin: miter; stroke-miterlimit: 10; fill: none; fill-rule: nonzero; opacity: 1;" transform="translate(1.4065934065934016 1.4065934065934016) scale(2.81 2.81)" >
						<path d="M 28.5 65.5 c -1.024 0 -2.047 -0.391 -2.829 -1.172 c -1.562 -1.562 -1.562 -4.095 0 -5.656 l 33 -33 c 1.561 -1.562 4.096 -1.562 5.656 0 c 1.563 1.563 1.563 4.095 0 5.657 l -33 33 C 30.547 65.109 29.524 65.5 28.5 65.5 z" style="stroke: none; stroke-width: 1; stroke-dasharray: none; stroke-linecap: butt; stroke-linejoin: miter; stroke-miterlimit: 10; fill: rgb(236,0,0); fill-rule: nonzero; opacity: 1;" transform=" matrix(1 0 0 1 0 0) " stroke-linecap="round" />
						<path d="M 61.5 65.5 c -1.023 0 -2.048 -0.391 -2.828 -1.172 l -33 -33 c -1.562 -1.563 -1.562 -4.095 0 -5.657 c 1.563 -1.562 4.095 -1.562 5.657 0 l 33 33 c 1.563 1.562 1.563 4.095 0 5.656 C 63.548 65.109 62.523 65.5 61.5 65.5 z" style="stroke: none; stroke-width: 1; stroke-dasharray: none; stroke-linecap: butt; stroke-linejoin: miter; stroke-miterlimit: 10; fill: rgb(236,0,0); fill-rule: nonzero; opacity: 1;" transform=" matrix(1 0 0 1 0 0) " stroke-linecap="round" />
						<path d="M 45 90 C 20.187 90 0 69.813 0 45 C 0 20.187 20.187 0 45 0 c 24.813 0 45 20.187 45 45 C 90 69.813 69.813 90 45 90 z M 45 8 C 24.598 8 8 24.598 8 45 c 0 20.402 16.598 37 37 37 c 20.402 0 37 -16.598 37 -37 C 82 24.598 65.402 8 45 8 z" style="stroke: none; stroke-width: 1; stroke-dasharray: none; stroke-linecap: butt; stroke-linejoin: miter; stroke-miterlimit: 10; fill: rgb(236,0,0); fill-rule: nonzero; opacity: 1;" transform=" matrix(1 0 0 1 0 0) " stroke-linecap="round" />
					</g>
					</svg>
			  </div>
				<label class="tooltip_hidden">Randomize questions:<span class="tooltiptext">Important once enabled can not be disbaled until page is reload!</span></label><input type="checkbox" id="random"><span>&nbsp;&nbsp;&nbsp;&nbsp;</span>
				<label class="tooltip_hidden">Randomize answers:<span class="tooltiptext">Important once enabled can not be disbaled until page is reload!</span></label><input type="checkbox" id="random_answ"><span>&nbsp;&nbsp;&nbsp;&nbsp;</span>
				<label class="tooltip_hidden">Exsam mode:<span class="tooltiptext">Hides the check answer button.</span></label><input type="checkbox" id="hide_answer_btn">
				<button id="showHelp" class="tooltip_hidden">Show Help<div class="tooltiptext">Keyboard short-cuts:<br><br>ALT+CTRL+R restarts the quiz<br><br>ALT+CTRL+P pause/unpause the quiz (if time limit is set)<br><br>ALT+CTRL+D allows jumps to question (mostly for debug)<br><br>ALT+CTRL+E open current question in editor (disabled in exsam mode)<br><br>Space/Enter show the answer (disabled in exsam mode)<br><br>Left/rigth arrow move between questions</div></button><br>
				<label class="tooltip_hidden">How many questions:<span class="tooltiptext">Mostly used with 'Random questions'.</span></label><input type="number" id="n_of_que"><br>
				<label class="tooltip_hidden">Starting question:<span class="tooltiptext">The questions start at 0.</span></label><input type="number" id="start_of_que"><br>
				<label class="tooltip_hidden">Ending question:<span class="tooltiptext">Togethers with Starting question you can select questions between the two.</span></label><input type="number" id="end_of_que"><br>
				<label class="tooltip_hidden">Time in minutes:<span class="tooltiptext">Duration of the quiz, before automatic submit.</span></label><input type="number" min="0" id="timeInmunites">
				<button id="start">Start Quiz</button>


			</div>
		</div>
		</main>
<!-- The Modal -->
<div id="myModal" class="modal">
  <span class="close">&times;</span>
  <img class="modal-content" id="img01">
  <div id="caption"></div>
</div>
		<section class="right-sidebar">
			<h4 style="display:none" align="center" id="showTimer"><span id="iTimeShow">Time Remaining: </span><br/><span id='timer' style="font-size:25px;">No limit</span></h4>
			<br>
			<div id="selection"></div>
			<br>
			<div id="pages"></div>
			<div id="results"></div>
		</section>
% if defined('OFFLINE'):
<script>
% include('static/quiz.js')
</script>
<script>
myQuestions = {{!json_Output['dump']}};
</script>
% else:
<script src="/static/quiz.js"></script>
% end #% if defined('OFFLINE'):
	</div>
	</body>
</html>
% include('footer.tpl')