<?php

require_once 'config.php';

function getUserByPseudo($pdo, $pseudo) {
  $sql = "SELECT * FROM `users` WHERE `pseudo` = ".$pseudo;
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



function create($pdo, $pseudo, $content, $title){
    $contenu = $content;
    if($pseudo == "" || $contenu == "" || $title == ""){
      $content = json_encode(["result" => []]);
    }else {
      $tabResult = [];
      $contenu = str_replace("'", "''", $contenu);
      $query = "INSERT INTO `todo`(`pseudo`, `content`, `title`) VALUES ('$pseudo','$contenu','$title')";
      $queryExect = $pdo->prepare($query);
      $queryExect->execute();
      $result = $queryExect->fetch();
      $tabResult = [
          0 => [
              "id" => $pdo->lastInsertId(),
              "pseudo" => $pseudo,
              "content" => $contenu,
              "title" => $title
          ]
      ];
      $content = json_encode(["result" => $tabResult]);
    }
}


function delete($pdo, $id){
    if($id == ""){
      $content = json_encode(["result" => []]);
    }else {
      $tabResult = [];
      $query = "DELETE FROM todo WHERE `id` = $id";
      $queryExect = $pdo->prepare($query);
      $queryExect->execute();
      $content = json_encode(["result" => ["id" => $id]]);
    }
}

function update($pdo, $pseudo, $content, $title, $id){
    $contenu = $content;
    if($pseudo == "" || $contenu == "" || $title == "" || $id == ""){
        $content = json_encode(["result" => []]);
    }else {
        $tabResult = [];
        $contenu = str_replace("'", "''", $contenu);
        $query = "UPDATE `todo` SET `id`='$id',`pseudo`='$pseudo',`content`='$contenu', `title`='$title' WHERE `id` = $id";
    $queryExect = $pdo->prepare($query);
        $queryExect->execute();
        $result = $queryExect->fetch();
        $tabResult = [
            0 => [
                "id" => $id,
                "pseudo" => $pseudo,
                "content" => $contenu,
                "title" => $title
            ]
        ];
        $content = json_encode(["result" => $tabResult]);
    }
}

function getAll($pdo, $pseudo){
    if($pseudo == null){
        $content = json_encode(["result" => []]);
    }else {
        $tabResult = [];
        $query = "SELECT * FROM todo WHERE `pseudo` = '$pseudo'";
        $responseQuery = $pdo->query($query)->fetchAll();
        foreach ($responseQuery as $result) {
            unset($result[0]);
            unset($result[1]);
            unset($result[2]);
            unset($result[3]);
            unset($result[4]);
            $tabResult[] = $result;
        }
        $content = json_encode(["result" => $tabResult]);
    }
}


$possible_url = array("get_user","get_users","create","delete","update","getAll");
$value ="Une erreur est survenue !";

if (isset($_GET["action"]) && in_array($_GET["action"], $possible_url)) { //si l'URL est OK
  switch ($_GET["action"]) {
    case "get_user":
      if (isset($_GET["pseudo"])) {
        $value = getUserByPseudo($pdo, $_GET["pseudo"]); break;
      } else {
        $value = "Argument manquant"; break;
      }
    case "get_users":
      $value = getUsers($pdo); break;
    case "create":
      $value = create($pdo, $_GET["pseudo"], $_GET["title"], $_GET["content"]); break;
    case "delete":
      $value = delete($pdo, $_GET["id"]); break;
    case "update"
      $value = update($pdo, $_GET["pseudo"], $_GET["content"], $_GET["title"], $_GET["id"]); break;
    case "getAll"
      $value= getAll($pdo, $_GET["pseudo"]); break;
  }
  exit(json_encode($value));
}
