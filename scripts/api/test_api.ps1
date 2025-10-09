# PowerShell script para probar TODOS los endpoints de Cat API
# Usage: powershell.exe -ExecutionPolicy Bypass -File ".\scripts\api\test_api.ps1"

param(
    [string]$ApiKey = "live_BDQqVqUXMRfcVj7C8WJIUJpgHLVt8KHhO6WZdQoWZoS2nVUBGPGdKNO2S1ZhxA"
)

$BaseUrl = "https://api.thecatapi.com/v1"
$Headers = @{
    "x-api-key" = $ApiKey
    "Content-Type" = "application/json"
}

Write-Host "🐱 Cat Breeds API Testing - ALL ENDPOINTS" -ForegroundColor Green
Write-Host "===========================================" -ForegroundColor Green
Write-Host ""

# Test 1: GET /breeds
Write-Host "📡 Testing GET /breeds (first 3 results)" -ForegroundColor Cyan
Write-Host "----------------------------------------" -ForegroundColor Cyan

try {
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $response = Invoke-RestMethod -Uri "$BaseUrl/breeds?limit=3" -Headers $Headers -Method Get
    $stopwatch.Stop()
    
    Write-Host "✅ Status: 200" -ForegroundColor Green
    Write-Host "⏱️  Response Time: $($stopwatch.ElapsedMilliseconds)ms" -ForegroundColor Yellow
    Write-Host "📊 Results Count: $($response.Count)" -ForegroundColor Blue
    
    foreach ($breed in $response) {
        Write-Host "   • $($breed.name) ($($breed.id))" -ForegroundColor White
        Write-Host "     Origin: $($breed.origin)" -ForegroundColor Gray
    }
} catch {
    Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "=".PadRight(50, "=") -ForegroundColor Gray
Write-Host ""

# Test 2: Search Persian
Write-Host "🔍 Testing Search: 'Persian'" -ForegroundColor Cyan
Write-Host "----------------------------" -ForegroundColor Cyan

try {
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $response = Invoke-RestMethod -Uri "$BaseUrl/breeds/search?q=Persian" -Headers $Headers -Method Get
    $stopwatch.Stop()
    
    Write-Host "✅ Status: 200" -ForegroundColor Green
    Write-Host "⏱️  Response Time: $($stopwatch.ElapsedMilliseconds)ms" -ForegroundColor Yellow
    Write-Host "📊 Results Found: $($response.Count)" -ForegroundColor Blue
    
    foreach ($breed in $response) {
        Write-Host "   • $($breed.name) ($($breed.id))" -ForegroundColor White
        Write-Host "     Temperament: $($breed.temperament)" -ForegroundColor Gray
    }
} catch {
    Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "=".PadRight(50, "=") -ForegroundColor Gray
Write-Host ""

# Test 3: Get breed by ID
Write-Host "� Testing GET /breeds/abys" -ForegroundColor Cyan
Write-Host "----------------------------" -ForegroundColor Cyan

try {
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $response = Invoke-RestMethod -Uri "$BaseUrl/breeds/abys" -Headers $Headers -Method Get
    $stopwatch.Stop()
    
    Write-Host "✅ Status: 200" -ForegroundColor Green
    Write-Host "⏱️  Response Time: $($stopwatch.ElapsedMilliseconds)ms" -ForegroundColor Yellow
    Write-Host "🐱 Breed Details:" -ForegroundColor Blue
    Write-Host "   • Name: $($response.name)" -ForegroundColor White
    Write-Host "   • Origin: $($response.origin)" -ForegroundColor Gray
    Write-Host "   • Life Span: $($response.life_span) years" -ForegroundColor Gray
    Write-Host "   • Weight: $($response.weight.metric) kg" -ForegroundColor Gray
    if ($response.reference_image_id) {
        Write-Host "   • Image Reference: $($response.reference_image_id)" -ForegroundColor Gray
    }
} catch {
    Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "=".PadRight(50, "=") -ForegroundColor Gray
Write-Host ""

# Test 4: Image URL
Write-Host "🖼️  Testing Image URL: '0XYvRd7oD'" -ForegroundColor Cyan
Write-Host "--------------------------------" -ForegroundColor Cyan

try {
    $imageUrl = "https://cdn2.thecatapi.com/images/0XYvRd7oD.jpg"
    Write-Host "📍 Testing URL: $imageUrl" -ForegroundColor Yellow
    
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $response = Invoke-WebRequest -Uri $imageUrl -Method Head
    $stopwatch.Stop()
    
    Write-Host "✅ Status: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "⏱️  Response Time: $($stopwatch.ElapsedMilliseconds)ms" -ForegroundColor Yellow
    Write-Host "📎 Content-Type: $($response.Headers['Content-Type'])" -ForegroundColor Blue
    
    if ($response.Headers['Content-Length']) {
        $sizeKb = [math]::Round([int]$response.Headers['Content-Length'] / 1024, 1)
        Write-Host "📊 Image Size: $sizeKb KB" -ForegroundColor Blue
    }
    
    Write-Host "✅ Image is accessible and valid" -ForegroundColor Green
} catch {
    Write-Host "❌ Error accessing image: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "=".PadRight(50, "=") -ForegroundColor Gray
Write-Host ""

# Test 5: Invalid endpoint
Write-Host "�🚨 Testing Invalid Endpoint" -ForegroundColor Cyan
Write-Host "----------------------------" -ForegroundColor Cyan

try {
    $response = Invoke-RestMethod -Uri "$BaseUrl/invalid-endpoint" -Headers $Headers -Method Get
    Write-Host "⚠️  Unexpected success" -ForegroundColor Yellow
} catch {
    Write-Host "✅ Expected error caught:" -ForegroundColor Green
    if ($_.Exception.Response) {
        Write-Host "   Status Code: $($_.Exception.Response.StatusCode.value__)" -ForegroundColor Red
    }
    Write-Host "   Message: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "🎉 Testing completed! All endpoints tested." -ForegroundColor Green