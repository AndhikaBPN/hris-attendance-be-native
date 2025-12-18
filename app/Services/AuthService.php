<?php

require_once __DIR__ . '/../Repositories/UserRepository.php';
require_once __DIR__ . '/../Helpers/PasswordHelper.php';
require_once __DIR__ . '/../Helpers/UUIDHelper.php';

class AuthService
{
    private UserRepository $userRepo;

    public function __construct(UserRepository $userRepo)
    {
        $this->userRepo = $userRepo;
    }

    public function login(string $email, string $password): array
    {
        $user = $this->userRepo->findByEmail($email);

        if (!$user) {
            throw new Exception('Email tidak ditemukan');
        }

        if ($user['status'] !== 'active') {
            throw new Exception('Akun tidak aktif');
        }

        if (!PasswordHelper::verify($password, $user['password'])) {
            throw new Exception('Password salah');
        }

        // Token sederhana (TA-safe)
        $token = UUIDHelper::generate();

        return [
            'token' => $token,
            'user'  => [
                'id'    => $user['id'],
                'uuid'  => $user['uuid'],
                'name'  => $user['first_name'] . ' ' . $user['last_name'],
                'email' => $user['email'],
                'role'  => $user['role_name']
            ]
        ];
    }
}