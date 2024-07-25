function changeAnswerType(selct){
    var ansArea = document.getElementById("answers_area")
    var selected = selct.value
    var newHtml = ""
    if(selected == '0'){ //freetext
        newHtml += `<input type="text" id="freeTextAns" style = "width: 100%;" value="">`;
        ansArea.innerHTML = newHtml;
        document.getElementById("noQuestion").value = 0;
        return;
    } else if(selected == '1'){ //one choice
        var type = "radio"
    } else if(selected == '2'){ //multiple
        var type = "checkbox"
    } else{ //drag-n-drop
		var type = -1;
	}
    var numLines = document.getElementById("noQuestion").value;
	if(document.getElementById("select_answers") == null){ //Drag-drop answers
		lines = ansArea.getElementsByClassName("showinline");
	}else{
		lines = []
	}
    if (numLines <= 0){
        numLines = 4;
        document.getElementById("noQuestion").value = 4;
    }
    for(let i = 0; i < lines.length; i++){
        newHtml += `<div class="showinline">`;
		if (type != -1) newHtml += `<span><input type="`+ type + `" name="chBoxGrup"/>`;
		newHtml += `</span><input type="text" class="textAns" style = "width: 100%;" value="` + lines[i].children[1].value + `">`;
        newHtml += `</div><br>`;
    }
    if(lines.length < numLines){
        var lineToAdd = numLines - lines.length;
        for(let i = 0; i < lineToAdd; i++){
        newHtml += `<div class="showinline">`;
        if (type != -1) newHtml += `<span><input type="`+ type + `" name="chBoxGrup"/>`;
        newHtml += `</span><input type="text" class="textAns" style = "width: 100%;" value="">`;
        newHtml += `</div><br>`;
        }
    }
	if (type == -1) {
		newHtml = `<div id="select_answers"><p>Selectable answers</p>` + newHtml + `</div><div id="correct_answers"><p>Correct answers</p>` + newHtml + `</div>`
	}
    ansArea.innerHTML = newHtml;
}

function changeAnswerCount(){
    var ansArea = document.getElementById("answers_area");
    var numLines = document.getElementById("noQuestion").value;
	if(document.getElementById("select_answers") != null){ //Drag-drop answers
		linesHolders = [document.getElementById("select_answers"), document.getElementById("correct_answers")];
		lines = linesHolders[0].getElementsByClassName("showinline"); //Selectable options. More options to select then the questions
		if (numLines <= 0){
			numLines = 1;
		}
        for(let i = 0; i<linesHolders.length; i++){
			lines = linesHolders[i].getElementsByClassName("showinline");
			if(lines.length < numLines){
				var lineToAdd = numLines - lines.length;
				var newHtml = linesHolders[i].innerHTML;
				for(let i = 0; i < lineToAdd; i++){
					newHtml += `<div class="showinline">`;
					newHtml += `</span><input type="text" class="textAns" style = "width: 100%;" value="">`;
					newHtml += `</div><br>`;
				}
			}else{
				var newHtml = `<p>` + linesHolders[i].firstChild.innerHTML + `</p>`;
				for(let i = 0; i < numLines; i++){
					newHtml += `<div class="showinline">`;
					newHtml += lines[i].innerHTML;
					newHtml += `</div><br>`;
				}
			}
			linesHolders[i].innerHTML = newHtml
		}
		return;
		/*newHtml = ``;
		for(let i = 0; i<linesHolders.length; i++){
			newHtml += linesHolders[i];
		}*/
	}else{
		lines = ansArea.getElementsByClassName("showinline");
		var type = lines[0].children[0].firstChild.type;
		if(type == 'checkbox'){
			if(numLines<3){ //In multiple choise we need at least 3
				numLines = 3;
			}
		}else{
			if(numLines < 2){ //In single choise we need at least 2
				numLines = 2;
			}
		}

		if (numLines <= 0){
			numLines = 4;
		}
		if(lines.length < numLines){
			var lineToAdd = numLines - lines.length;
			var newHtml = ansArea.innerHTML;
			for(let i = 0; i < lineToAdd; i++){
			newHtml += `<div class="showinline">`;
			newHtml += `<span><input type="`+ type + `" name="chBoxGrup"/>`;
			newHtml += `</span><input type="text" class="textAns" style = "width: 100%;" value="">`;
			newHtml += `</div><br>`;
			}
		}else{
			var newHtml = "";
			for(let i = 0; i < numLines; i++){
			newHtml += `<div class="showinline">`;
			newHtml += lines[i].innerHTML;
			newHtml += `</div><br>`;
			}
		}
	}
    ansArea.innerHTML = newHtml;
}