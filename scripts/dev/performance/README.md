# Performance Scripts

Scripts for performance testing and benchmarking of the Flutter Cat Breeds application.

## 📁 Available Scripts

### `performance_test.sh` (Linux/macOS/WSL)
Comprehensive performance testing script.

## 🎯 Features

- **Performance Benchmarking**: Measure app performance metrics
- **Load Testing**: Test application under various load conditions
- **Memory Profiling**: Monitor memory usage patterns
- **Cross-platform Compatibility**: Support for multiple test environments

## 🚀 Usage

### Basic Performance Testing
```bash
# Linux/macOS/WSL
./scripts/performance/performance_test.sh
```

### Advanced Options
```bash
# Run with specific configuration
./scripts/performance/performance_test.sh --config production

# Generate detailed reports
./scripts/performance/performance_test.sh --verbose --report
```

## 📊 Metrics Measured

- **App startup time**
- **Memory usage**
- **CPU utilization**
- **Network request performance**
- **Widget rendering time**
- **Navigation performance**

## 🔧 Integration

Performance scripts integrate with:
- **CI/CD pipelines**: Automated performance regression testing
- **Local development**: Developer performance validation
- **Monitoring tools**: Integration with performance monitoring services
- **Reporting**: Generate performance reports and charts

## ⚙️ Prerequisites

- Flutter SDK with test tools
- Performance testing dependencies
- Target device or emulator
- Sufficient system resources for accurate measurements

## 📈 Reports

Performance scripts generate:
- **JSON reports**: Machine-readable performance data
- **HTML dashboards**: Visual performance metrics
- **Comparison reports**: Before/after performance analysis
- **Benchmark baselines**: Reference performance standards