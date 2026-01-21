<?php
/**
 * Fonctions API : ${ApiName}
 *
 * Intégration de l'API ${ApiName} (${base_url})
 *
 * Documentation officielle : ${docs_url}
 *
 * @package SmartLockers\APIs
 * @created ${date}
 */

/**
 * Authentifie auprès de l'API ${ApiName}
 *
 * @param array $config Configuration API
 * @return array Token d'authentification
 * @throws Exception Si authentification échoue
 */
function api_${api_name}_authenticate(array $config): array
{
    $authType = $config['auth_type'] ?? 'bearer_token';

    switch ($authType) {
        case 'bearer_token':
            return [
                'access_token' => $config['bearer_token'] ?? '',
                'token_type' => 'Bearer',
                'expires_in' => 86400
            ];

        case 'api_key':
            return [
                'access_token' => $config['api_key'] ?? '',
                'token_type' => 'ApiKey',
                'expires_in' => 86400
            ];

        case 'oauth2':
            return api_${api_name}_authenticate_oauth2($config);

        case 'basic_auth':
            $credentials = base64_encode(
                ($config['username'] ?? '') . ':' . ($config['password'] ?? '')
            );
            return [
                'access_token' => $credentials,
                'token_type' => 'Basic',
                'expires_in' => 86400
            ];

        default:
            throw new Exception("Type d'authentification inconnu: {$authType}");
    }
}

/**
 * Récupère ressources depuis l'API ${ApiName}
 *
 * Pattern cache-first avec fallback (OBLIGATOIRE).
 * Cache mis à jour SEULEMENT si HTTP 2xx.
 *
 * @param string $clientName Nom du client
 * @param array $config Configuration API
 * @param array $params Paramètres optionnels
 * @return array Résultat avec pattern résilience
 */
function api_${api_name}_get_resources(string $clientName, array $config, array $params = []): array
{
    return api_resilient_call(
        clientName: $clientName,
        apiName: '${api_name}',
        cacheKey: 'resources_' . md5(json_encode($params)),
        apiCall: function() use ($config, $params) {
            $auth = api_${api_name}_authenticate($config);

            $url = $config['base_url'] . '/resources';
            if (!empty($params)) {
                $url .= '?' . http_build_query($params);
            }

            $headers = api_${api_name}_build_headers($auth);

            $response = api_http_get($url, [
                'headers' => $headers,
                'timeout' => $config['timeout'] ?? 30
            ]);

            return [
                'status_code' => $response['status'],
                'data' => json_decode($response['body'], true)
            ];
        },
        ttl: $config['ttl_resources'] ?? 3600
    );
}

/**
 * Crée une ressource dans l'API ${ApiName}
 *
 * Pattern API-first (pas de cache pour mutations).
 *
 * @param string $clientName Nom du client
 * @param array $config Configuration API
 * @param array $data Données à envoyer
 * @return array Résultat opération
 * @throws Exception Si échec API
 */
function api_${api_name}_create_resource(string $clientName, array $config, array $data): array
{
    $auth = api_${api_name}_authenticate($config);
    $url = $config['base_url'] . '/resources';
    $headers = api_${api_name}_build_headers($auth);

    $response = api_http_post($url, [
        'headers' => $headers,
        'body' => json_encode($data),
        'timeout' => $config['timeout'] ?? 30
    ]);

    if ($response['status'] !== 200 && $response['status'] !== 201) {
        throw new Exception("API ${ApiName} error: " . $response['body']);
    }

    return [
        'status' => 'success',
        'data' => json_decode($response['body'], true)
    ];
}

/**
 * Met à jour une ressource dans l'API ${ApiName}
 *
 * @param string $clientName Nom du client
 * @param array $config Configuration API
 * @param string $resourceId Identifiant ressource
 * @param array $data Données à mettre à jour
 * @return array Résultat opération
 */
function api_${api_name}_update_resource(string $clientName, array $config, string $resourceId, array $data): array
{
    $auth = api_${api_name}_authenticate($config);
    $url = $config['base_url'] . '/resources/' . urlencode($resourceId);
    $headers = api_${api_name}_build_headers($auth);

    $response = api_http_put($url, [
        'headers' => $headers,
        'body' => json_encode($data),
        'timeout' => $config['timeout'] ?? 30
    ]);

    if ($response['status'] !== 200) {
        throw new Exception("API ${ApiName} update error: " . $response['body']);
    }

    return [
        'status' => 'success',
        'data' => json_decode($response['body'], true)
    ];
}

/**
 * Supprime une ressource de l'API ${ApiName}
 *
 * @param string $clientName Nom du client
 * @param array $config Configuration API
 * @param string $resourceId Identifiant ressource
 * @return array Résultat opération
 */
function api_${api_name}_delete_resource(string $clientName, array $config, string $resourceId): array
{
    $auth = api_${api_name}_authenticate($config);
    $url = $config['base_url'] . '/resources/' . urlencode($resourceId);
    $headers = api_${api_name}_build_headers($auth);

    $response = api_http_delete($url, [
        'headers' => $headers,
        'timeout' => $config['timeout'] ?? 30
    ]);

    if ($response['status'] !== 200 && $response['status'] !== 204) {
        throw new Exception("API ${ApiName} delete error: " . $response['body']);
    }

    return [
        'status' => 'success',
        'message' => 'Resource deleted successfully'
    ];
}

/**
 * Construit les headers HTTP selon le type d'auth
 *
 * @param array $auth Résultat de authenticate()
 * @return array Headers HTTP
 */
function api_${api_name}_build_headers(array $auth): array
{
    $headers = [
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
    ];

    switch ($auth['token_type']) {
        case 'Bearer':
            $headers['Authorization'] = 'Bearer ' . $auth['access_token'];
            break;
        case 'ApiKey':
            $headers['X-API-Key'] = $auth['access_token'];
            break;
        case 'Basic':
            $headers['Authorization'] = 'Basic ' . $auth['access_token'];
            break;
    }

    return $headers;
}
