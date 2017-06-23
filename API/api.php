<?php

require_once 'config.php';

function getUserById($pdo, $id) {
  $sql = "SELECT * FROM `users` WHERE `id` = ".$id;
  $exe = $pdo->query($sql);

  while($result = $exe->fetch(PDO::FETCH_OBJ)) {
      $user = array("pseudo"    => $result->pseudo,
                    "firstName" => $result->firstname,
                    "id"        => $result->id,
                    "password"  => $result->password);
  }
      return $user;
}

function getUsers($pdo){
  $sql = "SELECT * FROM `users`";
  $exe = $pdo->query($sql);
  $listUsers = array();

  while($result = $exe->fetch(PDO::FETCH_OBJ)) {
    array_push($listUsers, array("pseudo"    => $result->pseudo,
                                 "firstName" => $result->firstname,
                                 "id"        => $result->id,
                                 "password"  => $result->password));
  }
  return $listUsers;
}


$possible_url = array("get_user","get_users");
$value ="Une erreur est survenue !";

if (isset($_GET["action"]) && in_array($_GET["action"], $possible_url)) { //si l'URL est OK
  switch ($_GET["action"]) {
    case "get_user":
      if (isset($_GET["id"])) {
        $value = getUserById($pdo, $_GET["id"]); break;
      } else {
        $value = "Argument manquant"; break;
      }
    case "get_users":
      $value = getUsers($pdo); break;
  }
  exit(json_encode($value));
}
