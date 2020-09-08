<script type="text/javascript">
	table = 'el_letters';	
	groups = JSON.parse('[+groups+]');	
	var tid = '[+get.tid+]';
	if (tid){
	$.getJSON('[+moduleurl+]action=getData&table=el_letters&wid='+tid, function (json) { 
		$('#ff').form('load', json.rows[0]);							
		if(json.rows[0].groups!='undefined'){		
			$('.grch').removeAttr("checked");
			var gsc = json.rows[0].groups;
			var gs = gsc.split(',');
			$.each(gs, function( index, value ) {
				
				$('#grch'+value).prop('checked', true);
			});
		}
		});
	}	
	
</script>	
[+rte+]
<style>
	.btn-default{background:white;border: 1px solid #d4d4d4;color:black;}
	input[type=text]{margin-bottom:10px;    border: 1px solid #eceeef !important;}
	label{margin-bottom:0;}
</style>
<div id="tab-page1" class="tab-page" style="display:block;">	
	
	
	<form id="ff" novalidate>		
		<label>Название</label>
		<input name="id"  type="hidden" value="">
		<input name="name"  type="text">
		<label>Тема</label>
		<input name="subject" type="text">
		<label style="margin-top:5px;">Шаблон</label>
		<select name="tpl" id="template_letter">
			[+templates+]
		</select>
		<label style="margin-top:10px;">Метод отправки</label>
		<select name="method" id="method_select">
			[+methods+]
		</select>
		<label style="margin-top:5px;">Группы</label>
		<div id="groups_checkbox"></div>
		
		<label  style="margin-top:10px;">Сообщение</label>
		<textarea id="editor" name="content" class="ckeditor"></textarea>
		<li class="save"><a href="javascript:void(0);" class="btn btn-sucess" onclick="save_tl()">Сохранить</a></li>
	</form>
	
	
	<div style="clear:both"></div>	
</div> 	
