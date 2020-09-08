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
	if ($('#groups_checkbox').length>0){
		var gr_chk = '';
		$.each(groups.rows, function( index, value ) {
			gr_chk = gr_chk+'<label><input id="grch'+value.id+'" class="grch" name="groups[]" type="checkbox" value="'+value.id+'"> '+value.name+'</label><br>';
		});
		$('#groups_checkbox').html(gr_chk);	
	}
});

function get_groups (val, row) 
{	
	if (!val) return;
	var gs = val.split(',');
	var gs_names = [];
	gs.forEach(function(item, i, gs) {
		var result = groups.rows.filter(function(el){
			return el.id.indexOf(item) > -1;//fieldName - поле по которому нужно фильтровать
		});
		if (result[0]) gs_names.push(result[0].name);
	});				
	
	return gs_names.join(', ');
}
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
		if(row.groups!='undefined'){		
			$('.grch').removeAttr("checked");
			var gsc = row.groups;
			var gs = gsc.split(',');
			$.each(gs, function( index, value ) {
				console.log('#grch'+value);
				$('#grch'+value).prop('checked', true);
			});
		}
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
