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
	
	default:
		$success = false;
	break;
}

if (!$success) {
	echo "error";
}

$conn->close();


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
?>