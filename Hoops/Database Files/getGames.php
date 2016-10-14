<?php
include_once "global.php";

$success = true;

if (isset($_GET['court']))
	$court_id = $_GET['court'];

if (!is_numeric($court_id) || $court_id < 0 || $court_id != round($court_id, 0)) {
	$success = false;
}

if ($success) {
	$query = "SELECT * FROM Games WHERE court_id = '$court_id'";
	$query .= " AND date >= CURDATE()";
	$query .= " ORDER BY date_event ASC, starttime_event ASC";

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

	$conn->close();
}


if (!$success) {
	echo "error";
}
?>