<script>
	table = 'el_groups';
</script>
<div id="groups" class="tab-page" style="display:block;">	
	<div style="clear:both"></div>	
	<table id="dg"  
	class="easyui-datagrid"
	url="[+moduleurl+]action=getData&table=el_groups"
	toolbar="#toolbar" 
	pagination="true"
	rownumbers="true"
	fitColumns="true" 
	singleSelect="true"
	title="Группы"
	>
		<thead>
			<tr>
				<th field="name" width="99%">Название</th>   								
			</tr>
		</thead>
	</table>
	<div id="toolbar">
        <a href="javascript:void(0)" class="easyui-linkbutton" plain="true" onclick="new_str()"><i class="fa fa-user-plus" aria-hidden="true"></i> Новый</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" plain="true" onclick="edit_str()"><i class="fa fa-pencil-square-o" aria-hidden="true"></i> Редактирование</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" plain="true" onclick="destroy_str()"><i class="fa fa-user-times" aria-hidden="true"></i> Удалить</a>		
	</div>
	<script type="text/javascript">
        $(function(){
            $('#dg').datagrid();
		});
	</script>
</div>
<div id="dlg" class="easyui-dialog" style="width:420px;height:150px;padding:10px 20px" closed="true" buttons="#dlg-buttons">
	
	<form id="ff" method="post" novalidate>		
		<input type="hidden" name="id" value="">
		<div style="margin-bottom:20px">
			<input class="easyui-textbox" name="name" style="width:100%" data-options="label:'Имя:'">
		</div>	
	</form>
</div>
<div id="dlg-buttons">	
	<a href="#" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlg').dialog('close')">Отмена</a>
	<a href="#" class="easyui-linkbutton" iconCls="icon-ok" onclick="save()">Сохранить</a>
</div>
