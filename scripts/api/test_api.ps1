# PowerShell script para probar endpoints de Cat API
# Usage: .\test_api.ps1

$ApiKey = "live_BDQqVqUXMRfcVj7C8WJIUJpgHLVt8KHhO6WZdQoWZoS2nVUBGPGdKNO2S1ZhxA"
$BaseUrl = "https://api.thecatapi.com/v1"

$Headers = @{
    "x-api-key" = $ApiKey
    "Content-Type" = "application/json"
}

Write-Host "🐱 Cat Breeds API Testing with PowerShell" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host ""

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

Write-Host "🚨 Testing Invalid Endpoint" -ForegroundColor Cyan
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
Write-Host "Testing completed! 🎉" -ForegroundColor Green