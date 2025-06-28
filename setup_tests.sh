#!/bin/bash
# AI Work Protocol Test Suite Setup
# =================================

set -e

echo "🧪 Setting up AI Work Protocol Test Suite"
echo "=========================================="

# Check Python version
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is required but not installed"
    exit 1
fi

PYTHON_VERSION=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')
echo "✅ Python version: $PYTHON_VERSION"

# Create virtual environment if it doesn't exist
if [ ! -d "test_env" ]; then
    echo "📦 Creating virtual environment..."
    python3 -m venv test_env
fi

# Activate virtual environment
echo "🔧 Activating virtual environment..."
source test_env/bin/activate

# Install required packages
echo "📥 Installing required packages..."
pip install --upgrade pip

# Create requirements.txt if it doesn't exist
if [ ! -f "test_requirements.txt" ]; then
    cat > test_requirements.txt << EOF
# Test suite requirements
unittest-xml-reporting>=3.2.0
coverage>=6.0
pytest>=7.0
pytest-cov>=4.0
pytest-html>=3.0
requests>=2.28.0
EOF
fi

pip install -r test_requirements.txt

# Make test files executable
echo "🔐 Setting up permissions..."
chmod +x test_suite.py
chmod +x test_rag_integration.py
chmod +x test_user_experience.py
chmod +x run_efficiency_tests.py

# Create test results directory
mkdir -p test_results

# Create sample configuration
if [ ! -f "test_config.json" ]; then
    cat > test_config.json << EOF
{
  "test_settings": {
    "timeout": 30,
    "max_retries": 3,
    "parallel_tests": false
  },
  "performance_thresholds": {
    "max_response_time": 2.0,
    "min_success_rate": 0.8,
    "min_usability_score": 0.7
  },
  "rag_settings": {
    "test_rag_integration": true,
    "rag_timeout": 15
  },
  "output_settings": {
    "save_detailed_logs": true,
    "generate_html_report": true,
    "export_metrics": true
  }
}
EOF
fi

echo ""
echo "✅ Test suite setup complete!"
echo ""
echo "📋 Available commands:"
echo "  ./run_efficiency_tests.py                    # Run all tests"
echo "  ./run_efficiency_tests.py --quick            # Quick test run"
echo "  ./run_efficiency_tests.py --no-rag          # Skip RAG tests"
echo "  ./run_efficiency_tests.py --no-ux           # Skip UX tests"
echo "  ./test_suite.py                             # Core system tests only"
echo "  ./test_rag_integration.py                   # RAG tests only"
echo "  ./test_user_experience.py                   # UX tests only"
echo ""
echo "📊 Example usage:"
echo "  # Run comprehensive efficiency evaluation"
echo "  ./run_efficiency_tests.py --output-dir results_$(date +%Y%m%d)"
echo ""
echo "  # Quick health check"
echo "  ./run_efficiency_tests.py --quick"
echo ""
echo "  # Test specific component"
echo "  ./test_suite.py --test core_commands"
echo ""
echo "📁 Results will be saved to test_results/ directory"
echo "📄 Reports include JSON data and human-readable summaries"
echo ""
echo "🚀 Ready to test! Run './run_efficiency_tests.py' to start."
