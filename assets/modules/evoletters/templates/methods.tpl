<script>
	table = 'el_methods';
</script>
<div id="tab-page1" class="tab-page" style="display:block;">	
	<div style="clear:both"></div>	
	<table id="dg"  
	class="easyui-datagrid"
	url="[+moduleurl+]action=getData&table=el_methods"
	toolbar="#toolbar" 
	pagination="true"
	rownumbers="true"
	fitColumns="true" 
	singleSelect="true">
		<thead>
			<tr>
				<th field="name" width="50%">Название</th>
				<th field="method"  width="50%">Сниппет</th>
			</tr>
		</thead>
	</table>
	<div id="toolbar">
		<a href="javascript:void(0)" class="easyui-linkbutton" plain="true" onclick="new_str()"><i class="fa fa-user-plus" aria-hidden="true"></i> Новый</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" plain="true" onclick="edit_str()"><i class="fa fa-pencil-square-o" aria-hidden="true"></i> Редактирование</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" plain="true" onclick="destroy_str()"><i class="fa fa-user-times" aria-hidden="true"></i> Удалить</a>
	</div>
	<p style="margin-top:10px; font-style:italic;">В названии метода указывайте сниппет, который получает сформированное письмо и массив данных пользователей.</p>
</div>
<div id="dlg" class="easyui-dialog" style="width:420px;height:300px;padding:10px 20px" closed="true" buttons="#dlg-buttons">
	
	<form id="ff" method="post" novalidate>		
		<input type="hidden" name="id" value="">
		<div style="margin-bottom:20px">
			<input class="easyui-textbox" name="name" style="width:100%" data-options="label:'Название:',required:true">
		</div>
		<div style="margin-bottom:20px">
			<input class="easyui-textbox" name="method" style="width:100%" data-options="label:'Метод (название сниппета):',required:true">
		</div>		
	</form>
</div>
<div id="dlg-buttons">	
	<a href="#" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlg').dialog('close')">Отмена</a>
	<a href="#" class="easyui-linkbutton" iconCls="icon-ok" onclick="save()">Сохранить</a>
</div>
