var url;
var act;
var getUrlParameter = function getUrlParameter(sParam) {
    var sPageURL = decodeURIComponent(window.location.search.substring(1)),
	sURLVariables = sPageURL.split('&'),
	sParameterName,
	i;
    for (i = 0; i < sURLVariables.length; i++) {
        sParameterName = sURLVariables[i].split('=');
        if (sParameterName[0] === sParam) {
            return sParameterName[1] === undefined ? true : sParameterName[1];
		}
	}
};
document.addEventListener('DOMContentLoaded', function(){
	
	if ($('.save').length>0) $('.actionButtons').prepend($('.save'));
	
	
	$(document).on('change','.confirmed',function(){		
		$.post(moduleurl+'crud=update&table='+table, { id: $(this).data('row'), confirmed: Number($(this).prop('checked')) } );
	});
	
});
function valid (val, row) 
{		
	if (val==0) return '<span class="label label-default">нет данных</span>';	
	if (val==1) return '<span class="label label-warning">Нет</span>';	
	if (val==2) return '<span class="label label-success">Да</span>';	
	
}
function confirmed (val, row) 
{		
	if (val==0) return '<input type="checkbox" data-row="'+row.id+'" class="confirmed">';	
	else return '<input type="checkbox" checked="checked"  data-row="'+row.id+'" class="confirmed">';	
}


function normaldate (val, row) 
{
	var d = val.split(' ');
	var d2 = d[0].split('-');
	return d2[2]+'.'+d2[1]+'.'+d2[0]+' '+d[1];	
}


function get_method (val, row) 
{	
	return methods[val];
}


function save_tl()
{		
	if ($('.ckeditor').length) var txt = tinymce.get('editor').getContent();
	else var txt = cm.getValue();	
		
	$('#editor').val(txt);
	$.ajax({		
		method: 'post',
		url: moduleurl+'&action=setDataTemplate&table='+table,
		data: $('#ff').serialize(),		
		success: function(result){		
			
			if (result.status=='success')
			{
				$.messager.show({       
					title: 'Успех',
					msg: 'Успешно сохранено!'
				});
			}
			if (result.id)
			{
				var url = moduleurl+'tab='+getUrlParameter('tab')+'&tid='+result.id;
				window.location.href = url;
			}			
		}
	});
	return false;
}

function save(){	
	$('#ff').form('submit',{		
		url: moduleurl+'crud='+act+'&table='+table,
		onSubmit: function(){			
			return $(this).form('validate');
		},
		success: function(result){						
			var result = eval('('+result+')');
			if (result.success)
			{
				$('#dlg').dialog('close');
				$('#dg').datagrid('reload');
				
				} else {
				$.messager.show({
					title: 'Ошибка!',
					msg: result.msg
				});
			}
		}
	});
}         


function new_str()
{
	act = 'insert';
	$('#dlg').dialog('open');
	$('#ff').form('clear');	
}
function edit_str()
{
	act = 'update';
	var row = $('#dg').datagrid('getSelected');		
	if (row){		
		$('#dlg').dialog('open').dialog('setTitle','Редактирование');
		$('#ff').form('load',row);
		url = moduleurl+'do=update';
	}
}               
function go_template(edit)
{	
	var row = $('#dg').datagrid('getSelected');		
	if (row)
	{				
		url = moduleurl+'tab='+edit+'&tid='+row.id;
		window.location.href = url;
	}
}

function destroy_str(){
	var row = $('#dg').datagrid('getSelected');
	if (row){
		$.messager.confirm('Подтверждение','Вы действительно хотите удалить эту строку?',function(result){
			if (result){
				$.post(moduleurl+'crud=delete&table='+table,{id:row.id},function(result){
					if (result.success){
						$('#dg').datagrid('reload');   
						} else {
						$.messager.show({       
							title: 'Error',
							msg: result.msg
						});
					}
				},'json');
			}
		});
	}
}