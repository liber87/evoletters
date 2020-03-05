//<?php
/**
 * evoLetters
 *
 * Форма подписки
 *
 * @category	snippet
 * @internal	@modx_category evoletters
 * @internal	@installset base
 * @internal	@overwrite true
 * @internal	@properties 
 */

include_once(MODX_BASE_PATH.'assets/modules/evoletters/classes/evoletters.class.php');
$el = new evoLetters($modx);
$confirm = (isset($confirm)) ? $confirm : 1; // Нужно ли подтверждение на почту 1 - да.
$method = (isset($method)) ? $method : 'modxmail'; // Метод отправи письма
$subject_subscribe = (isset($subject_subscribe)) ? $subject_subscribe : '@CODE: Подтверждения подписки на сайте [+site_name+]'; // Тема подтверждения
$confirm_text = (isset($confirm_chunk)) ? $confirm_chunk : '@CODE: <p>Для завершения подписки на сайте [+site_name+] перейдите - <a href="[+subscribe_link+]">по ссылке</a></p>'; // Завершение подписки. [+subscribe_link+] - ссылка для подтверждения ящика.
$replace = (isset($replace)) ? $replace : 1; // Заменять форму результатом (по умолчанию - 1 - да), или вставлять результат сверху.
$yet_subscribe = (isset($yet_subscribe)) ? $subject_subscribe : '@CODE: <p>Вы уже подписаны</p>'; //Результат если уже есть подписка
$wrong_email = (isset($wrong_email)) ? $wrong_email : '@CODE: <p>Некорректный адрес электронной почты</p>'; //Некорректный эелектронный адрес
$success_subscribe = (isset($success_subscribe)) ? $success_subscribe : '@CODE: <p>Вы успешно подписались!</p>'; //Успешная подписка

$success_remove = (isset($success_remove)) ? $success_remove : '@CODE: <p>Подписка удалена</p>'; //Успешное удаление подписки
$subscribe_form = (isset($subscribe_form)) ? $subscribe_form : '@CODE: <form method="post"><input type="email" required="required" name="subscribe_email"><input type="submit"></form>'; //Простая форма подписки. Поле subscribe_email - единственное обязательное.
$subscribe_form = $el->tpl->parseChunk($subscribe_form);
$out='';


if (isset($_POST['subscribe_email']))
{
	$email = $modx->db->escape($_POST['subscribe_email']);
	if (!preg_match("/^(?:[a-z0-9]+(?:[-_.]?[a-z0-9]+)?@[a-z0-9_.-]+(?:\.?[a-z0-9]+)?\.[a-z]{2,5})$/i", $email)) $out=$wrong_email;
	else
	{		
		$count = $modx->db->getValue('Select count(*) from '.$el->tbl_el_subscriber.' where email="'.$email.'"');
		if ($count) 
		{
			if (!$out) $out= $el->tpl->parseChunk($yet_subscribe);		
		}
		else 
		{		
			$hash = md5($email.''.time());					
			$confirm = (bool)$confirm;
			$ci = (!$confirm);
			
			$forbidden_fields = array('id','date','count','hash','pid','confirmed','valid');
			$fields = array('email'=>$email,'confirmed'=>$ci,'hash'=>$hash,'pid'=>$modx->documentIdentifier,'date'=>time());
			
			$res = $modx->db->query('SHOW COLUMNS FROM '.$el->tbl_el_subscriber);
			while ($row = $modx->db->getRow($res))
			{
				if (($_POST[$row['field']]) && (!in_array($row['field'],$forbidden_fields))) $fields[$row['field']] = $modx->db->escape($_POST[$row['field']]);
			}	
			
			$sid = $modx->db->insert($fields,$el->tbl_el_subscriber);
			$fields['id'] = $sid;
			$modx->invokeEvent('OnELUserSubscription',$fields);
			
			if ($confirm)
			{	
				$confirm_text = $el->tpl->parseChunk($confirm_text);
				$fields = $el->createLetter('',$sid,$confirm_text,1);
				$fields['email'] = $email;				
				$modx->runSnippet($method,$fields);
			}						
			$out= $el->tpl->parseChunk($success_subscribe);			
		}
	}
}


if (!$replace) $out.= $subscribe_form;
else if (!$out) $out = $subscribe_form;
return '<a name="subscribe_block_status'.$id.'"></a><div id="subscribe_block_status'.$id.'">'.$out.'</div>';
