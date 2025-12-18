<?php

require_once __DIR__ . '/../Helpers/ResponseHelper.php';

class AuthMiddleware
{
    public static function handle()
    {
        $headers = getallheaders();

        if (!isset($headers['Authorization'])) {
            ResponseHelper::error('Authorization header tidak ditemukan', 401);
        }

        $authHeader = $headers['Authorization'];

        // Format: Bearer token
        if (!preg_match('/Bearer\s(\S+)/', $authHeader, $matches)) {
            ResponseHelper::error('Format Authorization tidak valid', 401);
        }

        $token = $matches[1];

        // Versi TA sederhana: cek token tidak kosong
        if (empty($token)) {
            ResponseHelper::error('Token tidak valid', 401);
        }

        // Simpan token ke global request (simple context)
        $_SERVER['auth_token'] = $token;
    }
}