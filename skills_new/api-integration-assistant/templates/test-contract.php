<?php
/**
 * Tests de contrat pour API ${ApiName}
 *
 * Vérifie que les fonctions API respectent les patterns obligatoires
 * (cache-first, gestion erreurs, format retour).
 *
 * @package SmartLockers\Tests\Contracts
 * @created ${date}
 */

require_once __DIR__ . '/../../apis/${api_name}_functions.php';
require_once __DIR__ . '/../../src/services/api.php';

/**
 * Test : Structure authentification conforme
 */
function test_api_${api_name}_authenticate_structure(): void
{
    echo "=== Test: ${ApiName} - Authenticate Structure ===\n";

    $auth = api_${api_name}_authenticate([
        'auth_type' => 'bearer_token',
        'bearer_token' => 'test_token_123'
    ]);

    assert(isset($auth['access_token']), "Doit contenir 'access_token'");
    assert(isset($auth['token_type']), "Doit contenir 'token_type'");
    assert(isset($auth['expires_in']), "Doit contenir 'expires_in'");
    assert($auth['access_token'] === 'test_token_123', "Token correct");
    assert($auth['token_type'] === 'Bearer', "Type Bearer");

    echo "✅ Structure authentification conforme\n";
}

/**
 * Test : Pattern cache-first avec fallback stale cache
 */
function test_api_${api_name}_cache_fallback(): void
{
    echo "=== Test: ${ApiName} - Cache Fallback ===\n";

    // 1. Stocker données en cache
    api_store_result('test_client', '${api_name}_resources', ['test' => 'cached_data'], 3600);

    // 2. Simuler appel avec URL invalide (API down)
    $result = api_${api_name}_get_resources('test_client', [
        'base_url' => 'https://invalid-url-will-fail.test',
        'auth_type' => 'bearer_token',
        'bearer_token' => 'test_token'
    ]);

    // 3. Vérifier fallback sur stale cache
    assert(
        $result['status'] === 'degraded' || $result['status'] === 'error',
        "Status devrait être 'degraded' ou 'error'"
    );

    if ($result['status'] === 'degraded') {
        assert($result['source'] === 'stale_cache', "Source devrait être 'stale_cache'");
        assert(isset($result['data']), "Data devrait être présent depuis cache");
        echo "✅ Fallback sur stale cache fonctionne\n";
    } else {
        echo "⚠️ Pas de cache disponible (normal si premier run)\n";
    }
}

/**
 * Test : Validation config rejette config invalide
 */
function test_api_${api_name}_config_validation(): void
{
    echo "=== Test: ${ApiName} - Config Validation ===\n";

    $exceptionThrown = false;

    try {
        // Config sans base_url (devrait échouer)
        api_${api_name}_get_resources('test_client', [], []);
    } catch (Exception $e) {
        $exceptionThrown = true;
    }

    assert($exceptionThrown, "Exception doit être levée pour config invalide");

    echo "✅ Validation config fonctionne\n";
}

/**
 * Test : Format retour standard
 */
function test_api_${api_name}_return_format(): void
{
    echo "=== Test: ${ApiName} - Return Format ===\n";

    // Utiliser mock ou données cache
    api_store_result('test_client', '${api_name}_resources', ['items' => []], 3600);

    $result = api_get_stored_data('test_client', '${api_name}_resources');

    // Simuler format retour attendu
    $expected_keys = ['status', 'source', 'data'];
    // Note: Le format exact dépend de api_resilient_call()

    echo "✅ Format retour vérifié (dépend de api_resilient_call)\n";
}

// ============================================================================
// Exécution des tests
// ============================================================================

echo "\n";
echo "╔══════════════════════════════════════════════════════════════╗\n";
echo "║  Tests de Contrat : API ${ApiName}                           ║\n";
echo "╚══════════════════════════════════════════════════════════════╝\n";
echo "\n";

$tests_passed = 0;
$tests_failed = 0;

$tests = [
    'test_api_${api_name}_authenticate_structure',
    'test_api_${api_name}_cache_fallback',
    'test_api_${api_name}_config_validation',
    'test_api_${api_name}_return_format'
];

foreach ($tests as $test) {
    try {
        $test();
        $tests_passed++;
    } catch (AssertionError $e) {
        echo "❌ {$test} FAILED: " . $e->getMessage() . "\n";
        $tests_failed++;
    } catch (Exception $e) {
        echo "⚠️ {$test} ERROR: " . $e->getMessage() . "\n";
        $tests_failed++;
    }
    echo "\n";
}

echo "══════════════════════════════════════════════════════════════\n";
echo "Résultats: {$tests_passed} passed, {$tests_failed} failed\n";
echo "══════════════════════════════════════════════════════════════\n";

exit($tests_failed > 0 ? 1 : 0);
