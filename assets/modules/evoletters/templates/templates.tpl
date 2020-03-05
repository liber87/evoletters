<script>
	table = 'el_templates';
</script>
<div id="tab-page1" class="tab-page" style="display:block;">	
	<div style="clear:both"></div>	
	<table id="dg"  
	class="easyui-datagrid"
	url="[+moduleurl+]action=getData&table=el_templates"
	toolbar="#toolbar" 
	pagination="true"
	rownumbers="true"
	fitColumns="true" 
	singleSelect="true">
		<thead>
			<tr>
				<th field="name" width="40%">Название</th>
				<th field="subject"  width="40%">Тема</th>
				<th field="count"  width="20%">Рассылок</th>   				
			</tr>
		</thead>
	</table>
	 <div id="toolbar">
         <a href="[+moduleurl+]tab=edit_template&tid=" id="new_link" class="easyui-linkbutton" plain="true"><i class="fa fa-user-plus" aria-hidden="true"></i> Новый</a>
        <a href="javascript:void(0)" onclick="go_template('edit_template')" class="easyui-linkbutton" plain="true"><i class="fa fa-pencil-square-o" aria-hidden="true"></i> Редактирование</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" plain="true" onclick="destroy_str()"><i class="fa fa-user-times" aria-hidden="true"></i> Удалить</a>
	</div>
</div>