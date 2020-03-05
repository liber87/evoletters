<link rel="stylesheet" href="[+CM_URL+]cm/lib/codemirror.css">
<link rel="stylesheet" href="[+CM_URL+]cm/addon.css">
<link rel="stylesheet" href="[+CM_URL+]cm/theme/default.css">
<script src="[+CM_URL+]cm/lib/codemirror-compressed.js"></script>
<script src="[+CM_URL+]cm/mode/xml-compressed.js"></script> <!-- required by mode htmlmixed -->
<script src="[+CM_URL+]cm/mode/javascript-compressed.js"></script> <!-- required by mode htmlmixed -->
<script src="[+CM_URL+]cm/mode/css-compressed.js"></script>
<script src="[+CM_URL+]cm/mode/htmlmixed-compressed.js"></script>    

	
<script type="text/javascript">
	table = 'el_templates';	
	var tid = '[+get.tid+]';
	
	$.getJSON('[+moduleurl+]action=getData&table=el_templates&wid='+tid, function (json) { 
		if (!tid) json.rows[0] = '';
		$('#ff').form('load', json.rows[0]);	
		cm = CodeMirror.fromTextArea(document.getElementById("editor"), { value: json.rows[0], mode: "htmlmixed", lineNumbers: true, lineWrapping: true });
	});
	
	
</script>	
<style>
	.btn-default{background:white;border: 1px solid #d4d4d4;color:black;}
	input[type=text]{margin-bottom:10px;    border: 1px solid #eceeef !important;}
	label{margin-bottom:0;}
</style>
<div id="tab-page1" class="tab-page" style="display:block;">	
	<h3 style="float:left">Редактирование шаблона <b id="name_template"></b></h3>
	<div style="clear:both;"></div>
	
	<form id="ff" novalidate>		
		<label>Название</label>
		<input name="id"  type="hidden" value="">
		<input name="name"  type="text">
		<label>Тема</label>
		<input name="subject" type="text">
		<label>Сообщение</label>
		<textarea id="editor" name="template" class="phptextarea" style="height:300px;"></textarea>
		<li class="save"><a href="javascript:void(0);" class="btn btn-sucess" onclick="save_tl()">Сохранить</a></li>
	</form>
	
	
	<div style="clear:both; margin-top:20px;"></div>
	<p><b>Шаблоны</b> - заготовки для дальнейшей отправки писем. Доступны следующие плейсхолдеры: <b>[+content+]</b> - содержимое письма, <b>[+unscribe_link+]</b> - ссылка на отписку, <b>[+subscribe_link+]</b> - ссылка на подтверждеие подписки.</p>	
</div> 	