<html lang="en" class="">
	<head>
	  <meta charset="UTF-8">
	  <title>Dump {{cid + " " + dump}}</title>
	  <meta name="robots" content="noindex">
	  <link rel='stylesheet' href='/static/style.css'>
	  <meta name="viewport" content="width=device-width, initial-scale=1">
	  <meta http-equiv="content-language" content="en">
	</head>
	<body>
	<div class="right-sidebar-grid">
	    <header class="header">
			<input type="hidden" id="cid" value="{{cid}}">
			<input type="hidden" id="dump" value="{{dump}}">
			<h1><a href="/" id="homeLink">Home</a> <b>|</b> Dump {{cid + " " + dump}}</h1>
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
				<label>Randomize question:</label><input type="checkbox" id="random"><span>&nbsp;&nbsp;&nbsp;&nbsp;</span>
				<label>Exsam mode:</label><input type="checkbox" id="hide_answer_btn"><br>
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
		<script src="/static/quiz.js"></script>
	</div>
	</body>
</html>
% include('footer.tpl')