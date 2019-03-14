<?php
	
	ini_set("display_errors", "On");
	error_reporting(E_ALL | E_STRICT);
	
		#获取服务器配置
	include_once "servermgr.php";
	
	$playerid = isset($_GET['userid']) ? $_GET['userid'] : NULL;
	$serverid = isset($_GET['zoneid']) ? $_GET['zoneid'] : NULL;
	
	$mailid = 106;
	$content = isset($_GET['content']) ? $_GET['content'] : NULL;
	$currency_type = isset($_GET['currency_type']) ? $_GET['currency_type'] : NULL;
	$currency_value = isset($_GET['currency_value']) ? $_GET['currency_value'] : NULL;
	//$playerid = isset($_GET['playerid']) ? $_GET['playerid'] : NULL;
	//$serverid = isset($_GET['serverid']) ? $_GET['serverid'] : NULL;
	$thing1_id = isset($_GET['thing1_id']) ? $_GET['thing1_id'] : NULL;
	$thing1_num = isset($_GET['thing1_num']) ? $_GET['thing1_num'] : NULL;
	$thing2_id = isset($_GET['thing2_id']) ? $_GET['thing2_id'] : NULL;
	$thing2_num = isset($_GET['thing2_num']) ? $_GET['thing2_num'] : NULL;
	$thing3_id = isset($_GET['thing3_id']) ? $_GET['thing3_id'] : NULL;
	$thing3_num = isset($_GET['thing3_num']) ? $_GET['thing3_num'] : NULL;
	$thing4_id = isset($_GET['thing4_id']) ? $_GET['thing4_id'] : NULL;
	$thing4_num = isset($_GET['thing4_num']) ? $_GET['thing4_num'] : NULL;
	$thing5_id = isset($_GET['thing5_id']) ? $_GET['thing5_id'] : NULL;
	$thing5_num = isset($_GET['thing5_num']) ? $_GET['thing5_num'] : NULL;

	$params = [];
	array_push($params, array("language" => "en_US", "content" => $content));

	$params_arr = [];

	foreach ($params as $param) {
		$content_1 = $param['content'];
		$param['content'] = array($content_1);
		if (!empty($param['language']) && !empty($param['content'])) {
			array_push($params_arr, $param);
		}
	}
	
	$tokens = [];
	
	if ($currency_type == "1")
	{
		$currency_type = "ShiGong";
	} 
	else if($currency_type == "2")
	{
		$currency_type = "YinLiang";
	}
	else if($currency_type == "3")
	{
		$currency_type = "XianYu";
	}
	array_push($tokens, array("key" => $currency_type, "value" => $currency_value));
	$tokens_arr = [];

	foreach ($tokens as $token) {
		if (!empty($token['key']) && !empty($token['value'])) {
			$tokens_arr[$token['key']] = intval($token['value']);
		}
	}

	$things = [];
	if ($thing1_id != 0 && $thing1_num>0)
	{
		array_push($things, array("key" => $thing1_id, "value" => $thing1_num));
	}
	if ($thing2_id != 0 && $thing2_num>0)
	{
		array_push($things, array("key" => $thing2_id, "value" => $thing2_num));
	}
	if ($thing3_id != 0 && $thing3_num>0)
	{
		array_push($things, array("key" => $thing3_id, "value" => $thing3_num));
	}
	if ($thing4_id != 0 && $thing4_num>0)
	{
		array_push($things, array("key" => $thing4_id, "value" => $thing4_num));
	}
	if ($thing5_id != 0 && $thing5_num>0)
	{
		array_push($things, array("key" => $thing5_id, "value" => $thing5_num));
	}
	
	$things_arr = [];
	foreach ($things as $thing) {
		if (!empty($thing['key']) && !empty($thing['value'])) {
			if (empty($things_arr[$thing['key']]))
			{
				$things_arr[$thing['key']] = 0;
			}
			$things_arr[$thing['key']] += intval($thing['value']);
		}
	}

	$request['mailid'] = 106;
	$request['params'] = $params_arr;
	$request['tokens'] = $tokens_arr;
	$request['things'] = $things_arr;

	if (empty($mailid)) {
		die("邮件id不能为空! ");
	}

	foreach ($params as $pvalue) {
		if (empty($pvalue)) {
			die("参数不能为空! ");
		}
	}
	
	$mails = json_encode($request);

	$server = getServerCfg($serverid);
	if (!$server) {
		$data['status'] = 0;
		$data['text'] = "not found server";
		die(json_encode($data));
	}
	
	$host = 'http://' . $server['http_host'] . ':' . $server['http_port'];
	$url=sprintf('/sendmail?playerid=%d&mails=%s', $playerid, $mails);
	$ret = file_get_contents($host . $url);
	if ($ret == 0) {#成功
		$data['status'] = 1;
		$data['text'] = "suc";
	} else {
	    $data['status'] = 0;
		$data['text'] = "failed";
	}

	echo json_encode($data);
?>