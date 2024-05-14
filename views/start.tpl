<html lang="en" class="">
	<head>
	  <meta charset="UTF-8">
	  <title>Dump {{cid + " " + dump}}</title>
	  <meta name="robots" content="noindex">
	  <link rel='stylesheet' href='/static/style.css'>
	</head>
	<body>
		<input type="hidden" id="cid" value="{{cid}}">
		<input type="hidden" id="dump" value="{{dump}}">
		<h1><a href="/" id="homeLink">Home</a> <b>|</b> Dump {{cid + " " + dump}}</h1>
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
		<script src="/static/quiz.js"></script>
	</body>
</html>