<?php

include_once "global_api_keys.php";

$success = true;

if (isset($_GET['function']))
	$function = $_GET['function'];
else
	$success = false;

switch ($function) {
	case 'getCourts':
	getCourts();
	break;
	
	default:
	$success = false;
	break;
}

if (!$success) {
	echo "error in address";
}

/*
	Retrieve nearby courts from Google Maps

	-REQUIRED PARAMETERS:
	---------------------
	function=getCourts
	lat, lng, radius

	-RETURNS
	--------
	json array:
	{name, lat, lng}
*/


function getCourts() {

	if (isset($_GET['lat']))
		$lat = $_GET['lat'];
	if (isset($_GET['lng']))
		$lng = $_GET['lng'];
	if (isset($_GET['radius']))
		$radius = $_GET['radius'];

	$url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=".$lat.",".$lng."&radius=".$radius."&keyword=basketball%20court&key=AIzaSyDFtH9hBdaMmIxkLOwwzJqt_x_D74nCQyo";

//  Initiate curl∂∂
	$ch = curl_init();
// Disable SSL verification
	curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, true);
// Will return the response, if false it print the response
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
// Set the url
	curl_setopt($ch, CURLOPT_URL,$url);
// Execute
	$data=curl_exec($ch);
// Closing
	curl_close($ch);

	$result = json_decode($data, true);

	$length = count($result['results']);

	$output = array();
	for($i=0; $i<$length; $i++) {
		$inner = array(
			"name" => $result['results'][$i]['name'],
			"lat" => $result['results'][$i]['geometry']['location']['lat'],
			"lng" => $result['results'][$i]['geometry']['location']['lng'],
			);
		$output[] = $inner;
	}

	echo json_encode($output);
}

?>