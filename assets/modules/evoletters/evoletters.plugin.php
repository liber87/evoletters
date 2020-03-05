<?php
	if (!defined('MODX_BASE_PATH')) {
		die('What are you doing? Get out of here!');
	}		
	
	include_once(MODX_BASE_PATH.'assets/modules/evoletters/classes/evoletters.class.php');			
	$el = new evoLetters($modx);	
		
	if (($_REQUEST['q']=='subscribe_process') || ($_REQUEST['q']=='unscribe_process'))
	{				
		$hash = $modx->db->escape($_GET['hash']);
		$uid = (int) $_GET['uid'];
		if ((!$hash) || (!$uid)) $modx->sendUnauthorizedPage();
		else
		{
			$email = $modx->db->getValue('Select `email` from '.$el->tbl_el_subscriber.' where `hash`="'.$hash.'" and `id`="'.$uid.'"');
			if (!$email) $modx->sendUnauthorizedPage();
			else
			{
				if ($_REQUEST['q']=='subscribe_process')
				{
					$hash = md5($email.''.time());						
					$modx->db->update(array('hash'=>$hash,'confirmed'=>1),$el->tbl_el_subscriber,'email="'.$email.'"');
					$modx->invokeEvent('OnELConfirmingUsersSubscription',array('email'=>$email,'uid'=>$uid));
					
					if (!$succes_page) $url = $modx->config['site_start'];
					else
					{
						if (is_numeric($succes_page)) $url = $modx->makeUrl($succes_page);
						else $url = $succes_page;
					}
					$unscribe = $el->generateUnscribeLink($uid);
					
					$subscribe_subject = $el->tpl->parseChunk($succes_subscribe_subject,array('site_name'=>$modx->config['site_name']));   
					$subscribe_text = $el->tpl->parseChunk($succes_subscribe_text,array('url'=>$unscribe,'site_name'=>$modx->config['site_name']));	
					
					$fields = $el->createLetter('',$uid,$subscribe_text,2);
					$fields['subject'] = $subscribe_subject;
					$fields['email'] = $email;						
					
					$modx->runSnippet($method,$fields);
					
					header('Location: '.$url);
					exit();
				}
				else
				{
					
					$modx->db->query('Delete from '.$el->tbl_el_subscriber.' where id='.$uid);
					$modx->invokeEvent('OnELConfirmingUsersSubscription',array('email'=>$email,'uid'=>$uid));
					
					if (!$succes_page_unscribe) $url = $modx->config['site_start'];
					else
					{
						if (is_numeric($succes_page_unscribe)) $url = $modx->makeUrl($succes_page_unscribe);
						else $url = $succes_page_unscribe;
					}
					
					$succes_unscribe_subject = $el->tpl->parseChunk($succes_unscribe_subject,array('site_name'=>$modx->config['site_name']));   
					$succes_unscribe_text = $el->tpl->parseChunk($succes_unscribe_text,array('site_name'=>$modx->config['site_name']));		
					
					$fields = $el->createLetter('',$uid,$succes_unscribe_text,1);
					$fields['subject'] = $succes_unscribe_subject;
					$fields['email'] = $email;						
					
					$modx->runSnippet($method,$fields);
					
					header('Location: '.$url);
					exit();
					
				}
			}					
		}
	}			
