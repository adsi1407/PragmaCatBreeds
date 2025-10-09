# PowerShell script para probar TODOS los endpoints de Cat API
# Usage: powershell.exe -ExecutionPolicy Bypass -File ".\scripts\api\test_all_endpoints.ps1"

param(
    [string]$ApiKey = "live_BDQqVqUXMRfcVj7C8WJIUJpgHLVt8KHhO6WZdQoWZoS2nVUBGPGdKNO2S1ZhxA",
    [switch]$ShowJson
)

$BaseUrl = "https://api.thecatapi.com/v1"
$Headers = @{
    "x-api-key" = $ApiKey
    "Content-Type" = "application/json"
}

# Helper function to display JSON
function Show-JsonResponse {
    param(
        [string]$Title,
        [object]$Data
    )
    
    Write-Host ""
    Write-Host "JSON Response: $Title" -ForegroundColor Magenta
    Write-Host ("-" * ($Title.Length + 15)) -ForegroundColor Magenta
    $jsonString = $Data | ConvertTo-Json -Depth 10
    Write-Host $jsonString -ForegroundColor White
    Write-Host ""
}

Write-Host "Cat Breeds API Testing - ALL ENDPOINTS" -ForegroundColor Green
Write-Host "=======================================" -ForegroundColor Green
Write-Host ""

# Test 1: GET /breeds
Write-Host "Testing GET /breeds" -ForegroundColor Cyan
Write-Host "-------------------" -ForegroundColor Cyan

$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
try {
    $response = Invoke-RestMethod -Uri "$BaseUrl/breeds?limit=3" -Headers $Headers -Method Get
    $stopwatch.Stop()
    
    Write-Host "Status: 200" -ForegroundColor Green
    Write-Host "Response Time: $($stopwatch.ElapsedMilliseconds)ms" -ForegroundColor Yellow
    Write-Host "Results Count: $($response.Count)" -ForegroundColor Blue
    
    # Show JSON response
    Show-JsonResponse -Title "GET /breeds" -Data $response
    
    Write-Host "Summary:" -ForegroundColor Yellow
    foreach ($breed in $response) {
        Write-Host "  - $($breed.name) ($($breed.id)) from $($breed.origin)" -ForegroundColor White
    }
}
catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "=".PadRight(50, "=") -ForegroundColor Gray  
Write-Host ""

# Test 2: Search Persian
Write-Host "Testing Search: Persian" -ForegroundColor Cyan
Write-Host "-----------------------" -ForegroundColor Cyan

$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
try {
    $response = Invoke-RestMethod -Uri "$BaseUrl/breeds/search?q=Persian" -Headers $Headers -Method Get
    $stopwatch.Stop()
    
    Write-Host "Status: 200" -ForegroundColor Green
    Write-Host "Response Time: $($stopwatch.ElapsedMilliseconds)ms" -ForegroundColor Yellow
    Write-Host "Results Found: $($response.Count)" -ForegroundColor Blue
    
    # Show JSON response
    Show-JsonResponse -Title "Search Persian" -Data $response
    
    Write-Host "Summary:" -ForegroundColor Yellow
    foreach ($breed in $response) {
        Write-Host "  - $($breed.name): $($breed.temperament)" -ForegroundColor White
    }
}
catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "=".PadRight(50, "=") -ForegroundColor Gray
Write-Host ""

# Test 3: Get breed by ID
Write-Host "Testing GET /breeds/abys" -ForegroundColor Cyan
Write-Host "------------------------" -ForegroundColor Cyan

$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
try {
    $response = Invoke-RestMethod -Uri "$BaseUrl/breeds/abys" -Headers $Headers -Method Get
    $stopwatch.Stop()
    
    Write-Host "Status: 200" -ForegroundColor Green
    Write-Host "Response Time: $($stopwatch.ElapsedMilliseconds)ms" -ForegroundColor Yellow
    
    # Show JSON response
    Show-JsonResponse -Title "GET /breeds/abys" -Data $response
    
    Write-Host "Breed Summary:" -ForegroundColor Yellow
    Write-Host "  - Name: $($response.name)" -ForegroundColor White
    Write-Host "  - Origin: $($response.origin)" -ForegroundColor White  
    Write-Host "  - Life Span: $($response.life_span) years" -ForegroundColor White
    Write-Host "  - Weight: $($response.weight.metric) kg" -ForegroundColor White
    
    if ($response.reference_image_id) {
        Write-Host "  - Image Reference: $($response.reference_image_id)" -ForegroundColor White
    }
}
catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "=".PadRight(50, "=") -ForegroundColor Gray
Write-Host ""

# Test 4: Image URL
Write-Host "Testing Image URL" -ForegroundColor Cyan
Write-Host "-----------------" -ForegroundColor Cyan

$imageUrl = "https://cdn2.thecatapi.com/images/0XYvRd7oD.jpg"
Write-Host "Testing URL: $imageUrl" -ForegroundColor Yellow

$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
try {
    $response = Invoke-WebRequest -Uri $imageUrl -Method Head
    $stopwatch.Stop()
    
    Write-Host "Status: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "Response Time: $($stopwatch.ElapsedMilliseconds)ms" -ForegroundColor Yellow
    Write-Host "Content-Type: $($response.Headers['Content-Type'])" -ForegroundColor Blue
    
    if ($response.Headers['Content-Length']) {
        $sizeKb = [math]::Round([int]$response.Headers['Content-Length'] / 1024, 1)
        Write-Host "Image Size: $sizeKb KB" -ForegroundColor Blue
    }
    
    Write-Host "Image is accessible and valid" -ForegroundColor Green
}
catch {
    Write-Host "Error accessing image: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "=".PadRight(50, "=") -ForegroundColor Gray
Write-Host ""

# Test 5: Invalid endpoint
Write-Host "Testing Invalid Endpoint" -ForegroundColor Cyan
Write-Host "------------------------" -ForegroundColor Cyan

try {
    $response = Invoke-RestMethod -Uri "$BaseUrl/invalid-endpoint" -Headers $Headers -Method Get
    Write-Host "Unexpected success" -ForegroundColor Yellow
    Show-JsonResponse -Title "Unexpected Response" -Data $response
}
catch {
    Write-Host "Expected error caught:" -ForegroundColor Green
    if ($_.Exception.Response) {
        Write-Host "  Status Code: $($_.Exception.Response.StatusCode.value__)" -ForegroundColor Red
    }
    Write-Host "  Message: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "=".PadRight(50, "=") -ForegroundColor Gray
Write-Host ""
Write-Host "Testing completed! All endpoints tested." -ForegroundColor Green

Write-Host ""
Write-Host "Testing completed! All endpoints tested." -ForegroundColor Green