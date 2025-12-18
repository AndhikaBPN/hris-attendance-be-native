<?php

try {
    $db = new PDO(
        "mysql:host=" . env('DB_HOST') .
        ";dbname=" . env('DB_DATABASE') .
        ";port=" . env('DB_PORT'),
        env('DB_USERNAME'),
        env('DB_PASSWORD')
    );

    $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'message' => 'Database connection failed',
        'error' => $e->getMessage()
    ]);
    exit;
}