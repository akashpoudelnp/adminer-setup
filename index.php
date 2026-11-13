<?php

require_once __DIR__ . '/env.php';

// Prefill the Adminer login form from .env (only when not already in the URL).
$prefill = [
    'server'   => env('DB_HOST') !== ''
        ? env('DB_HOST') . (env('DB_PORT') !== '' ? ':' . env('DB_PORT') : '')
        : '',
    'username' => env('DB_USER'),
    'db'       => env('DB_NAME'),
];

foreach ($prefill as $key => $value) {
    if ($value !== '' && !isset($_GET[$key])) {
        $_GET[$key] = $value;
    }
}

require __DIR__ . '/adminer.php';
