<?php

require_once __DIR__ . '/../Services/AuthService.php';
require_once __DIR__ . '/../Helpers/ResponseHelper.php';

class AuthController
{
    private AuthService $authService;

    public function __construct(AuthService $authService)
    {
        $this->authService = $authService;
    }

    public function login()
    {
        $input = json_decode(file_get_contents('php://input'), true);

        try {
            if (empty($input['email']) || empty($input['password'])) {
                throw new Exception('Email dan password wajib diisi');
            }

            $result = $this->authService->login(
                $input['email'],
                $input['password']
            );

            ResponseHelper::success('Login berhasil', $result);
        } catch (Exception $e) {
            ResponseHelper::error($e->getMessage(), 401);
        }
    }
}