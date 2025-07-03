function changeAnswerType(selct){
    var ansArea = document.getElementById("answers_area")
    var selected = selct.value
    var newHtml = ""
	if(selct.children[0].value == '-1' && selected != '-1'){
		selct.removeChild(selct.children[0]);
        ansArea.innerHTML = newHtml;
        document.getElementById("noQuestion").value = 0;
	}
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
	newHtml_withgroup = newHtml
	var countStr = ""
	if (document.getElementById("questionType").value == "3"){
		countStr = `Count:<input type="number" value="1" min="1" max="99">`;
	}
    for(let i = 0; i < lines.length; i++){
        newHtml += `<div class="showinline">`;
		if (type != -1) newHtml += `<span><input type="`+ type + `" name="chBoxGrup"/>`;


		newHtml += `</span><input type="text" class="textAns" style = "width: 100%;" value="` + lines[i].children[1].value + `">`+countStr;
		newHtml += `</div><br>`;
		
        newHtml_withgroup += `<div class="showinline">`;
		if (type != -1) newHtml_withgroup += `<span><input type="`+ type + `" name="chBoxGrup"/>`;
		newHtml_withgroup += `</span><input type="text" class="textAns" style = "width: 100%;" value="` + lines[i].children[1].value + `">Group:<input type="number" value="`+ i +`" min="0" max="99">`;
        newHtml_withgroup += `</div><br>`;
    }
    if(lines.length < numLines){
        var lineToAdd = numLines - lines.length;
        for(let i = 0; i < lineToAdd; i++){
        newHtml += `<div class="showinline">`;
        if (type != -1) newHtml += `<span><input type="`+ type + `" name="chBoxGrup"/>`;
		newHtml += `</span><input type="text" class="textAns" style = "width: 100%;" value="">`+countStr;
		newHtml += `</div><br>`;
		
        newHtml_withgroup += `<div class="showinline">`;
        if (type != -1) newHtml_withgroup += `<span><input type="`+ type + `" name="chBoxGrup"/>`;
        newHtml_withgroup += `</span><input type="text" class="textAns" style = "width: 100%;" value="">Group:<input type="number" value="`+ i +`" min="0" max="99">`;
        newHtml_withgroup += `</div><br>`;
        }
    }
	if (type == -1) {
		newHtml = `<div id="select_answers"><p>Selectable answers</p>` + newHtml + `</div><div id="correct_answers"><p>Correct answers</p>` + newHtml_withgroup + `</div>`
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
		var countStr = ""
		if (document.getElementById("questionType").value == "3"){
			countStr = `Count:<input type="number" value="1" min="1" max="99">`;
		}
        for(let j = 0; j<linesHolders.length; j++){
			numLines = parseInt(numLines);
			lines = linesHolders[j].getElementsByClassName("showinline");
			if(lines.length < numLines){
				var lineToAdd = numLines - lines.length;
				var newHtml = `<p>` + linesHolders[j].children[0].innerHTML + `</p>`;
				for(let i = 0; i < numLines; i++){
					if(lines.length > i){
						var old_value = lines[i].childNodes[0].value;
					}else{
						var old_value = "";
					}
					newHtml += `<div class="showinline">`;
					if(j == 1){
						newHtml += `<input type="text" class="textAns" style = "width: 100%;" value="${old_value}">Group:<input type="number" value="`+ (numLines + i - 1) +`" min="0" max="99">`;
					}else{
						newHtml += `<input type="text" class="textAns" style = "width: 100%;" value="${old_value}">`+countStr;
					}
					newHtml += `</div><br>`;
				}
			}else{
				var newHtml = `<p>` + linesHolders[j].children[0].innerHTML + `</p>`;
				for(let i = 0; i < numLines; i++){
					newHtml += `<div class="showinline">`;
					newHtml += lines[i].innerHTML;
					newHtml += `</div><br>`;
				}
			}
			linesHolders[j].innerHTML = newHtml
		}
		return;
		/*newHtml = ``;
		for(let i = 0; i<linesHolders.length; i++){
			newHtml += linesHolders[i];
		}*/
	}else{
		lines = ansArea.getElementsByClassName("showinline");
		if(lines.length != 0){
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
				for(let i = 0; i < lines.length; i++){
					newHtml = newHtml.replace(`value=""`, `value="${lines[i].childNodes[1].value}"`);
				}
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
					newHtml += lines[i].innerHTML.replace(`value=""`, `value="${lines[i].childNodes[1].value}"`);
					newHtml += `</div><br>`;
				}
			}
		}else{
			return;
		}
	}
    ansArea.innerHTML = newHtml;
}