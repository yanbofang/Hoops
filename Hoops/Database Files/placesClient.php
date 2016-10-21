<?php
include_once "googlePlaces.php";
include_once "global_api_keys.php";

$apiKey       = $google_maps_places_key;
$googlePlaces = new googlePlaces($apiKey);

// Set the longitude and the latitude of the location you want to search near for places
$latitude   = $_GET['lat'];
$longitude = $_GET['lng'];
$googlePlaces->setLocation($latitude . ',' . $longitude);

$googlePlaces->setRadius(5000);
$googlePlaces->setKeyword('basketball%20courts');
$results = $googlePlaces->search(); //

?>