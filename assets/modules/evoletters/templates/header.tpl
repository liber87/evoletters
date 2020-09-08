<!DOCTYPE html>
<html>
	<head>
		<link rel="stylesheet" type="text/css" href="media/style/[+manager_theme+]/style.css" /> 
		<link rel="stylesheet" type="text/css" href="./../assets/modules/evoletters/css/easyui.css">
        <link rel="stylesheet" type="text/css" href="./../assets/modules/evoletters/css/icon.css">
        
		
		<script type="text/javascript" src="./../assets/modules/evoletters/js/jquery-1.9.1.min.js"></script>
        <script type="text/javascript" src="./../assets/modules/evoletters/js/jquery.easyui.min.js"></script>
        <script type="text/javascript" src="./../assets/modules/evoletters/js/datagrid-detailview.js"></script>
        <script type="text/javascript" src="./../assets/modules/evoletters/js/script.js"></script>
		<script>
			moduleurl = '[+moduleurl+]';
		</script>
		<style>
		.sectionBody td, .sectionBody th{vertical-align:middle;}
		</style>
	</head>
	<body>
		<h1>[+session.itemname+]</h1>
		<div id="actions">
			<ul class="actionButtons">			
				<li id="Button5"><a onclick="document.location.href='index.php?a=106';" href="#"> Закрыть</a></li>			
			</ul>
		</div>
		<div class="sectionBody">
			<div id="modulePane" class="dynamic-tab-pane-control tab-pane">
				<div class="tab-row">
					<h2 class="tab [+selected.home+]"><a href="[+moduleurl+]tab=home"><span>Подписчики</span></a></h2>
					<h2 class="tab [+selected.templates+]"><a href="[+moduleurl+]tab=templates"><span>Шаблоны</span></a></h2>
					<h2 class="tab [+selected.letters+]"><a href="[+moduleurl+]tab=letters"><span>Письма</span></a></h2>					
					<h2 class="tab [+selected.el_methods+]"><a href="[+moduleurl+]tab=methods"><span>Методы</span></a></h2>					
					<h2 class="tab [+selected.groups+]"><a href="[+moduleurl+]tab=groups"><span>Группы</span></a></h2>
					[+edit_button+]					
				</div>     				
