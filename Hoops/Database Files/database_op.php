<?php
include_once "global.php";

$success = true;

if (isset($_GET['function']))
	$function = $_GET['function'];
else
	$success = false;

switch ($function) {
	case 'getGames':
	getGames();
	break;

	case 'addGame':
	addGame();
	break;

	case 'getCourtId':
	getCourtId();
	break;
	
	default:
	$success = false;
	break;
}

if (!$success) {
	echo "error in address";
}

$conn->close();

/*
	Retrieve games from database (Games Table)

	-REQUIRED PARAMETERS:
	---------------------
	function=getGames
	court_id

	-RETURNS
	--------
	json array:
	{game_id, date, time, description, current_player_count, max_player_count, user_id}
*/

function getGames() {
	global $conn;
	global $success;
	if (isset($_GET['court']))
		$court_id = $_GET['court'];
	else
		$success = false;

	if (!is_numeric($court_id) || $court_id < 0 || $court_id != round($court_id, 0)) {
		$success = false;
	}

	if ($success) {
		$query = "SELECT * FROM Games WHERE court_id = '$court_id'";
		$query .= " AND date >= CURDATE()";
		$query .= " ORDER BY date ASC, time ASC";

		$result = $conn->query($query);

		$games = array();
		while ($row = $result->fetch_assoc()) {

			$array = array(
				"game_id" => $row['game_id'],
				"date" => $row['date'],
				"time" => $row['time'],
				"description" => $row['description'],
				"current_player_count" => $row['current_player_count'],
				"max_player_count" => $row['max_player_count'],
				"user_id" => $row['user_id']
				);
			$games[] = $array;
		}
		echo json_encode($games);
	}
}

/*
	Add game to database (Games Table)

	-REQUIRED PARAMETERS:
	---------------------
	function=addGame
	court_id, date, time, description, current_player_count, max_player_count, user_id

	-RETURNS
	--------
	N/A
*/

function addGame() {
	global $conn;
	global $success;

	if (isset($_GET['court_id']))
		$court_id = $_GET['court_id'];
	else
		$success = false;
	if (!is_numeric($court_id) || $court_id < 0 || $court_id != round($court_id, 0)) {
		$success = false;
	}

	if (isset($_GET['date']))
		$date = $_GET['date'];
	else
		$success = false;

	if (isset($_GET['time']))
		$time = $_GET['time'];
	else
		$success = false;

	if (isset($_GET['description']))
		$description = $_GET['description'];
	else
		$success = false;	

	if (isset($_GET['current_player_count']))
		$current_player_count = $_GET['current_player_count'];
	else
		$success = false;
	if (!is_numeric($current_player_count) || $current_player_count < 0 || $current_player_count != round($current_player_count, 0)) {
		$success = false;
	}

	if (isset($_GET['max_player_count']))
		$max_player_count = $_GET['max_player_count'];
	else
		$success = false;
	if (!is_numeric($max_player_count) || $max_player_count < 0 || $max_player_count != round($max_player_count, 0)) {
		$success = false;
	}

	if (isset($_GET['user_id']))
		$user_id = $_GET['user_id'];
	else
		$success = false;
	if (!is_numeric($user_id) || $user_id < 0 || $user_id != round($user_id, 0)) {
		$success = false;
	}

	if ($success) {
		if ($stmt = $conn->prepare("INSERT INTO 
			Games (court_id, date, time, description, current_player_count, max_player_count, user_id)
			VALUES
			('$court_id', ?, ?, ?, '$current_player_count', '$max_player_count', '$user_id')")) {

			$stmt->bind_param('sss', $date, $time, $description);
			$stmt->execute();
			$game_id = $stmt->insert_id;
			$stmt->close();
		}
	}
}

/*
	Retrieve court_id (if exists otherwise add to database)

	-REQUIRED PARAMETERS:
	---------------------
	function=getCourtId
	lat, lng

	-RETURNS
	--------
	court_id
*/

function getCourtId() {
	global $conn;
	global $success;

	if (isset($_GET['lat']))
		$lat = $_GET['lat'];
	else
		$success = false;

	if (isset($_GET['lng']))
		$lng = $_GET['lng'];
	else
		$success = false;

	if (!is_numeric($lat) || !is_numeric($lng))
		$success = false;

	$court_id = -1;

	if ($success) {
		$query = "SELECT court_id FROM Court WHERE ABS(latitude - '$lat') < 0.00005 AND ABS(longitude - '$lng') < 0.00005";
		$result = $conn->query($query);

		if ($result->num_rows > 0) {
			while ($row = $result->fetch_assoc()) {
				$court_id =  $row['court_id'];
				break;
			}
		}
		else {
			$query = "INSERT INTO Court (latitude, longitude) VALUES ('$lat', '$lng')";
			$conn->query($query);
			$court_id = $conn->insert_id;
		}
	}

	$result = array("court_id" => $court_id);
	echo json_encode($result);
}

?>