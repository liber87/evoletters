//<?php
/**
 * emailverification
 *
 * Валидация email адресов
 *
 * @category	snippet
 * @internal	@modx_category evoletters
 * @internal	@installset base
 * @internal	@overwrite true
 * @internal	@properties 
 */
if ($valid>0) return;
/* Used: https://quickemailverification.com/ */
$api_code = 'f783229c3dfd7f8b7859affcc09969f57c2f5219bfce9936e7f57a9de067';
//$email ='alexey@liber.pro';

$ch = curl_init("http://api.quickemailverification.com/v1/verify?email=".$email."&apikey=".$api_code);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($ch, CURLOPT_POST, 1);
curl_setopt($ch, CURLOPT_POSTFIELDS, $post);
curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 15);
curl_setopt($ch, CURLOPT_TIMEOUT, 30); 
$result = curl_exec($ch);
$json = json_decode($result, true);
if ($json['result']=='valid') $res = 2;
else $res = 1;	
$modx->db->update(array('valid'=>$res),$modx->getFullTableName('el_subscriber'),'id='.$id);

