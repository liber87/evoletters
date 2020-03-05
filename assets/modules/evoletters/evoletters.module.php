<?php	
	if (IN_MANAGER_MODE != "true" || empty($modx) || !($modx instanceof DocumentParser)) {
		die("<b>INCLUDE_ORDERING_ERROR</b><br /><br />Please use the MODX Content Manager instead of accessing this file directly.");
	}
	if (!$modx->hasPermission('exec_module')) {
		header("location: " . $modx->getManagerPath() . "?a=106");
	}
	if(!is_array($modx->event->params)){
		$modx->event->params = array();
	}	
	
	include_once(dirname(__FILE__).'/classes/evoletters.class.php');
	$el = new evoLetters($modx);	
	
	$moduleurl = 'index.php?a=112&id='.$_GET['id'].'&';
	$tab = isset($_GET['tab']) ? $_GET['tab'] : 'home';
	$wid = isset($_GET['wid']) ? $_GET['wid'] : '';
	$action = $_GET['action'];
	//if ((!$action) && (isset($_SESSION['write_log']))) unset($_SESSION['write_log']);
	
	
	
	$data = array (
	'moduleurl'=>$moduleurl,
	'edit_button'=>'',	
	'manager_theme'=>$modx->config['manager_theme'],
	'session'=>$_SESSION,
	'get'=>$_GET,
	'action'=>$action,
	'tab'=>$tab,
	'selected'=>array($tab=>'selected'),
	'templates'=>$el->getNamesTemlates(),
	'templates_json'=>$el->getNamesTemlatesJSON(),
	'methods'=>$el->getNamesMethods(),
	'rte'=>$el->rte(''),
	'CM_URL'=>$el->CM()
	);
	if ($tab=='edit_template') $data['edit_button'] = '<h2 class="tab selected"><span>Редактирование шаблона</span></h2>';		
	else if ($tab=='edit_letter') $data['edit_button'] = '<h2 class="tab selected"><span>Редактирование письма</span></h2>';		
	
	
	$tpls = array('home','templates','distribution','letters','edit_template','edit_letter','methods');
	if (in_array($tab,$tpls)) $outTpl = $el->getTemplate($tab,$data);		
	
	
	if ($action=='getData') $json = $el->getData($_GET['table'],$wid);
	if ($action=='setDataTemplate') $json = $el->setDataTemplate($_REQUEST);
	if ($action=='setDistribution') 
	{
		$json = $el->distribution(array('id_letter'=>$_REQUEST['el_id'],'offset'=>$_REQUEST['offset']));
	}
	if ($action=='getExtendInfoSubscriber')
	{
		echo $el->getExtendInfoSubscriber($_GET['sid']);
		exit();
	}
	
	if (isset($_REQUEST['crud']))
	{				
		$act = $_REQUEST['crud'];
		$allowed_action = array('insert','update','delete');					
		if (in_array($act,$allowed_action)) $json = $el->crud($act,$_REQUEST);		
	}
	
	if ($json)
	{
		header('Content-type: application/json');
		echo $json;
		exit();
	}	
	
	if(!is_null($outTpl))
	{
		$headerTpl = '@CODE:'.file_get_contents(dirname(__FILE__).'/templates/header.tpl');
		$footerTpl = '@CODE:'.file_get_contents(dirname(__FILE__).'/templates/footer.tpl');
		$output = $el->tpl->parseChunk($headerTpl,$data) . $outTpl . $el->tpl->parseChunk($footerTpl,$data);
		echo $output;
	}
		