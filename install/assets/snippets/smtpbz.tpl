//<?php
/**
 * smtp.bz
 *
 * Отправка писем через сервис smtp.bz
 *
 * @category	snippet
 * @internal	@modx_category evoletters
 * @internal	@installset base
 * @internal	@overwrite true
 * @internal	@properties 
 */
$url = "https://api.smtp.bz/v1/smtp/send";
	$post_data = array (
    'from'=>'xxxxxx@yyyyyy.zzz',
	'name'=>'Robot Site',
	'reply-to'=>'no-reply@yyyyyyy.zzz',
	'to'=>$email,
	'subject'=>$subject,
	'html'=>$content
	);

	$ch = curl_init();
	curl_setopt($ch,CURLOPT_HTTPHEADER,array('Content-Type: multipart/form-data','authorization: --------1TwtpKUeQulsiPRmqaJ3g2yHqG'));
	curl_setopt($ch, CURLOPT_URL, $url);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
	curl_setopt($ch, CURLOPT_POST, 1);
	curl_setopt($ch, CURLOPT_POSTFIELDS, $post_data);
	$output = curl_exec($ch);
	curl_close($ch);

