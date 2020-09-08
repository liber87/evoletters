<?php
	/*
		* based on evoLetters by Alexey Liber 
	*/
	
	class evoLetters {
		
		public $tbl_el_subscriber = '';
		public $tbl_el_templates = '';
		public $tbl_el_letters = '';		
		public $tbl_el_methods = '';
		public $tbl_site_content = '';
		
	    public function __construct($modx, $params = null) {
			$this->modx = $modx;        
			include_once(MODX_BASE_PATH.'assets/snippets/DocLister/lib/DLTemplate.class.php');
			$tpl = DLTemplate::getInstance($modx);
			$this->tpl = $tpl;
			$this->tplFolder = MODX_BASE_PATH.'assets/modules/evoletters/templates/';
			$this->tbl_el_subscriber = $modx->getFullTableName('el_subscriber');
			$this->tbl_el_templates = $modx->getFullTableName('el_templates');
			$this->tbl_el_letters = $modx->getFullTableName('el_letters');			
			$this->tbl_el_methods = $this->modx->getFullTableName('el_methods');
			$this->tbl_el_groups = $this->modx->getFullTableName('el_groups');
			$this->tbl_site_content = $this->modx->getFullTableName('site_content');
		}
		/*
			* Выдаем нужную страничку в модуле
		*/
		public function getTemplate($tpl,$data)
		{	
			
			if (file_exists($this->tplFolder.$tpl.'.custom.tpl')) $code = file_get_contents($this->tplFolder.$tpl.'.custom.tpl');			
			else if (file_exists($this->tplFolder.$tpl.'.tpl')) $code = file_get_contents($this->tplFolder.$tpl.'.tpl');			
			else $code = '<p>Не верно указано имя шаблона или данный шаблон не существует!</p>';			
			$template = '@CODE:'.$code;
			$outTpl = $this->tpl->parseChunk($template,$data);
			return $outTpl;
		}
		
		/*
		* Получаем названия шаблонов для select
		*/
		public function getNamesTemlates()
		{		
			
			$table = $this->tbl_el_templates;
			$rs = $this->modx->db->query("select id,name from $table");			
			while($row = $this->modx->db->getRow($rs)){
				$options.='<option value="'.$row['id'].'">'.$row['name'].'</option>';				
			}
			return $options;	
		}
		
		
		/*
		* Получаем названия шаблонов в формате JSON для вставки в табличку
		*/
		public function getNamesTemlatesJSON()
		{		
			
			$table = $this->tbl_el_templates;
			$rs = $this->modx->db->query("select id,name from $table");
			$items = array();
			while($row = $this->modx->db->getRow($rs)) $items[$row['id']] = $row['name'];					
			return json_encode($items);
		}
		
		/*
			* Получаем названия методов
		*/
		public function getNamesMethods()
		{		
			
			$e_table = $this->modx->getFullTableName('el_methods');
			$s_table = $this->modx->getFullTableName('site_snippets');
			
			$rs = $this->modx->db->query("SELECT m.id,m.name,m.method FROM $e_table as m
			join $s_table as s
			on m.`method`= s.`name`");
			$options = '';
			while($row = $this->modx->db->getRow($rs)){				
				$options.='<option value="'.$row['method'].'">'.$row['name'].'</option>';
			}
			return $options;			
		}
		
		/*
			* Подключаем визуальный редактор. 
		*/
		
		public function rte($content)
		{		  
			/*$event_output = $this->modx->invokeEvent("OnRichTextEditorInit", array('editor'=>$this->modx->config['which_editor']));		
			if(is_array($event_output)) {
				$editor_html = implode("",$event_output);
			}
			На 2.0 не работает, надо разобраться
			*/	
			$run = '
			<script type="text/javascript">
			jQuery(document).ready(function() {			
				setTimeout((arg) => {tinymce.init({"selector":"#editor"})},500);
			});
			</script>';
			
			return '<script src="/assets/plugins/tinymce4/tinymce/tinymce.min.js"></script>'.$editor_html.$run;
		}
		
		/*
		* Подключаем CodeMiorr
		*/
		public function CM()
		{	
			$_CM_BASE = 'assets/plugins/codemirror/';
			$_CM_URL = $this->modx->config['site_url'] . $_CM_BASE;
			return $_CM_URL;			
		}
		
		/*
		* Получаем данные из таблички
		*/
		public function getData($tbl,$wid = '')
		{
			
			$table = $this->modx->getFullTableName($tbl);
			$page = isset($_POST['page']) ? intval($_POST['page']) : 1;
			$rows = isset($_POST['rows']) ? intval($_POST['rows']) : 10;
			$where = ($wid) ? 'where id='.$wid : '';
			
			$offset = ($page-1)*$rows;
			$result = array();
			
			$count = $this->modx->db->getValue( $this->modx->db->query("select count(*) from $table"));
			$result["total"] = $count;
			$rs = $this->modx->db->query("select * from $table $where limit $offset,$rows");
			
			$items = array();
			while($row = $this->modx->db->getRow($rs)){
				array_push($items, $row);
			}
			$result["rows"] = $items;
			
			return json_encode($result);			
		}		
		
		/*
		* Получаем информацию о подписчике
		*/
		
		public function getExtendInfoSubscriber($sid)
		{
			if (!is_numeric($sid)) return '<b>Invalid response</b>';
			else
			{$sql = $this->modx->db->query('Select * from '.$this->tbl_el_subscriber.' as es
				left join '.$this->tbl_site_content.' as c
				on es.pid = c.id where es.id='.$sid);
				$row = $this->modx->db->getRow($sql);
				if (!$row['pagetitle']) $row['pagetitle']='Добавлено администратором';
			return $this->tpl->parseChunk('@CODE: <p><b>Комментарий</b>: [+comment+]</p><p>Страница подписки: [+pagetitle+]</p>',$row);}
		}
		
		/*
		* Пишем/меняем/удаляем данные в таблице
		*/
		public function crud($act,$data)
		{		
			
			$table = $this->modx->getFullTableName($data['table']);
			
			switch ($act)
			{
				case 'insert':
				$fields = array();				
				$sql = $this->modx->db->query('SHOW COLUMNS FROM  '.$table);				
				while ($row = $this->modx->db->getRow($sql)) 
				{		
					$field = $row['Field'];
					if (($data[$field]) && ($field!='id')) 
					{
						if (is_array($data[$field])) $fields[$field] = implode(',',$data[$field]);
						else $fields[$field] = $data[$field];
					}
					if ($field=='hash') $fields['hash']=md5(time());
				}		
								
				$result = $this->modx->db->insert($fields,$table);														
				break;
				
				case 'update':								
				$fieldSql = $this->modx->db->select("*", $table, '', '', '1');
				$row = $this->modx->db->getRow( $fieldSql );
				foreach($row as $key => $val){
					$fieldlist[] = $key;
				}
				$fields = array();
								
				foreach($data as $key => $val){
					if(in_array($key,$fieldlist)) {
						if (is_array($val)) $fields[$key] = implode(',',$val);						
						else $fields[$key] = $val;
					}
				}						
				
				$result = $this->modx->db->update( $fields, $table, 'id = "' . $data['id'] . '"' );				
				break;
				
				case 'delete':
				$result = $this->modx->db->delete($table, "id = ".$data['id']);				
				break;
			}
			if ($result){
				return json_encode(array('success'=>true));
                } else {
				return json_encode(array('msg'=>'Произошла непредвиденная ошибка!'));
			}
		}
		
		
		/*
		* Сама рассылка
		*/
		public function distribution($data)
		{			
			if (is_array($data)) extract($data);
			
			if (!$offset) $offset = 0;
			$res = $this->modx->db->query('Select subject,content,method,groups from '.$this->tbl_el_letters.' where `id`='.$id_letter);
			$row = $this->modx->db->getRow($res);
			extract($row);				
			if (!isset($_SESSION['step_distribution'])) $_SESSION['step_distribution'] = 0;
			else if ($_SESSION['step_distribution']!=$offset) $offset = $_SESSION['step_distribution'];
			
			
			//Начинаем лог
			if (!isset($_SESSION['write_log'])){
				$this->modx->logEvent(0, 1, '<p>Рассылка письма <b>'.$name.'</b></p>
				<p>Начало <b>'.date("d-m-Y H:i:s",time()).'</b></p>				
				<p>Отправлено:</p>', 
				'evoLetters');
				$_SESSION['write_log'] = $this->modx->db->getInsertId();
				$this->modx->invokeEvent('OnBeforeDistribution',$data);
				
			}
			
			if ($groups){
				$wheres = array();
				$gp = explode(',',$groups);
				foreach($gp as $g){
					$wheres[] = '((`groups`='.$g.') or (`groups` like "'.$g.',%") or (`groups` like "%,'.$g.'") or (`groups` like "%,'.$g.',%"))';
				}
				$where = implode(' or ',$wheres).' and ';
			}
			
			$ct = $this->modx->db->getValue('Select count(*) from '.$this->tbl_el_subscriber.' where '.$where.' confirmed=1');
			$res = $this->modx->db->query('Select * from '.$this->tbl_el_subscriber.' where '.$where.' confirmed=1 limit '.$offset.',1');
			$user = $this->modx->db->getRow($res);
			
			
			if ($ct==$offset){					
				$status = 'success';
				$this->modx->db->query('UPDATE '.$this->modx->getFullTableName('event_log').' SET `description`=CONCAT(description,"<br>","<p>Завершено в '.time().'</p>") WHERE `id`='.$_SESSION['write_log']);
				unset($_SESSION['write_log']);					
				unset($_SESSION['step_distribution']);	
				$this->modx->db->query('Update '.$this->tbl_el_letters.' set 
				`count` = (`count`+1) where id='.$id_letter);				
				$this->modx->invokeEvent('OnAfterDistribution',$data);				
			}else {
				$status = 'continue';
				$_SESSION['step_distribution'] = $offset+1;
				$fields = array();
				//Добавляем [+content+],[+unscribe_link+],[+subscribe_link+]
				foreach($this->createLetter($id_letter,$user['id']) as $k=>$v) $fields[$k]=$v;
				//Добавляем поля пользователя
				
				foreach($user as $k=>$v) $fields[$k]=$v;
				$this->modx->runSnippet($method,$fields);
				
				//Пишем в лог юзверя									
				$this->modx->db->query('UPDATE '.$this->modx->getFullTableName('event_log').' SET `description`=CONCAT(description,"","'.$user['email'].'<br>") WHERE `id`='.$_SESSION['write_log']);					
				//Увеличиваем счетчик
				$this->modx->db->query('Update '.$this->tbl_el_subscriber.' set 
				`count` = (`count`+1) where id='.$user['id']);
			}			
			return json_encode(array('next'=>$offset+1, 'status'=>$status,'ct'=>$ct));
		}
		
		/*
		* Рассылка по cron'у
		*/
		public function distributionCron($id_letter)
		{			
		
			$res = $this->modx->db->query('Select subject,content,method from '.$this->tbl_el_letters.' where `id`='.$id_letter);
			$row = $this->modx->db->getRow($res);
			extract($row);				
			$this->modx->logEvent(0, 1, '<p>Рассылка письма <b>'.$name.'</b></p>
				<p>Начало <b>'.date("d-m-Y H:i:s",time()).'</b></p>				
				<p>Отправлено:</p>', 
				'evoLetters');
				$_SESSION['write_log'] = $this->modx->db->getInsertId();
				$this->modx->invokeEvent('OnBeforeDistribution',$data);	
						
			$ct = $this->modx->db->getValue('Select count(*) from '.$this->tbl_el_subscriber.' where confirmed=1');
			$res = $this->modx->db->query('Select * from '.$this->tbl_el_subscriber.' where confirmed=1');
			while ($user = $this->modx->db->getRow($res))
			{
				$fields = array();
				//Добавляем [+content+],[+unscribe_link+],[+subscribe_link+]
				foreach($this->createLetter($id_letter,$user['id']) as $k=>$v) $fields[$k]=$v;
				//Добавляем поля пользователя
				
				foreach($user as $k=>$v) $fields[$k]=$v;
				$this->modx->runSnippet($method,$fields);
				
				//Пишем в лог юзверя									
				$this->modx->db->query('UPDATE '.$this->modx->getFullTableName('event_log').' SET `description`=CONCAT(description,"","'.$user['email'].'<br>") WHERE `id`='.$_SESSION['write_log']);					
				//Увеличиваем счетчик
				$this->modx->db->query('Update '.$this->tbl_el_subscriber.' set 
				`count` = (`count`+1) where id='.$user['id']);					
			}
			
			$this->modx->db->query('UPDATE '.$this->modx->getFullTableName('event_log').' SET `description`=CONCAT(description,"<br>","<p>Завершено в '.time().'</p>") WHERE `id`='.$_SESSION['write_log']);
			
			$this->modx->db->query('Update '.$this->tbl_el_letters.' set 
			`count` = (`count`+1) where id='.$id_letter);				
			$this->modx->invokeEvent('OnAfterDistribution',$data);
			return "It's all ok!";
		}
		
		/*
			* Из шаблона делаем письмо
			* lid - id письма
			* uid - id юзверя
			* content - если хотим передать текст не из письма
			* tpl_id - id используемого шаблона.
		*/
		public function createLetter($lid, $uid, $content = '',$tpl_id = '')
		{				
			if ((!$lid) and (!$tpl_id)) return;
			
			if (!$tpl_id) $tpl_id = $this->modx->db->getValue('Select `tpl` from '.$this->tbl_el_letters.' where id='.$lid); 
			
			$res = $this->modx->db->query('Select * from '.$this->tbl_el_templates.' where id='.$tpl_id);
			$row = $this->modx->db->getRow($res);
			extract($row);
			
			if (!$content) 
			{
				$res = $this->modx->db->query('Select * from '.$this->tbl_el_letters.' where id='.$lid);
				$row = $this->modx->db->getRow($res);
				extract($row);				
			}
			
			
			
			$res = $this->modx->db->query('Select * from '.$this->tbl_el_templates.' where id='.$tpl_id);
			$template = $this->modx->db->getRow($res); //Получаем все поля шаблона			
			$template['template'] = str_replace('[+content+]',$content,$template['template']);			
			
			$data = array('content'=>$content,'subject'=>$subject,'unscribe_link'=>$this->generateUnscribeLink($uid),'subscribe_link'=>$this->generateSubscribeLink($uid),'site_name'=>$this->modx->config['site_name']);		
			
			$letter = array();
			$letter['content'] = $this->replaceText($template['template'],$data);
			$letter['content'] = $this->modx->parseDocumentSource($letter['content']);
			$letter['subject'] = $subject;			
			
			return $letter;
		}
		
		/*
			* Получаем данные для шаблона/письма
		*/
		public function getDataTemplate($tid)
		{
			$table = $this->modx->getFullTableName($_REQUEST['table']);			
			$res = $this->modx->db->query('Select * from '.$table.' where id='.$tid);			
			return $this->modx->db->getRow($res);
		}
		
		/*
			* Сохраняем данные шаблона/письма
		*/
		public function setDataTemplate($data)
		{
			if (!isset($data['groups'])) $data['groups']='';
			$table = $this->modx->getFullTableName($data['table']);
			$fieldSql = $this->modx->db->query("SHOW COLUMNS from ".$table);
			while($row = $this->modx->db->getRow( $fieldSql ))
			{
				$fieldlist[] = 	$row['Field'];
			}	
			$fields = array();
			
			foreach($data as $key => $val){
				if(in_array($key,$fieldlist)) {					
					if (is_array($val)) $fields[$key] = implode(',',$val);						
					else $fields[$key] = $this->modx->db->escape($this->modx->removeSanitizeSeed($val));
				}
			}					
			if ($data['id'])
			{
				$result = $this->modx->db->update( $fields, $table, 'id = "' . $data['id'] . '"' );
				if( $result ) {
					$outData = json_encode(array('status'=>'success'));
					} else {
					$outData = json_encode(array('msg'=>'error'));
				}
				return $outData;
			}
			else 
			{
				$newid = $this->modx->db->insert( $fields, $table);
				if ($newid) return json_encode(array('id'=>$newid));
			}
		}
		
		/*
			* Получаем существующие шаблоны для постановки в письмо
		*/
		public function getTemplateOptions()
		{
			$tpls= array();
			$res = $this->modx->db->query('Select * from '.$this->tbl_el_templates);
			while($row = $this->modx->db->getRow($res)) $tpls[] = array('id'=>$row['id'], 'value' => $row['name']);			
			return $tpls;
		}
		
		/*
			* Замена плейсхолдеров на значения
		*/
		
		public function replaceText($content,$data)
		{
			if (!$content) return; 
			$replacements = array(); 
			foreach ($data as $name => $value) 
			{ 
				$replacements['[+'.$name.'+]'] = is_array($value) ? implode(', ', $value) : $value; 
			}
			return strtr($content, $replacements);
		}		
		
		/*
			* Генерация ссылки на отписку
		*/
		public function generateUnscribeLink($sid)
		{
			if (!$sid) return;
			$hash = $this->modx->db->getValue('Select `hash` from '.$this->tbl_el_subscriber.' where `id`='.$sid);
			$link = $this->modx->config['site_url']."unscribe_process?uid=".$sid."&hash=".$hash;
			return $link;			
		}
		
		/*
			* Генерация ссылки на подписку
		*/
		public function generateSubscribeLink($sid)
		{
			if (!$sid) return;
			$hash = $this->modx->db->getValue('Select `hash` from '.$this->tbl_el_subscriber.' where `id`='.$sid);
			if (!$hash) {
				$hash = md5($sid.'h7'.$sid.'@'.$sid.time());
				$this->modx->db->query('Update '.$this->tbl_el_subscriber.' set hash="'.$hash.'" where `id`='.$sid);				
				}
			$link = $this->modx->config['site_url']."subscribe_process?uid=".$sid."&hash=".$hash;
			return $link;			
		}
		
		/*
			* Задаем шаблон для строки
		*/
		public function getTemplateStr($pid,$str,$tbl)
		{
			if ($pid==0) return '0';
			$table = $this->modx->getFullTableName($tbl);
			$resource = $this->modx->db->query('Select * from '.$table.' where id='.$pid);			
			$data = $this->modx->db->getRow($resource);
			return $this->tpl->parseChunk($str,$data);
		}		
	}											
