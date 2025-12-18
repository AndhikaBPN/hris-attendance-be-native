<?php

// Load .env
$envPath = __DIR__ . '/../.env';

if (file_exists($envPath)) {
    $lines = file($envPath, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
    foreach ($lines as $line) {
        if (strpos(trim($line), '#') === 0) continue;
        [$key, $value] = explode('=', $line, 2);
        $_ENV[$key] = trim($value);
    }
}

// Helper env()
function env($key, $default = null)
{
    return $_ENV[$key] ?? $default;
}

// App config
define('APP_NAME', env('APP_NAME'));
define('APP_ENV', env('APP_ENV'));
define('APP_DEBUG', env('APP_DEBUG'));
define('APP_URL', env('APP_URL'));