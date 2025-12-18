<?php

$uri = $_SERVER['REQUEST_URI'];
$method = $_SERVER['REQUEST_METHOD'];

if ($uri === '/auth/login' && $method === 'POST') {
    $db = require __DIR__ . '/../config/database.php';

    $userRepo = new UserRepository($db);
    $authService = new AuthService($userRepo);
    $controller = new AuthController($authService);

    $controller->login();
}

require_once __DIR__ . '/../app/Middleware/AuthMiddleware.php';

if ($uri === '/attendance/checkin' && $method === 'POST') {
    AuthMiddleware::handle();

    // lanjut ke controller
}
