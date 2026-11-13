<?php

/**
 * Adminer plugin loader.
 * Plugins are only loaded when enabled in .env, so the same repo works
 * on machines that don't need every plugin.
 *
 * Note: files in plugins/ are only included here - Adminer's automatic
 * plugin scan only covers adminer-plugins/, so disabled plugins are
 * never even declared.
 */

require_once __DIR__ . '/env.php';

$plugins = [];

if (env_bool('PLUGIN_PASSWORDLESS')) {
    require_once __DIR__ . '/plugins/login-password-less.php';
    // password_hash('') matches the historical behaviour: empty password logs in.
    $plugins[] = new AdminerLoginPasswordLess(
        password_hash(env('PASSWORDLESS_PASSWORD'), PASSWORD_DEFAULT)
    );
}

if (env_bool('PLUGIN_JSON_PREVIEW')) {
    require_once __DIR__ . '/plugins/json-preview.php';
    $plugins[] = new AdminerJsonPreview();
}

if (env_bool('PLUGIN_DUMP_JSON')) {
    require_once __DIR__ . '/plugins/dump-json.php';
    $plugins[] = new AdminerDumpJson();
}

return $plugins;
