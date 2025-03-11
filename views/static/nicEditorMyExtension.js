/* START CONFIG */
var nicUploadOptions = {
	buttons : {
		'upload' : {name : 'Upload Image', type : 'nicUploadButton'}
	}
	
};
/* END CONFIG */

var nicUploadButton = nicEditorAdvancedButton.extend({	
	//nicURI : 'https://api.imgur.com/3/image',
  errorText : 'Failed to upload image',

	addPane : function() {
    if(typeof window.FormData === "undefined") {
      return this.onError("Image uploads are not supported in this browser, use Chrome, Firefox, or Safari instead.");
    }
    this.im = this.ne.selectedInstance.selElm().parentTag('IMG');

    var container = new bkElement('div')
      .setStyle({ padding: '10px' })
      .appendTo(this.pane.pane);

		new bkElement('div')
      .setStyle({ fontSize: '14px', fontWeight : 'bold', paddingBottom: '5px' })
      .setContent('Insert an Image')
      .appendTo(container);

    this.fileInput = new bkElement('input')
      .setAttributes({ 'type' : 'file', 'accept' : 'image/*' })
      .appendTo(container);

    this.progress = new bkElement('progress')
      .setStyle({ width : '100%', display: 'none' })
      .setAttributes('max', 100)
      .appendTo(container);

    this.fileInput.onchange = this.uploadFile.closure(this);
	},

  onError : function(msg) {
    this.removePane();
    alert(msg || "Failed to upload image");
  },

  uploadFile : function() {
    var file = this.fileInput.files[0];
    if (!file || !file.type.match(/image.*/)) {
      this.onError("Only image files can be uploaded");
      return;
    }
    this.fileInput.setStyle({ display: 'none' });
    this.setProgress(0);

    var fd = new FormData(); // https://hacks.mozilla.org/2011/01/how-to-develop-a-html5-image-uploader/
    fd.append("image", file);

    var xhr = new XMLHttpRequest();
    //xhr.open("POST", this.ne.options.uploadImgURI || this.nicURI);
    xhr.open("POST", this.ne.options.uploadImgURI);

    xhr.onload = function() {
      try {
        var data = JSON.parse(xhr.responseText);
      } catch(e) {
        return this.onError();
      }
      if(data.error) {
        return this.onError(data.error);
      }
      this.onUploaded(data);
    }.closure(this);
    xhr.onerror = this.onError.closure(this);
    xhr.upload.onprogress = function(e) {
      this.setProgress(e.loaded / e.total);
    }.closure(this);
    //xhr.setRequestHeader('Authorization', 'Client-ID c37fc05199a05b7');
    xhr.send(fd);
  },

  setProgress : function(percent) {
    this.progress.setStyle({ display: 'block' });
    if(percent < .98) {
      this.progress.value = percent;
    } else {
      this.progress.removeAttribute('value');
    }
  },

  onUploaded : function(options) {
    this.removePane();
    var src = options.link;
    if(!this.im) {
      this.ne.selectedInstance.restoreRng();
      var tmp = 'javascript:nicImTemp();';
      this.ne.nicCommand("insertImage", src);
      this.im = this.findElm('IMG','src', src);
    }
    var w = parseInt(this.ne.selectedInstance.elm.getStyle('width'));
    if(this.im) {
      this.im.setAttributes({
        src : src,
        className : "popImage",
        width : (w && options.width) ? Math.min(w, options.width) : ''
      });
    }
  }
});

if (typeof initPageEditor !== 'undefined'){
  nicEditors.registerPlugin(nicPlugin,nicUploadOptions);
}

var nicCodeOptions = {
	buttons : {
		'table' : {name : 'Insert table', type : 'nicAddTableButton'},
		'xhtml' : {name : 'Edit HTML', type : 'nicCodeButton'},
	}
	
};

var nicCodeButton = nicEditorAdvancedButton.extend({
	width : '350px',
		
	addPane : function() {
		this.addForm({
			'' : {type : 'title', txt : 'Edit HTML'},
			'code' : {type : 'content', 'value' : this.ne.selectedInstance.getContent(), style : {width: '340px', height : '200px'}}
		});
	},
	
	submit : function(e) {
		var code = this.inputs['code'].value;
		this.ne.selectedInstance.setContent(code);
		this.removePane();
	}
});

var nicAddTableButton = nicEditorAdvancedButton.extend({
	addPane : function () {
		this.addForm({
			    '': { type: 'title', txt: 'Insert Table' },
			    'rows': { type: 'text', txt: 'Rows', value: '5', style: { width: '150px'} },
			    'cols': { type: 'text', txt: 'Columns', value: '2', style: { width: '150px'} },
			    'border': { type: 'text', txt: 'Border', value: '1', style: { width: '150px'} },
			    'width': { type: 'text', txt: 'Width', value: '100%', style: { width: '150px'} }
		});
	},
	
	submit: function (e) {
		var rows = parseInt(this.inputs['rows'].value);
		if(isNaN(rows)){
			alert("Check rows value")
			return false;
		}
		var cols = parseInt(this.inputs['cols'].value);
		if(isNaN(cols)){
			alert("Check columns value")
			return false;
		}
		var border = parseInt(this.inputs['border'].value);
		if(isNaN(border)){
			alert("Check border value")
			return false;
		}
		var width = parseInt(this.inputs['width'].value);
		if(isNaN(width)){
			alert("Check width value")
			return false;
		}
		var cellw = (1/cols)*100;
		var TableCode = '<table width="'+ width +'%" border="'+ border +'"><thead><tr>';
	
		for (i=1;i<=cols;i++) {
			TableCode += '<th width="'+ cellw +'%">Header</th>';
		}
		
		TableCode += '</tr></thead><tbody>';
		
		var alternate = 'even';
		
		for (j=1;j<=rows;j++)	{

			TableCode += '<tr>';

			for (i=1;i<=cols;i++)	{
				TableCode += '<td width="'+ cellw +'%">Content</td>';
			}

			TableCode += '</tr>';		
		}
		
		TableCode += '</tbody></table>'; 
		this.removePane();
		this.ne.nicCommand('insertHTML', TableCode);
	}
});

if (typeof initPageEditor !== 'undefined'){
  nicEditors.registerPlugin(nicPlugin,nicCodeOptions);
}

var nicUploadFile = nicEditorAdvancedButton.extend({
  errorText : 'Failed to upload',

	addPane : function() {
    if(typeof window.FormData === "undefined") {
      return this.onError("Failed to upload.");
    }

    var container = new bkElement('div')
      .setStyle({ padding: '10px' })
      .appendTo(this.pane.pane);

		new bkElement('div')
      .setStyle({ fontSize: '14px', fontWeight : 'bold', paddingBottom: '5px' })
      .setContent('Upload file')
      .appendTo(container);

    docList = ['Image', 'Document PDF', 'Other file', 'Audio', 'Video'];
    htmlStr = ``
    for(let i = 0; i< docList.length; i++){
      if(i == 0){
        htmlStr += `<input type="radio" name="type" id="row`+ i +`" value="` + i + `" checked="checked"><label for="row`+i+`">`+ docList[i] +`</label><br>`;
      }else{
        htmlStr += `<input type="radio" name="type" id="row`+ i +`" value="` + i + `"><label for="row`+i+`">`+ docList[i] +`</label><br>`;
      }
    }
    htmlStr += `<br><label for="usFendly">User friendly name:</label><input type="text" id="usfrname" name="usfrname"><br>`
		container.innerHTML += `<div style="font-size: 12px; font-weight: bold; padding-bottom: 5px;">` + htmlStr;

    this.fileInput = new bkElement('input')
      .setAttributes({ 'type' : 'file' })
      .appendTo(container);

    this.progress = new bkElement('progress')
      .setStyle({ width : '100%', display: 'none' })
      .setAttributes('max', 100)
      .appendTo(container);

    this.fileInput.onchange = this.uploadFile.closure(this);
	},

  onError : function(msg) {
    this.removePane();
    alert("Failed to upload file");
  },

  uploadFile : function() {
    var file = this.fileInput.files[0];
    if (!file) {
      this.onError("Sothing went wrong.");
      return;
    }
	
	  fileType = document.querySelector('input[name=type]:checked').defaultValue;
	
    this.fileInput.setStyle({ display: 'none' });
    this.setProgress(0);

    var fd = new FormData(); // https://hacks.mozilla.org/2011/01/how-to-develop-a-html5-image-uploader/
    fd.append("filetype", fileType);
    fd.append("courseID", document.getElementById("courseID").value)
    fd.append("usfrname", document.getElementById("usfrname").value)
    fd.append("filedata", file);

    var xhr = new XMLHttpRequest();
    xhr.open("POST", this.ne.options.uploadFileURI);

    xhr.onload = function() {
      try {
        var data = JSON.parse(xhr.responseText);
		var table = document.getElementById("files");
		var row = table.insertRow(0);
		var tabl = `<tr><td>` + data.name + `</td><td><a href="`+ data.link +`"  target="_blank">Link to file</a></td><td> <button onclick="copyToClipboard('`+data.link+`')">Copy link</button> </td></tr>`;
        row.innerHTML = tabl;
      } catch(e) {
        return this.onError();
      }
      if(data.error) {
        return this.onError(data.error);
      }
      this.onUploaded(data);
    }.closure(this);
    xhr.onerror = this.onError.closure(this);
    xhr.upload.onprogress = function(e) {
      this.setProgress(e.loaded / e.total);
    }.closure(this);
    //xhr.setRequestHeader('Authorization', 'Client-ID c37fc05199a05b7');
    xhr.send(fd);
  },

  setProgress : function(percent) {
    this.progress.setStyle({ display: 'block' });
    if(percent < .98) {
      this.progress.value = percent;
    } else {
      this.progress.removeAttribute('value');
    }
  },

  onUploaded : function(options) {
    this.removePane();
  }
});

var nicUploadFileOptions = {
	buttons : {
		'uploadFile' : {name : 'Upload file', type : 'nicUploadFile'},
	},
    iconFiles: {
        'uploadFile': '/static/nic/test_nicEditorClip.png'
    }
};

if (typeof initPageEditor !== 'undefined'){
  nicEditors.registerPlugin(nicPlugin,nicUploadFileOptions);
}

function copyToClipboard (str) {
  const el = document.createElement('textarea');
  el.value = str;
  el.setAttribute('readonly', '');
  el.style.position = 'absolute';
  el.style.left = '-9999px';
  document.body.appendChild(el);
  el.select();
  //document.execCommand('copy');
  navigator.clipboard.writeText(el.baseURI);
  document.body.removeChild(el);
};

/* START CONFIG */
var nicImageOptionsBase64 = {
	buttons : {
		'image' : {name : 'Add Image', type : 'nicImageButtonBase64', tags : ['IMG']}
	}
};
/* END CONFIG */

var tmp_holder = 0;
var nicImageButtonBase64 = nicEditorAdvancedButton.extend({

	//mouseClick : this.addPane(),
  
  addPane : function() {
    this.im = this.ne.selectedInstance.selElm().parentTag('IMG');
    this.fileInput = new bkElement('input')
      .setAttributes({ 'type' : 'file' , "accept" : "image/*"})
      .appendTo(this.pane.pane);

    tmp_holder = this;

    this.fileInput.onchange = this.setBase64Image;
    this.fileInput.click();
	},

  setBase64Image : function(e) {
    if (this.files[0]) {
      var reader = new FileReader();
      reader.addEventListener("load", function() {
        if(!tmp_holder.im) {
          var tmp = 'javascript:nicImTemp();';
          tmp_holder.ne.nicCommand("insertImage",tmp);
          tmp_holder.im = tmp_holder.findElm('IMG','src',tmp);
        }
        if(tmp_holder.im) {
          tmp_holder.im.setAttributes({
            src : this.result,
            alt : '',
            className : "popImage",
            align : 'none',
          });
        }
        tmp_holder.removePane();
        tmp_holder = 0;
      });
      reader.readAsDataURL(this.files[0]);
    }
  }
});

if (typeof initPageEditor === 'undefined'){
  for(let i = 0; i < nicEditors.nicPlugins.length; i++){
    try {
      if(nicEditors.nicPlugins[i].o.buttons.image.type == "nicImageButton"){
        nicEditors.nicPlugins.splice(i, 1)
        nicEditors.registerPlugin(nicPlugin,nicImageOptionsBase64); //Insert img as base64
        //nicEditors.registerPlugin(nicPlugin,nicUploadOptions); //Here we can upload img to the server
        nicEditors.registerPlugin(nicPlugin,nicCodeOptions);
        i = nicEditors.nicPlugins.length;
      }
    } catch (error) {
      j = 0;
    }
  }
}

//Used https://success.outsystems.com/Documentation/How-to_Guides/Front-End/How_can_you_prevent_users_from_losing_unsaved_changes%3F

var confirmationMessage = "You have unsaved changes. Are you sure you want to leave?";

var isModified = function () {
      let tmpHolder = document.getElementsByClassName(' nicEdit-main ');
	  let changeQuestion = false;
	  let changeDescription= false;
	  let changeAnwers = false;
	  
	  if(questiontextLength == tmpHolder[0].innerHTML.length){
		 new_sum_question = calc_checksum(tmpHolder[0].innerHTML);
		 if(new_sum_question != sum_question){
			changeQuestion = true;
		 }
	  }else{
		  changeQuestion = true;
	  }
	  if(descriptiontextLength == tmpHolder[1].innerHTML.length){
		 new_sum_description = calc_checksum(tmpHolder[1].innerHTML);
		 if(new_sum_description != sum_description){
			changeDescription = true;
		 }
	  }else{
		  changeDescription = true;
	  }
	  if(answertextLength == document.getElementById("answers_area").innerHTML.length){
		 new_sum_answer = calc_checksum(document.getElementById("answers_area").innerHTML);
		 if(new_sum_answer != sum_answer){
			changeAnwers = true;
		 }
	  }else{
		  changeAnwers = true;
	  }
	  
	var tmpResult = changeQuestion || changeDescription || changeAnwers;
    return tmpResult;
}

// Handle normal button and link clicks on the page
document.body.addEventListener(
  "click",
    function(event){
	 return;
	 // This trigers on any button click but all buttons are js functions
     //	there are no links on the page so we skipp the check
     if (event.target.tagName === "BUTTON" || event.target.tagName === "A") {
        var associatedWithForm = event.target.form
        var isInProtectedForm = associatedWithForm && event.target.form.id ===  $parameters.FormId
        if(!isInProtectedForm && isModified()) {
            if(!confirm(confirmationMessage)) {
                event.stopPropagation();
                event.preventDefault()
                return false;
             }
          }
        }
  }   
)

// Catch navigating back
window.onpopstate = function(event) {
  if(isModified()) {
        if(!confirm(confirmationMessage)) {
          history.pushState(null, document.title, location.href);
        }
    }
}

function confirmExit (event) {
   if(isModified()) {
       (event || window.event).returnValue = confirmationMessage; //Gecko + IE
       return confirmationMessage; //Gecko + Webkit, Safari, Chrome etc.
    }
}

// Catch window close
window.onbeforeunload = confirmExit;

//variables used to check if the text was modifed
//Well if the nex text is the same length as the old the chech will return true
//To be fixed later
if (typeof initPageEditor !== 'undefined'){
  let tmpHolder = document.getElementsByClassName(' nicEdit-main ');
  var questiontextLength = tmpHolder[0].innerHTML.length;
  var descriptiontextLength = tmpHolder[1].innerHTML.length;
  var answertextLength = document.getElementById("answers_area").innerHTML.length;
  
  var sum_question = calc_checksum(tmpHolder[0].innerHTML);
  var sum_description = calc_checksum(tmpHolder[1].innerHTML);
  var sum_answer = calc_checksum(document.getElementById("answers_area").innerHTML);
  
}else{
  var questiontextLength = 0;
  var descriptiontextLength = 0;
  var answertextLength = 0;
  var sum_question = 0;
  var sum_description = 0;
  var sum_answer = 0;
  setTimeout(setCheckValues, 100);
}

function setCheckValues(){
  let tmpHolder = document.getElementsByClassName(' nicEdit-main ');
  questiontextLength = tmpHolder[0].innerHTML.length;
  descriptiontextLength = tmpHolder[1].innerHTML.length;
  answertextLength = document.getElementById("answers_area").innerHTML.length;
  
  sum_question = calc_checksum(tmpHolder[0].innerHTML);
  sum_description = calc_checksum(tmpHolder[1].innerHTML);
  sum_answer = calc_checksum(document.getElementById("answers_area").innerHTML);
}

function saveQuestion(content, id, instance) {
	 var questionID = document.getElementById("questionID").value;
	 var courseID = document.getElementById("courseID").value;
	 var quizID = document.getElementById("quizID").value;
	
	 let tmpHolder = document.getElementsByClassName(' nicEdit-main ');

	 //var questionTxt = document.getElementById("area_question").value; //do not use the area, but the div and the inner text
	 var questionTxt = tmpHolder[0].innerHTML;
	 //var explnTxt = document.getElementById("area_explanation").value; //do not use the area, but the div and the inner text
	 var explnTxt = tmpHolder[1].innerHTML;
	 var referenceLink = document.getElementById("referenceLink").value;
	
	if(document.getElementById("select_answers") != null){ //Drag-drop answers
		selc_ans = document.getElementById("select_answers");
		posb_ans = document.getElementById("correct_answers");
		var answers_html = selc_ans.getElementsByClassName("showinline");
		answers = [];
		answerCount = [];
		for(let i = 0; i < answers_html.length; i++){
			answers.push(answers_html[i].firstChild.value)
			answerCount.push(answers_html[i].childNodes[2].value)
		}
		var answers_html = posb_ans.getElementsByClassName("showinline");
		correctAnswer = [];
		groups = [];
		for(let i = 0; i < answers_html.length; i++){
			correctAnswer.push(answers_html[i].firstChild.value)
			groups.push(answers_html[i].childNodes[2].value)
		}
		correctAnswer = JSON.stringify(correctAnswer)
		
		if(!questionTxt.includes("$?__")){
			for(let i = 0; i < answers_html.length; i++){
				questionTxt+="<div>&nbsp;$?__</div>"
			}
		}else{
			var count = (questionTxt.match(/\$\?__/g) || []).length;
			if(count != answers_html.length){
			   alert("Drop darget count diffrent than correct answers!")
			   errorDiv = document.getElementById("error_no_answer");
			   errorDiv.style.setProperty('display','block','')
			   return;
			}
		}
	}else{ //free text
		 var freetext = document.getElementById("freeTextAns");
		 if(freetext == null){
		   //Not free text question
		   var answers_html = document.getElementsByClassName("showinline");
		   var correctAnswer = ""
		   var answers = {};
		   // -1 becasue the reference link adds one more line
		   for(let i = 0; i < answers_html.length - 1; i++){
			 var tmp_ans = answers_html[i].getElementsByTagName("input");
			 if(tmp_ans[0].checked){
			   //correctAnswer+=i;
			   correctAnswer+=String.fromCharCode(65 + i);
			 }
			 //answers[i] = tmp_ans[1].value
			 answers[String.fromCharCode(65 + i)] = tmp_ans[1].value
			 if(answers[String.fromCharCode(65 + i)].includes("&")){
				 if(answers[String.fromCharCode(65 + i)][0] != "¶"){
					 answers[String.fromCharCode(65 + i)] = "¶".concat(answers[String.fromCharCode(65 + i)]);
				 }
			 }
		   }
		 }else{
		   var answers = {};
		   var correctAnswer = document.getElementById("freeTextAns").value;
		 }
	 }

	 var fd = new FormData(); // https://hacks.mozilla.org/2011/01/how-to-develop-a-html5-image-uploader/
	 fd.append("courseID", courseID);
	 fd.append("quizID", quizID);
	 fd.append("questionID", questionID);
	 fd.append("questionTxt",  questionTxt);
	 fd.append("questionCat", document.getElementById("questionType").value);
	 fd.append("explnTxt", explnTxt);
	 fd.append("referenceLink", referenceLink);
	 fd.append("answers", JSON.stringify(answers));
	 if(typeof groups !== 'undefined'){
		for(let j = 0; j < groups.length; j++){
			if(groups[j] == j){continue}
			fd.append("answers_grp", JSON.stringify(groups));
			break;
		}
	 }
	 if(typeof answerCount !== 'undefined'){
		for(let j = 0; j < answerCount.length; j++){
			if(answerCount[j] == "1"){continue}
			fd.append("answers_cnt", JSON.stringify(answerCount));
			break;
		}
	 }
	 fd.append("correctAnswer", correctAnswer);
	 if(correctAnswer.length <= 0){ //add validation
	   alert("Please fill the correct answer!")
	   errorDiv = document.getElementById("error_no_answer");
	   errorDiv.style.setProperty('display','block','')
	   return;
	 }

	 var xhr = new XMLHttpRequest();
	 xhr.open("POST", "./saveQuestion");

	 xhr.onload = function() {
			 alert("Status: " + xhr.responseText);
			 if(xhr.status == 200){
			   setCheckValues();
			 }
			 errorDiv = document.getElementById("error_no_answer");
			 errorDiv.style.display='none'
	 };
	 xhr.onerror = xhr.onload;
	 //xhr.setRequestHeader('Authorization', 'Client-ID c37fc05199a05b7');
	 xhr.send(fd);
  }

  function clearPage(){
	if(isModified()) {
		if(!confirm("The question is not saved.\nDo you want to clear the page?")) {
			 event.stopPropagation();
			 event.preventDefault()
			 return;
		}
	}
	var options = document.getElementById("questionType").options;
	options[0].selected = true;
	let tmpHolder = document.getElementsByClassName(' nicEdit-main ');
	//var questionTxt = document.getElementById("area_question").value; //do not use the area, but the div and the inner text
	tmpHolder[0].innerHTML = "";
	//var explnTxt = document.getElementById("area_explanation").value; //do not use the area, but the div and the inner text
	tmpHolder[1].innerHTML = "";
	var ansArea = document.getElementById("answers_area");
	newHtml = `<input type="text" id="freeTextAns" style = "width: 100%;" value="">`;
	ansArea.innerHTML = newHtml;
	document.getElementById("noQuestion").value = 0;
	document.getElementById("referenceLink").value = ""
	errorDiv = document.getElementById("error_no_answer");
	errorDiv.style.display='none'
	setCheckValues();
  }

  function nicEdit_Scroll_Patch(){
	let tmpHolder = document.getElementsByClassName(' nicEdit-main ')
	var body = document.body,
		html = document.documentElement;
	var width = tmpHolder[0].clientWidth;

	var height = Math.max( body.scrollHeight, body.offsetHeight,
						   html.clientHeight, html.scrollHeight, html.offsetHeight ) / 4;
	for (let i = 0; i < tmpHolder.length; i++){
		tmpHolder[i].style.setProperty('max-height',height,'');
		tmpHolder[i].style.setProperty('overflow-y','scroll','');
		//tmpHolder[i].style.setProperty('max-width',width,'');
		//tmpHolder[i].style.setProperty('overflow-x','scroll','');
	}
  }

  function nicEdit_Padding_Patch(){
	let tmpHolder = document.getElementsByClassName(' nicEdit-main ')
	for (let i = 0; i < tmpHolder.length; i++){
		tmpHolder[i].style.setProperty('padding-left','5px','');
	}
  }
  
  var selectedColor = '#fff';
  function nicEdit_BackgroundColor_Patch(){
	let tmpHolder = document.getElementsByClassName('editor_holder')
	for (let i = 0; i < tmpHolder.length; i++){
		tmpHolder[i].children[1].style.setProperty('background-color',selectedColor,'');
		//tmpHolder[i].children[1].style.setProperty('background-color','#fff','');
	}
  }
  
  function initEditors(){
	  new nicEditor({fullPanel : true, /*uploadImgURI : '/be/nicUploadImg',*/
	  onSave : saveQuestion,
	  iconsPath : '/static/nic/new_nicEditorIcons.png',
	  tableURL : '/be/nicShowFiles'}).panelInstance('area_question');

	  new nicEditor({fullPanel : true, /*uploadImgURI : '/be/nicUploadImg',*/
	  onSave : saveQuestion,
	  iconsPath : '/static/nic/new_nicEditorIcons.png',
	  tableURL : '/be/nicShowFiles'}).panelInstance('area_explanation');
	  nicEdit_Padding_Patch();
	  nicEdit_Scroll_Patch();
	  //nicEdit_BackgroundColor_Patch();
 }

function calc_checksum(in_str){
	return calculateCRC(in_str);
}

function calculateCRC(data) {
    const polynomial = 0xEDB88320;
    let crc = 0xFFFFFFFF;
 
    // Iterate through each character in the data
    for (let i = 0; i < data.length; i++) {
        // XOR the current character 
        // with the current CRC value
        crc ^= data.charCodeAt(i);
 
        // Perform bitwise operations 
        // to calculate the new CRC value
        for (let j = 0; j < 8; j++) {
            crc = (crc >>> 1) ^ (crc & 1 ? polynomial : 0);
        }
    }
 
    // Perform a final XOR operation and return the CRC value
    return crc ^ 0xFFFFFFFF;
}


// used from https://stackoverflow.com/questions/14733374/how-to-generate-an-md5-hash-from-a-string-in-javascript-node-js
function calculateMD5(data){
    var MD5 = function(d){var r = M(V(Y(X(d),8*d.length)));return r.toLowerCase()};function M(d){for(var _,m="0123456789ABCDEF",f="",r=0;r<d.length;r++)_=d.charCodeAt(r),f+=m.charAt(_>>>4&15)+m.charAt(15&_);return f}function X(d){for(var _=Array(d.length>>2),m=0;m<_.length;m++)_[m]=0;for(m=0;m<8*d.length;m+=8)_[m>>5]|=(255&d.charCodeAt(m/8))<<m%32;return _}function V(d){for(var _="",m=0;m<32*d.length;m+=8)_+=String.fromCharCode(d[m>>5]>>>m%32&255);return _}function Y(d,_){d[_>>5]|=128<<_%32,d[14+(_+64>>>9<<4)]=_;for(var m=1732584193,f=-271733879,r=-1732584194,i=271733878,n=0;n<d.length;n+=16){var h=m,t=f,g=r,e=i;f=md5_ii(f=md5_ii(f=md5_ii(f=md5_ii(f=md5_hh(f=md5_hh(f=md5_hh(f=md5_hh(f=md5_gg(f=md5_gg(f=md5_gg(f=md5_gg(f=md5_ff(f=md5_ff(f=md5_ff(f=md5_ff(f,r=md5_ff(r,i=md5_ff(i,m=md5_ff(m,f,r,i,d[n+0],7,-680876936),f,r,d[n+1],12,-389564586),m,f,d[n+2],17,606105819),i,m,d[n+3],22,-1044525330),r=md5_ff(r,i=md5_ff(i,m=md5_ff(m,f,r,i,d[n+4],7,-176418897),f,r,d[n+5],12,1200080426),m,f,d[n+6],17,-1473231341),i,m,d[n+7],22,-45705983),r=md5_ff(r,i=md5_ff(i,m=md5_ff(m,f,r,i,d[n+8],7,1770035416),f,r,d[n+9],12,-1958414417),m,f,d[n+10],17,-42063),i,m,d[n+11],22,-1990404162),r=md5_ff(r,i=md5_ff(i,m=md5_ff(m,f,r,i,d[n+12],7,1804603682),f,r,d[n+13],12,-40341101),m,f,d[n+14],17,-1502002290),i,m,d[n+15],22,1236535329),r=md5_gg(r,i=md5_gg(i,m=md5_gg(m,f,r,i,d[n+1],5,-165796510),f,r,d[n+6],9,-1069501632),m,f,d[n+11],14,643717713),i,m,d[n+0],20,-373897302),r=md5_gg(r,i=md5_gg(i,m=md5_gg(m,f,r,i,d[n+5],5,-701558691),f,r,d[n+10],9,38016083),m,f,d[n+15],14,-660478335),i,m,d[n+4],20,-405537848),r=md5_gg(r,i=md5_gg(i,m=md5_gg(m,f,r,i,d[n+9],5,568446438),f,r,d[n+14],9,-1019803690),m,f,d[n+3],14,-187363961),i,m,d[n+8],20,1163531501),r=md5_gg(r,i=md5_gg(i,m=md5_gg(m,f,r,i,d[n+13],5,-1444681467),f,r,d[n+2],9,-51403784),m,f,d[n+7],14,1735328473),i,m,d[n+12],20,-1926607734),r=md5_hh(r,i=md5_hh(i,m=md5_hh(m,f,r,i,d[n+5],4,-378558),f,r,d[n+8],11,-2022574463),m,f,d[n+11],16,1839030562),i,m,d[n+14],23,-35309556),r=md5_hh(r,i=md5_hh(i,m=md5_hh(m,f,r,i,d[n+1],4,-1530992060),f,r,d[n+4],11,1272893353),m,f,d[n+7],16,-155497632),i,m,d[n+10],23,-1094730640),r=md5_hh(r,i=md5_hh(i,m=md5_hh(m,f,r,i,d[n+13],4,681279174),f,r,d[n+0],11,-358537222),m,f,d[n+3],16,-722521979),i,m,d[n+6],23,76029189),r=md5_hh(r,i=md5_hh(i,m=md5_hh(m,f,r,i,d[n+9],4,-640364487),f,r,d[n+12],11,-421815835),m,f,d[n+15],16,530742520),i,m,d[n+2],23,-995338651),r=md5_ii(r,i=md5_ii(i,m=md5_ii(m,f,r,i,d[n+0],6,-198630844),f,r,d[n+7],10,1126891415),m,f,d[n+14],15,-1416354905),i,m,d[n+5],21,-57434055),r=md5_ii(r,i=md5_ii(i,m=md5_ii(m,f,r,i,d[n+12],6,1700485571),f,r,d[n+3],10,-1894986606),m,f,d[n+10],15,-1051523),i,m,d[n+1],21,-2054922799),r=md5_ii(r,i=md5_ii(i,m=md5_ii(m,f,r,i,d[n+8],6,1873313359),f,r,d[n+15],10,-30611744),m,f,d[n+6],15,-1560198380),i,m,d[n+13],21,1309151649),r=md5_ii(r,i=md5_ii(i,m=md5_ii(m,f,r,i,d[n+4],6,-145523070),f,r,d[n+11],10,-1120210379),m,f,d[n+2],15,718787259),i,m,d[n+9],21,-343485551),m=safe_add(m,h),f=safe_add(f,t),r=safe_add(r,g),i=safe_add(i,e)}return Array(m,f,r,i)}function md5_cmn(d,_,m,f,r,i){return safe_add(bit_rol(safe_add(safe_add(_,d),safe_add(f,i)),r),m)}function md5_ff(d,_,m,f,r,i,n){return md5_cmn(_&m|~_&f,d,_,r,i,n)}function md5_gg(d,_,m,f,r,i,n){return md5_cmn(_&f|m&~f,d,_,r,i,n)}function md5_hh(d,_,m,f,r,i,n){return md5_cmn(_^m^f,d,_,r,i,n)}function md5_ii(d,_,m,f,r,i,n){return md5_cmn(m^(_|~f),d,_,r,i,n)}function safe_add(d,_){var m=(65535&d)+(65535&_);return(d>>16)+(_>>16)+(m>>16)<<16|65535&m}function bit_rol(d,_){return d<<_|d>>>32-_}
    var result = MD5(data);
    return result;
}