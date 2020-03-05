<script>
	table = 'el_letters';
	templates = JSON.parse('[+templates_json+]');	
</script>
<div id="tab-page1" class="tab-page" style="display:block;">	
	<div style="clear:both"></div>	
	<table id="dg"  
	class="easyui-datagrid"
	url="[+moduleurl+]action=getData&table=el_letters"
	toolbar="#toolbar" 
	pagination="true"
	rownumbers="true"
	fitColumns="true" 
	singleSelect="true">
		<thead>
			<tr>
				<th field="name" width="20%">Название</th>
				<th field="subject"  width="20%">Тема</th>
				<th field="tpl" formatter="get_template" width="20%">Шаблон</th>
				<th field="method" width="20%">Метод</th>
				<th field="count"  width="20%">Рассылок</th>    				
			</tr>
		</thead>
	</table>
	<div id="toolbar">
		<a href="[+moduleurl+]tab=edit_letter&tid=" id="new_link" class="easyui-linkbutton" plain="true"><i class="fa fa-user-plus" aria-hidden="true"></i> Новый</a>
        <a href="javascript:void(0)" onclick="go_template('edit_letter')" class="easyui-linkbutton" plain="true"><i class="fa fa-pencil-square-o" aria-hidden="true"></i> Редактирование</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" plain="true" onclick="destroy_str()"><i class="fa fa-user-times" aria-hidden="true"></i> Удалить</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" plain="true" onclick="distribution()"><i class="fa fa-paper-plane" aria-hidden="true"></i> Произвести рассылку</a>		
	</div>
	<div id="dlg" class="easyui-dialog closed" title="Отправка писем" data-options="closed:true" style="width:400px;height:200px;padding:10px;">
		<p><p>Идет отправка: <b id="name_send_letter"></b></p></p>
		<p><p>Всего подписчиков <b id="c_subscribers"></b></p></p>
		<p><p>Отправлено <b id="sended"></b></p></p>
        <div id="p" class="easyui-progressbar"></div>
	</div>
	
</div>
<script>
	c_subscribers = 0;
	function get_template (val, row) 
	{
		return templates[val];
	}
	function ajax_distribution(n)
	{
		if (c_subscribers>0)
		{
			$('#c_subscribers').html(c_subscribers);
			var value = parseInt((n/c_subscribers)*100);
			$('#p').progressbar('setValue', value);
			$('#sended').html(n);
		}
		$.ajax({		
			method: 'post',
			url: moduleurl+'&action=setDistribution&offset='+n+'&el_id='+row.id,
			success: function(result){							
				if (result.status=='continue') 
				{
					c_subscribers = result.ct;
					ajax_distribution(result.next);					
				}
				else
				{
					$('#dlg').dialog('close');
					$.messager.show({       
						title: 'Успех',
						msg: 'Рассылка успешно произведена! Более подробная информация находится в логе системы управления!'
					});
				}
			}});
	}
	
	function distribution () 
	{
		
		row = $('#dg').datagrid('getSelected');		
		$('#name_send_letter').html(row.name);
		
		if (row)
		{		
			$('#dlg').dialog('open');
			ajax_distribution(0);		
		}
	}
</script>