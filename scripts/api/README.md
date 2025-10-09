# 🔧 API Testing Scripts

Scripts para probar los endpoints de Cat API utilizados por la aplicación.

## 📁 Archivos disponibles

- `test_endpoints.dart` - Script de Dart con testing completo y análisis detallado
- `test_api.sh` - Script de Bash con curl (Linux/macOS)
- `test_api.ps1` - Script de PowerShell (Windows)

## 🚀 Uso

### Dart Script (Recomendado)
```bash
# Desde la raíz del proyecto
dart run scripts/api/test_endpoints.dart

# Con API key personalizada (más seguro)
dart run --define=CAT_API_KEY=your_api_key_here scripts/api/test_endpoints.dart
```

### PowerShell (Windows)
```powershell
# Opción 1: Comando directo
$response = Invoke-WebRequest -Uri "https://api.thecatapi.com/v1/breeds?limit=3" -Headers @{"x-api-key"="live_BDQqVqUXMRfcVj7C8WJIUJpgHLVt8KHhO6WZdQoWZoS2nVUBGPGdKNO2S1ZhxA"}
$response.Content

# Opción 2: Script completo (requiere corrección)
# powershell.exe -ExecutionPolicy Bypass -File ".\scripts\api\test_api.ps1"
```

### Bash/curl (Linux/macOS)
```bash
chmod +x scripts/api/test_api.sh
./scripts/api/test_api.sh
```

## 🎯 Endpoints probados

1. **GET /breeds** - Lista todas las razas de gatos
   - URL: `https://api.thecatapi.com/v1/breeds`
   - Parámetros: `attach_image=1` (incluye información de imagen)

2. **GET /breeds/search** - Busca razas por nombre
   - URL: `https://api.thecatapi.com/v1/breeds/search`
   - Parámetros: `q` (término de búsqueda)

3. **GET /breeds/{id}** - Obtiene una raza específica por ID
   - URL: `https://api.thecatapi.com/v1/breeds/{breed_id}`
   - Ejemplo: `/breeds/abys` para raza Abyssinian

4. **GET Images** - Verifica acceso a imágenes de gatos
   - URL: `https://cdn2.thecatapi.com/images/{reference_image_id}.jpg`
   - Ejemplo: `/images/0XYvRd7oD.jpg`

5. **GET /invalid-endpoint** - Prueba manejo de errores
   - Endpoint inválido para probar respuestas de error

## 📊 Información mostrada

- ✅ **Status Code**: Código de respuesta HTTP
- ⏱️ **Response Time**: Tiempo de respuesta en milisegundos
- 📊 **Results Count**: Número de resultados obtenidos
- 🐱 **Sample Data**: Datos de ejemplo (nombre, ID, origen, temperamento, peso)
- 🖼️ **Image Info**: Información de imágenes (tamaño, tipo de contenido)
- 📝 **Headers**: Headers de respuesta (solo en script de Dart)
- 🚨 **Error Handling**: Manejo de errores y endpoints inválidos

## 🔑 API Key Management

### Secure Usage (Recommended)
```bash
# Use Dart Define to inject API key at runtime
dart run --define=CAT_API_KEY=your_secure_key_here scripts/api/test_endpoints.dart

# For app development 
flutter run --dart-define=CAT_API_KEY=your_secure_key_here
flutter build apk --dart-define=CAT_API_KEY=your_secure_key_here
```

### Development Fallback
Los scripts incluyen una API key de fallback para desarrollo:
```
live_BDQqVqUXMRfcVj7C8WJIUJpgHLVt8KHhO6WZdQoWZoS2nVUBGPGdKNO2S1ZhxA
```

⚠️ **Nota de Seguridad**: 
- En **producción**, siempre usa `--dart-define=CAT_API_KEY=your_key`
- En **CI/CD**, obtén la key de secrets/environment variables
- La key de fallback es solo para desarrollo y testing rápido

## 📋 Ejemplo de respuesta

```json
{
  "id": "abys",
  "name": "Abyssinian",
  "origin": "Egypt",
  "temperament": "Active, Energetic, Independent, Intelligent, Gentle",
  "description": "The Abyssinian is easy to care for...",
  "life_span": "14 - 15"
}
```