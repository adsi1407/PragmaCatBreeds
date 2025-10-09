# 🔐 API Key Security Strategy

## 📋 Overview

Este proyecto implementa una estrategia de dos niveles para manejo seguro de API keys:

- **🛠️ DEVELOPMENT**: Key incluida para facilidad de desarrollo local
- **🚀 PRODUCTION**: Key requerida desde environment variables

## 🎯 Comportamiento por Environment

### 🛠️ Development Mode (por defecto)

```bash
# Automático - usa key de desarrollo incluida
flutter run
flutter test

# Explícito 
flutter run --dart-define=DEVELOPMENT=true
```

**Características**:
- ✅ Key hardcodeada incluida para conveniencia
- ✅ No requiere configuración adicional
- ✅ Ideal para desarrollo local y testing
- ⚠️ NO usar en producción

### 🚀 Production Mode

```bash
# Build de producción - REQUIERE API key externa
flutter build apk --dart-define=DEVELOPMENT=false --dart-define=CAT_API_KEY=your_production_key

# Para diferentes formatos
flutter build appbundle --dart-define=DEVELOPMENT=false --dart-define=CAT_API_KEY=your_key
flutter build ios --dart-define=DEVELOPMENT=false --dart-define=CAT_API_KEY=your_key
```

**Características**:
- 🔒 Key DEBE provenir de environment variables
- 🚨 Falla con excepción clara si no hay key
- ✅ Seguro para distribución
- ✅ Compatible con CI/CD

## 🏗️ CI/CD Integration

### GitHub Actions Example:

```yaml
# .github/workflows/build-production.yml
env:
  CAT_API_KEY: ${{ secrets.CAT_API_KEY }}

steps:
  - name: Build Production APK
    run: |
      flutter build apk \
        --dart-define=DEVELOPMENT=false \
        --dart-define=CAT_API_KEY=${{ secrets.CAT_API_KEY }}
```

### Secrets Configuration:
1. Ve a **GitHub Repository → Settings → Secrets and Variables → Actions**
2. Agrega `CAT_API_KEY` con tu production key
3. El CI automáticamente lo inyectará en el build

## 🧪 Testing Different Modes

### Test Development Mode:
```bash
flutter test --dart-define=DEVELOPMENT=true
# o simplemente:
flutter test
```

### Test Production Mode:
```bash
flutter test --dart-define=DEVELOPMENT=false --dart-define=CAT_API_KEY=test_key
```

### Test Scripts:
```bash
# Script con key personalizada
dart run --define=DEVELOPMENT=false --define=CAT_API_KEY=your_key scripts/api/test_endpoints.dart
```

## ⚠️ Error Handling

### Development Mode - Sin problemas:
```dart
// Automáticamente usa: live_BDQqVqUXMRfcVj7C8WJIUJpgHLVt8KHhO6WZdQoWZoS2nVUBGPGdKNO2S1ZhxA
```

### Production Mode - Key faltante:
```
Exception: CAT_API_KEY not found in production environment. 
Use: flutter build --dart-define=DEVELOPMENT=false --dart-define=CAT_API_KEY=your_key
```

## 🔄 Migration Path

### Para desarrolladores existentes:
- **No cambiar nada**: El modo development sigue funcionando igual
- **Para producción**: Agregar `--dart-define=DEVELOPMENT=false --dart-define=CAT_API_KEY=your_key`

### Para nuevos desarrolladores:
1. Clone del repositorio
2. `flutter run` funciona inmediatamente
3. Para builds de producción, obtener API key y usar flags correspondientes

## 💡 Best Practices

### ✅ Recommended:
- Development: usar modo automático
- Staging: usar production mode con staging key  
- Production: usar production mode con secrets management
- CI/CD: siempre usar production mode con encrypted secrets

### ❌ Avoid:
- Hardcodear production keys en código
- Subir keys de producción a Git
- Usar development mode en builds distribuibles
- Compartir keys en texto plano

## 🔧 Implementation Details

```dart
// Verificación automática en runtime
static const bool _isDevelopment = bool.fromEnvironment('DEVELOPMENT', defaultValue: true);

// Keys por environment
static const String _productionApiKey = String.fromEnvironment('CAT_API_KEY');
static const String _developmentApiKey = 'live_BDQqVqUXMRfcVj7C8WJIUJpgHLVt8KHhO6WZdQoWZoS2nVUBGPGdKNO2S1ZhxA';

// Validación estricta en producción
if (_isDevelopment) {
  return _developmentApiKey; // Siempre disponible
}

if (_productionApiKey.isEmpty) {
  throw Exception('Production key required'); // Falla rápido y claro
}
```