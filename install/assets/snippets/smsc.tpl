//<?php
/**
 * smsc
 *
 * Отправка СМС сообщений через smsc.ru
 *
 * @category	snippet
 * @internal	@modx_category evoletters
 * @internal	@installset base
 * @internal	@overwrite true
 * @internal	@properties 
 */
if ($phone)
{	  
	$phone = preg_replace("/[^,.0-9]/", '', $phone);		  		
	$myCurl = curl_init();
	curl_setopt_array($myCurl, array(
	CURLOPT_URL => 'https://smsc.ru/sys/send.php',
	CURLOPT_RETURNTRANSFER => true,
	CURLOPT_POST => true,
	CURLOPT_POSTFIELDS => http_build_query(array('login'=>'xxxxxxxx','psw'=>'--------passat323','phones'=>$phone,'mes'=>$content))
	));
	$response = curl_exec($myCurl);
	curl_close($myCurl);
	
}

