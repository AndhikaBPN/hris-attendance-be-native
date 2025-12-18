<?php

class ResponseHelper
{
    public static function success(string $message, $data = null, int $code = 200)
    {
        http_response_code($code);
        echo json_encode([
            'success' => true,
            'message' => $message,
            'data'    => $data
        ]);
        exit;
    }

    public static function error(string $message, int $code = 400)
    {
        http_response_code($code);
        echo json_encode([
            'success' => false,
            'message' => $message,
            'data'    => null
        ]);
        exit;
    }
}