//
//  TestsReadme.md
//  SpaceflightNewsTests
//
//  Created by Orlando Nicola Marchioli on 18/05/2026.
//

# SpaceflightNews Tests

Este proyecto contiene tests unitarios para la aplicación SpaceflightNews, siguiendo el formato XCTest con `@MainActor`.

## Estructura de Tests

### HomePresenterTests
Tests para el presenter de la pantalla principal:
- ✅ `test_action_viewAppear_shouldPopulateData` - Verifica que se carguen los artículos
- ✅ `test_action_viewAppear_withFailResponse_shouldNavigateToErrorView` - Verifica el manejo de errores
- ✅ `test_action_refresh_shouldReloadData` - Verifica el pull-to-refresh
- ✅ `test_action_detail_shouldNavigateToDetailScreen` - Verifica navegación al detalle
- ✅ `test_action_loadMore_shouldAppendArticles` - Verifica la paginación
- ✅ `test_action_loadMore_whenAlreadyLoading_shouldNotLoadAgain` - Verifica que no se cargue dos veces
- ✅ `test_action_filter_withValidText_shouldFilterArticles` - Verifica el filtrado de artículos
- ✅ `test_action_filter_withEmptyText_shouldShowAllArticles` - Verifica reset del filtro
- ✅ `test_action_showSheet_shouldSetShowSortSheetToTrue` - Verifica mostrar sheet de ordenamiento
- ✅ `test_action_setSortOrder_ascending_shouldSortAscending` - Verifica ordenamiento ascendente
- ✅ `test_action_setSortOrder_descending_shouldSortDescending` - Verifica ordenamiento descendente
- ✅ `test_model_updateArticles_shouldUpdateArticlesAndAllArticles` - Verifica actualización del modelo
- ✅ `test_model_appendArticles_shouldAppendToExistingArticles` - Verifica append de artículos
- ✅ `test_model_resetPagination_shouldClearArticles` - Verifica reset de paginación

### DetailPresenterTests
Tests para el presenter de la pantalla de detalle:
- ✅ `test_action_viewAppear_shouldPopulateArticleData` - Verifica carga del artículo
- ✅ `test_action_viewAppear_withFailResponse_shouldNavigateToErrorView` - Verifica manejo de errores
- ✅ `test_action_retry_shouldRetryFetchingArticle` - Verifica reintentar carga
- ✅ `test_model_updateArticle_shouldUpdateArticleProperty` - Verifica actualización del modelo

### SpaceflightRouterTests
Tests para el router de navegación:
- ✅ `test_init_shouldSetNavigationController` - Verifica inicialización
- ✅ `test_startFlow_shouldNavigateToHome` - Verifica inicio del flujo
- ✅ `test_navigateTo_home_shouldPushHomeView` - Verifica navegación a home
- ✅ `test_navigateTo_detail_shouldPushDetailView` - Verifica navegación a detalle
- ✅ `test_push_withAnimationTrue_shouldPushAnimated` - Verifica push con animación
- ✅ `test_push_withAnimationFalse_shouldPushWithoutAnimation` - Verifica push sin animación
- ✅ `test_push_withDefaultAnimation_shouldPushAnimated` - Verifica push con animación por defecto
- ✅ `test_pop_shouldCallPopViewController` - Verifica pop
- ✅ `test_popToRoot_shouldCallPopToRootViewController` - Verifica pop to root

## Mocks y Utilidades

### SpyNavigationController
Un spy de `UINavigationController` que registra las llamadas a métodos de navegación.

**Propiedades:**
- `pushedViewController`: El último view controller pusheado
- `pushedAnimated`: Si el último push fue animado
- `popToRootCalled`: Si se llamó a `popToRootViewController`
- `popCalled`: Si se llamó a `popViewController`

### MockSpaceflightService
Un mock del servicio que implementa `SpaceflightServiceProtocol`.

**Propiedades:**
- `articlesResponse`: Resultado simulado para `fetchArticles`
- `articleResponse`: Resultado simulado para `fetchArticle`
- `fetchArticlesCallCount`: Contador de llamadas a `fetchArticles`
- `fetchArticleCallCount`: Contador de llamadas a `fetchArticle`
- `lastQuery`, `lastLimit`, `lastOffset`: Parámetros de la última llamada
- `lastArticleID`: ID del último artículo solicitado

### Mocks de DTOs

#### Article.mock
Artículo de ejemplo con todos los datos completos.

#### Article.mock2 y Article.mock3
Artículos adicionales para tests de listas y filtrado.

#### ArticleListResponse.mock
Respuesta paginada con 3 artículos.

#### ArticleListResponse.mockPage2
Segunda página de artículos para tests de paginación.

#### ArticleListResponse.mockEmpty
Respuesta vacía para tests de estados sin datos.

## Convenciones de Nombres

Los tests siguen el formato:
```
test_[acción]_[condición]_should[resultado]
```

Ejemplos:
- `test_action_viewAppear_shouldPopulateData`
- `test_action_filter_withValidText_shouldFilterArticles`
- `test_model_updateArticles_shouldUpdateArticlesAndAllArticles`

## Ejecución de Tests

Para ejecutar todos los tests:
```bash
cmd + U
```

Para ejecutar un archivo de tests específico:
- Click derecho en el archivo → Run Tests

Para ejecutar un test individual:
- Click en el diamante junto al nombre del test

## Cobertura de Tests

Los tests cubren:
- ✅ Casos de éxito
- ✅ Casos de error
- ✅ Navegación
- ✅ Paginación
- ✅ Filtrado
- ✅ Ordenamiento
- ✅ Estados de carga
- ✅ Actualización del modelo
- ✅ Reintentos

## Notas

- Todos los tests usan `@MainActor` ya que los presenters trabajan en el main thread
- Se deshabilitan las animaciones en `setUp` para mejorar la velocidad de los tests
- Los mocks están diseñados para ser reutilizables y fáciles de modificar
- Se utilizan `XCTAssert` tradicionales en lugar de Swift Testing para mantener compatibilidad
