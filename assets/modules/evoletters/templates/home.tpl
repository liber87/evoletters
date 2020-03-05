<script>
	table = 'el_subscriber';
</script>
<div id="tab-page1" class="tab-page" style="display:block;">	
	<div style="clear:both"></div>	
	<table id="dg"  
	class="easyui-datagrid"
	url="[+moduleurl+]action=getData&table=el_subscriber"
	toolbar="#toolbar" 
	pagination="true"
	rownumbers="true"
	fitColumns="true" 
	singleSelect="true"
	title="Подписчики"
	>
		<thead>
			<tr>
				<th field="email"  width="25%">Email</th>   				
				<th field="name" width="25%">Имя</th>										
				<th field="phone" width="21%">Телефон</th>						
				<th field="count" align="center" width="8%" sortable="true">Рассылок</th>   				
				<th field="confirmed" formatter="confirmed" align="center" width="8%"> Подтвержден</th> 
				<th field="valid" formatter="valid" align="center" width="12%"> Верифицирован</th> 
			</tr>
		</thead>
	</table>
	<div id="toolbar">
        <a href="javascript:void(0)" class="easyui-linkbutton" plain="true" onclick="new_str()"><i class="fa fa-user-plus" aria-hidden="true"></i> Новый</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" plain="true" onclick="edit_str()"><i class="fa fa-pencil-square-o" aria-hidden="true"></i> Редактирование</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" plain="true" onclick="destroy_str()"><i class="fa fa-user-times" aria-hidden="true"></i> Удалить</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" plain="true" onclick="validate_emails()"><i class="fa fa-user-times" aria-hidden="true"></i> Произвести валидацию</a>
	</div>
	<script type="text/javascript">
        $(function(){
            $('#dg').datagrid({
                view: detailview,
                detailFormatter:function(index,row){
                    return '<div class="ddv" style="padding:5px 0"></div>';
				},
                onExpandRow: function(index,row){
                    var ddv = $(this).datagrid('getRowDetail',index).find('div.ddv');
                    ddv.panel({                        
                        border:false,
                        cache:false,
                        href:moduleurl+'action=getExtendInfoSubscriber&sid='+row.id,
                        onLoad:function(){
                            $('#dg').datagrid('fixDetailRowHeight',index);
						}
					});
                    $('#dg').datagrid('fixDetailRowHeight',index);
				}
			});
		});
	</script>
</div>
<div id="dlg" class="easyui-dialog" style="width:420px;height:300px;padding:10px 20px" closed="true" buttons="#dlg-buttons">
	
	<form id="ff" method="post" novalidate>		
		<input type="hidden" name="id" value="">
		<div style="margin-bottom:20px">
			<input class="easyui-textbox" name="name" style="width:100%" data-options="label:'Имя:'">
		</div>
		<div style="margin-bottom:20px">
			<input class="easyui-textbox" name="email" style="width:100%" data-options="label:'Email:',required:true,validType:'email'">
		</div>
		<div style="margin-bottom:20px">
			<input class="easyui-textbox" name="phone" style="width:100%" data-options="label:'Телефон:'">
		</div>
		<div style="margin-bottom:20px">
			<textarea class="easyui-textbox" name="comment" style="width:100%"></textarea>
		</div>
		
	</form>
</div>
<div id="dlg-buttons">	
	<a href="#" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlg').dialog('close')">Отмена</a>
	<a href="#" class="easyui-linkbutton" iconCls="icon-ok" onclick="save()">Сохранить</a>
</div>