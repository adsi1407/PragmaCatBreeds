#!/bin/bash
# Bash script para probar endpoints de Cat API
# Usage: ./test_api.sh

API_KEY="live_BDQqVqUXMRfcVj7C8WJIUJpgHLVt8KHhO6WZdQoWZoS2nVUBGPGdKNO2S1ZhxA"
BASE_URL="https://api.thecatapi.com/v1"

echo "🐱 Cat Breeds API Testing with curl"
echo "===================================="
echo ""

echo "📡 Testing GET /breeds (first 3 results)"
echo "----------------------------------------"
curl -s -w "\n⏱️  Response Time: %{time_total}s\n✅ Status: %{http_code}\n" \
  -H "x-api-key: $API_KEY" \
  -H "Content-Type: application/json" \
  "$BASE_URL/breeds?limit=3" | jq '.[0:3] | .[] | {name: .name, id: .id, origin: .origin}'

echo ""
echo "="*50
echo ""

echo "🔍 Testing Search: 'Persian'"
echo "----------------------------"
curl -s -w "\n⏱️  Response Time: %{time_total}s\n✅ Status: %{http_code}\n" \
  -H "x-api-key: $API_KEY" \
  -H "Content-Type: application/json" \
  "$BASE_URL/breeds/search?q=Persian" | jq '.[] | {name: .name, id: .id, temperament: .temperament}'

echo ""
echo "="*50
echo ""

echo "🔍 Testing Search: 'Maine'"
echo "--------------------------"
curl -s -w "\n⏱️  Response Time: %{time_total}s\n✅ Status: %{http_code}\n" \
  -H "x-api-key: $API_KEY" \
  -H "Content-Type: application/json" \
  "$BASE_URL/breeds/search?q=Maine" | jq '.[] | {name: .name, id: .id, life_span: .life_span}'

echo ""
echo "="*50
echo ""

echo "🔍 Testing GET /breeds/{id}: 'abys'"
echo "-----------------------------------"
curl -s -w "\n⏱️  Response Time: %{time_total}s\n✅ Status: %{http_code}\n" \
  -H "x-api-key: $API_KEY" \
  -H "Content-Type: application/json" \
  "$BASE_URL/breeds/abys" | jq '{name: .name, id: .id, origin: .origin, weight: .weight.metric, reference_image_id: .reference_image_id}'

echo ""
echo "="*50
echo ""

echo "🖼️  Testing Image URL: '0XYvRd7oD'"
echo "--------------------------------"
IMAGE_URL="https://cdn2.thecatapi.com/images/0XYvRd7oD.jpg"
echo "📍 Testing URL: $IMAGE_URL"
curl -s -I -w "⏱️  Response Time: %{time_total}s\n✅ Status: %{http_code}\n📊 Content-Type: %{content_type}\n📊 Content-Length: %{size_download} bytes\n" \
  "$IMAGE_URL"

echo ""
echo "="*50
echo ""

echo "🚨 Testing Invalid Endpoint"
echo "----------------------------"
curl -s -w "\n⏱️  Response Time: %{time_total}s\n❌ Status: %{http_code}\n" \
  -H "x-api-key: $API_KEY" \
  -H "Content-Type: application/json" \
  "$BASE_URL/invalid-endpoint"

echo ""
echo "Testing completed! 🎉"