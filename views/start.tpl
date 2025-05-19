<!DOCTYPE html>
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
			<div id="quiz-controls">
				<button class="quzControl" id="restart">Restart quiz</button>
				<button class="quzControl" id="previous">Previous Question</button>
				<!-- if this button is hidden the answer is not shown -->
				<button class="quzControl" id="answer">Show answer</button>
				<button class="quzControl" id="next">Next Question</button>
				<button class="quzControl" id="submit">Submit Quiz</button>
			</div>
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
			  % if page_config['Display_GUI']:
			    % cssHidden = '''style="display:none !important;"'''
			  %else:
			    % cssHidden = ''' '''
			  % end #% if page_config['Display_GUI']:
			    <div  {{!cssHidden}}>
					<button class="accordion">
						<svg xmlns="http://www.w3.org/2000/svg"  xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1" width="18" height="19" viewBox="0 0 18 19" fill="none"><path d="M9 19C8.26102 19 7.5485 18.9053 6.86829 18.7449C6.72645 18.7113 6.59839 18.6339 6.50182 18.5234C6.40524 18.4129 6.34492 18.2747 6.32918 18.1279L6.17999 16.7493C6.1312 16.2976 5.87374 15.8978 5.48529 15.6704C5.09761 15.4433 4.62705 15.4182 4.21669 15.6008H4.21578L2.96641 16.1583C2.83315 16.2178 2.68497 16.2338 2.54233 16.2042C2.39969 16.1747 2.26963 16.1009 2.17011 15.9932C1.19888 14.9437 0.453474 13.6728 0.0301591 12.2544C-0.0120073 12.1133 -0.00991206 11.9623 0.0361556 11.8224C0.0822233 11.6825 0.169993 11.5605 0.287356 11.4733L1.39577 10.6495C1.75772 10.3797 1.97057 9.95467 1.97057 9.5C1.97057 9.04509 1.75772 8.61966 1.39577 8.35054L0.287356 7.52764C0.169993 7.44043 0.0822233 7.31845 0.0361556 7.17853C-0.00991206 7.03862 -0.0120073 6.88766 0.0301591 6.74648C0.453429 5.32823 1.19824 4.05645 2.17011 3.00679C2.26973 2.89923 2.39985 2.82566 2.54248 2.79625C2.68511 2.76684 2.83324 2.78303 2.96641 2.84258L4.21578 3.40015C4.62633 3.58316 5.09734 3.55683 5.48529 3.32964C5.87374 3.10215 6.1312 2.70245 6.17999 2.25068L6.32918 0.87207C6.34504 0.725588 6.40531 0.58769 6.50169 0.477369C6.59808 0.367046 6.72584 0.289724 6.86737 0.256056C7.54789 0.0950737 8.26102 0 9 0C9.73898 0 10.4515 0.0947285 11.1317 0.255127C11.2736 0.288685 11.4016 0.36607 11.4982 0.476587C11.5948 0.587105 11.6551 0.7253 11.6708 0.87207L11.82 2.25068C11.8688 2.70245 12.1263 3.10215 12.5147 3.32964C12.9024 3.55667 13.373 3.58274 13.7833 3.40015L15.0336 2.84258C15.1668 2.78303 15.3149 2.76684 15.4575 2.79625C15.6002 2.82566 15.7303 2.89923 15.8299 3.00679C16.8011 4.0563 17.5465 5.32808 17.9698 6.74648C18.012 6.88766 18.0099 7.03862 17.9638 7.17853C17.9178 7.31845 17.83 7.44043 17.7126 7.52764L16.6042 8.35054C16.2423 8.61966 16.0294 9.04509 16.0294 9.5C16.0294 9.95491 16.2423 10.3803 16.6042 10.6495L17.7126 11.4724C17.83 11.5596 17.9178 11.6816 17.9638 11.8215C18.0099 11.9614 18.012 12.1123 17.9698 12.2535C17.5465 13.6719 16.8011 14.9437 15.8299 15.9932C15.7303 16.1008 15.6002 16.1743 15.4575 16.2037C15.3149 16.2332 15.1668 16.217 15.0336 16.1574L13.7833 15.5999C13.373 15.4173 12.9024 15.4433 12.5147 15.6704C12.1263 15.8978 11.8688 16.2976 11.82 16.7493L11.6708 18.1279C11.655 18.2744 11.5947 18.4123 11.4983 18.5226C11.4019 18.633 11.2742 18.7103 11.1326 18.7439C10.4521 18.9049 9.73898 19 9 19ZM9 17.575C9.45659 17.575 9.89504 17.4919 10.3345 17.4136L10.4224 16.5944C10.5198 15.6924 11.0371 14.8901 11.8118 14.4365C12.587 13.9825 13.5307 13.9303 14.3499 14.2955L15.0931 14.6267C15.6638 13.932 16.1156 13.1474 16.4312 12.2878L15.7722 11.798C15.0507 11.2615 14.6235 10.4074 14.6235 9.5C14.6235 8.59261 15.0507 7.73848 15.7722 7.202L16.4312 6.71216C16.1156 5.85256 15.6638 5.06797 15.0931 4.37334L14.3499 4.70454C13.5307 5.06968 12.587 5.01749 11.8118 4.56353C11.0371 4.10986 10.5198 3.3076 10.4224 2.40561L10.3345 1.58643C9.89508 1.50829 9.45636 1.425 9 1.425C8.54341 1.425 8.10496 1.50807 7.66551 1.58643L7.57764 2.40561C7.48022 3.3076 6.96291 4.10986 6.18823 4.56353C5.41304 5.01749 4.46926 5.06968 3.65013 4.70454L2.90692 4.37334C2.33609 5.06787 1.88432 5.85249 1.56876 6.71216L2.22777 7.202C2.94929 7.73848 3.37646 8.59261 3.37646 9.5C3.37646 10.4074 2.94894 11.2621 2.22777 11.7989L1.56876 12.2888C1.8845 13.1487 2.33678 13.9328 2.90783 14.6276L3.65013 14.2964C4.46926 13.9312 5.41304 13.9825 6.18823 14.4365C6.96291 14.8901 7.48022 15.6924 7.57764 16.5944L7.66551 17.4136C8.10492 17.4917 8.54364 17.575 9 17.575ZM9 13.3C6.93779 13.3 5.25097 11.5902 5.25097 9.5C5.25097 7.40976 6.93779 5.7 9 5.7C11.0622 5.7 12.749 7.40976 12.749 9.5C12.749 11.5902 11.0622 13.3 9 13.3ZM9 11.875C10.3024 11.875 11.3431 10.8201 11.3431 9.5C11.3431 8.17988 10.3024 7.125 9 7.125C7.69759 7.125 6.65686 8.17988 6.65686 9.5C6.65686 10.8201 7.69759 11.875 9 11.875Z" fill="black"/></svg> 
						Gui settings 
						<svg xmlns="http://www.w3.org/2000/svg"  xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1" width="18" height="19" viewBox="0 0 18 19" fill="none"><path d="M9 19C8.26102 19 7.5485 18.9053 6.86829 18.7449C6.72645 18.7113 6.59839 18.6339 6.50182 18.5234C6.40524 18.4129 6.34492 18.2747 6.32918 18.1279L6.17999 16.7493C6.1312 16.2976 5.87374 15.8978 5.48529 15.6704C5.09761 15.4433 4.62705 15.4182 4.21669 15.6008H4.21578L2.96641 16.1583C2.83315 16.2178 2.68497 16.2338 2.54233 16.2042C2.39969 16.1747 2.26963 16.1009 2.17011 15.9932C1.19888 14.9437 0.453474 13.6728 0.0301591 12.2544C-0.0120073 12.1133 -0.00991206 11.9623 0.0361556 11.8224C0.0822233 11.6825 0.169993 11.5605 0.287356 11.4733L1.39577 10.6495C1.75772 10.3797 1.97057 9.95467 1.97057 9.5C1.97057 9.04509 1.75772 8.61966 1.39577 8.35054L0.287356 7.52764C0.169993 7.44043 0.0822233 7.31845 0.0361556 7.17853C-0.00991206 7.03862 -0.0120073 6.88766 0.0301591 6.74648C0.453429 5.32823 1.19824 4.05645 2.17011 3.00679C2.26973 2.89923 2.39985 2.82566 2.54248 2.79625C2.68511 2.76684 2.83324 2.78303 2.96641 2.84258L4.21578 3.40015C4.62633 3.58316 5.09734 3.55683 5.48529 3.32964C5.87374 3.10215 6.1312 2.70245 6.17999 2.25068L6.32918 0.87207C6.34504 0.725588 6.40531 0.58769 6.50169 0.477369C6.59808 0.367046 6.72584 0.289724 6.86737 0.256056C7.54789 0.0950737 8.26102 0 9 0C9.73898 0 10.4515 0.0947285 11.1317 0.255127C11.2736 0.288685 11.4016 0.36607 11.4982 0.476587C11.5948 0.587105 11.6551 0.7253 11.6708 0.87207L11.82 2.25068C11.8688 2.70245 12.1263 3.10215 12.5147 3.32964C12.9024 3.55667 13.373 3.58274 13.7833 3.40015L15.0336 2.84258C15.1668 2.78303 15.3149 2.76684 15.4575 2.79625C15.6002 2.82566 15.7303 2.89923 15.8299 3.00679C16.8011 4.0563 17.5465 5.32808 17.9698 6.74648C18.012 6.88766 18.0099 7.03862 17.9638 7.17853C17.9178 7.31845 17.83 7.44043 17.7126 7.52764L16.6042 8.35054C16.2423 8.61966 16.0294 9.04509 16.0294 9.5C16.0294 9.95491 16.2423 10.3803 16.6042 10.6495L17.7126 11.4724C17.83 11.5596 17.9178 11.6816 17.9638 11.8215C18.0099 11.9614 18.012 12.1123 17.9698 12.2535C17.5465 13.6719 16.8011 14.9437 15.8299 15.9932C15.7303 16.1008 15.6002 16.1743 15.4575 16.2037C15.3149 16.2332 15.1668 16.217 15.0336 16.1574L13.7833 15.5999C13.373 15.4173 12.9024 15.4433 12.5147 15.6704C12.1263 15.8978 11.8688 16.2976 11.82 16.7493L11.6708 18.1279C11.655 18.2744 11.5947 18.4123 11.4983 18.5226C11.4019 18.633 11.2742 18.7103 11.1326 18.7439C10.4521 18.9049 9.73898 19 9 19ZM9 17.575C9.45659 17.575 9.89504 17.4919 10.3345 17.4136L10.4224 16.5944C10.5198 15.6924 11.0371 14.8901 11.8118 14.4365C12.587 13.9825 13.5307 13.9303 14.3499 14.2955L15.0931 14.6267C15.6638 13.932 16.1156 13.1474 16.4312 12.2878L15.7722 11.798C15.0507 11.2615 14.6235 10.4074 14.6235 9.5C14.6235 8.59261 15.0507 7.73848 15.7722 7.202L16.4312 6.71216C16.1156 5.85256 15.6638 5.06797 15.0931 4.37334L14.3499 4.70454C13.5307 5.06968 12.587 5.01749 11.8118 4.56353C11.0371 4.10986 10.5198 3.3076 10.4224 2.40561L10.3345 1.58643C9.89508 1.50829 9.45636 1.425 9 1.425C8.54341 1.425 8.10496 1.50807 7.66551 1.58643L7.57764 2.40561C7.48022 3.3076 6.96291 4.10986 6.18823 4.56353C5.41304 5.01749 4.46926 5.06968 3.65013 4.70454L2.90692 4.37334C2.33609 5.06787 1.88432 5.85249 1.56876 6.71216L2.22777 7.202C2.94929 7.73848 3.37646 8.59261 3.37646 9.5C3.37646 10.4074 2.94894 11.2621 2.22777 11.7989L1.56876 12.2888C1.8845 13.1487 2.33678 13.9328 2.90783 14.6276L3.65013 14.2964C4.46926 13.9312 5.41304 13.9825 6.18823 14.4365C6.96291 14.8901 7.48022 15.6924 7.57764 16.5944L7.66551 17.4136C8.10492 17.4917 8.54364 17.575 9 17.575ZM9 13.3C6.93779 13.3 5.25097 11.5902 5.25097 9.5C5.25097 7.40976 6.93779 5.7 9 5.7C11.0622 5.7 12.749 7.40976 12.749 9.5C12.749 11.5902 11.0622 13.3 9 13.3ZM9 11.875C10.3024 11.875 11.3431 10.8201 11.3431 9.5C11.3431 8.17988 10.3024 7.125 9 7.125C7.69759 7.125 6.65686 8.17988 6.65686 9.5C6.65686 10.8201 7.69759 11.875 9 11.875Z" fill="black"/></svg>
					</button>
					<div class="panel">
						<span><i>Possible settings:</i></span><br>
						<label class="tooltip_hidden">Hide restart answer:<span class="tooltiptext">Hide restart button at the end! (will disable keyboard short cut as well).</span></label><input type="checkbox" id="hide_restart" {{page_config['Hide_restart_answer']}}><span>&nbsp;&nbsp;&nbsp;&nbsp;</span>
						<label class="tooltip_hidden">Show progress bar:<span class="tooltiptext">Hides progress bar.</span></label><input type="checkbox" id="show_progress_bar" {{page_config['Show_progress_bar']}}>
						<br>
						<label class="tooltip_hidden">Show progress as numbers:<span class="tooltiptext">Hides progress like 1/50.</span></label><input type="checkbox" id="show_progress_numbers" {{page_config['Show_progress_as_numbers']}}><span>&nbsp;&nbsp;&nbsp;&nbsp;</span>
						% if not defined('OFFLINE'):
						<label class="tooltip_hidden">Allow edit from quiz:<span class="tooltiptext">ALT+CTRL+E will not open the page in editor.</span></label><input type="checkbox" id="allow_edit" {{page_config['Allow_edit_from_inside_a_quiz']}}>
						% end #% if not defined('OFFLINE'):
					</div>
				</div>
				<label class="tooltip_hidden">Randomize questions:<span class="tooltiptext">Important once enabled can not be disbaled until page is reload!</span></label><input type="checkbox" id="random" {{page_config['Randomize_questions']}} {{page_config['Randomize_questions_read_only']}}><span>&nbsp;&nbsp;&nbsp;&nbsp;</span>
				<label class="tooltip_hidden">Randomize answers:<span class="tooltiptext">Important once enabled can not be disbaled until page is reload!</span></label><input type="checkbox" id="random_answ" {{page_config['Randomize_answers']}} {{page_config['Randomize_answers_read_only']}}><span>&nbsp;&nbsp;&nbsp;&nbsp;</span>
				<label class="tooltip_hidden">Exsam mode:<span class="tooltiptext">Hides the check answer button.</span></label><input type="checkbox" id="hide_answer_btn" {{page_config['Exsam_mode']}} {{page_config['Exsam_mode_read_only']}}>
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
			<div id="myProgress" style="display:none"><div id="myBar">0%</div></div>
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
