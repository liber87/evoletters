//<?php
/**
 * modxmail
 *
 * Отправка писем штатными средствами MODX
 *
 * @category	snippet
 * @internal	@modx_category evoletters
 * @internal	@installset base
 * @internal	@overwrite true
 * @internal	@properties 
 */
$modx->loadExtension('MODxMailer');	
	$mail = $modx->mail;	
	
	if ($modx->config['email_method'] == 'smtp') 
	{
		$mail->IsSMTP();
		$mail->Host = $modx->config['smtp_host'];
		if ($modx->config['smtp_auth'] == 1)
		{
			$mail->SMTPAuth = true;
			$mail->Username = $modx->config['smtp_username'];
			$mail->Password = '-------';
			if ($modx->config['smtp_secure']!='none') $mail->SMTPSecure = $modx->config['smtp_secure'];
			$mail->Port = $modx->config['smtp_port'];	
		} 
		else $mail->SMTPAuth = false;		 
	}
	
	$mail->IsHTML(true);
	$mail->From = $modx->config['emailsender'];
	$mail->FromName = $modx->config['site_name'];
	$mail->Subject = $subject; 			
	$mail->Body = $content;
	$mail->addAddress($email); 
	$mail->send(); 
	$mail->ClearAllRecipients();
			
	return 'Success!';

