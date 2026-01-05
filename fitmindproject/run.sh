#!/bin/bash
# ═══════════════════════════════════════════════════════════════════════════════
# FitMind Flutter Project - Universal Run Script
# ═══════════════════════════════════════════════════════════════════════════════
# This script runs the project in a clean and proper way every time.
# 
# USAGE:
#   ./run.sh           → Normal run
#   ./run.sh --clean   → Full cleanup and run (if issues occur)
#   ./run.sh --help    → Show help
#
# ISSUE FIXED: CocoaPods UTF-8 encoding error solution is included.
# ═══════════════════════════════════════════════════════════════════════════════

set -e  # Stop script on error

# Color definitions for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Project directory
PROJECT_DIR="/Users/efehankeles/Desktop/cs310 phase 4 /fitmindproject"

# ─────────────────────────────────────────────────────────────────────────────
# Helper Functions
# ─────────────────────────────────────────────────────────────────────────────

print_header() {
    echo ""
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${BOLD}${CYAN}  🧠 FitMind - Flutter iOS Runner${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════════════════════${NC}"
    echo ""
}

print_step() {
    echo -e "${BLUE}▶${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

show_help() {
    echo ""
    echo "FitMind Flutter Run Script - Usage Guide"
    echo ""
    echo "Usage:"
    echo "  ./run.sh              Normal run"
    echo "  ./run.sh --clean      Full cleanup and run"
    echo "  ./run.sh --help       Show this help message"
    echo "  ./run.sh --android    Run on Android device"
    echo ""
    echo "Hot Reload Shortcuts (while app is running):"
    echo "  r  → Hot reload (quick refresh)"
    echo "  R  → Hot restart (full restart)"
    echo "  q  → Quit application"
    echo ""
    exit 0
}

# ─────────────────────────────────────────────────────────────────────────────
# Main Script
# ─────────────────────────────────────────────────────────────────────────────

# Help check
if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    show_help
fi

print_header

# Navigate to project directory
cd "$PROJECT_DIR"
echo -e "${CYAN}📁 Project directory:${NC} $PROJECT_DIR"
echo ""

# ═══════════════════════════════════════════════════════════════════════════════
# STEP 1: Set UTF-8 Encoding (CRITICAL for CocoaPods!)
# ═══════════════════════════════════════════════════════════════════════════════
# Without this setting, you get "Unicode Normalization not appropriate for ASCII-8BIT" error
print_step "Setting UTF-8 Encoding..."
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

# Set encoding for Ruby as well (CocoaPods runs on Ruby)
export RUBYOPT="-E UTF-8"

print_success "Encoding set (UTF-8)"

# ═══════════════════════════════════════════════════════════════════════════════
# STEP 2: Cache Cleanup (with --clean parameter)
# ═══════════════════════════════════════════════════════════════════════════════
if [ "$1" == "--clean" ]; then
    echo ""
    print_step "🧹 Performing full cleanup..."
    
    # Clean Flutter cache
    flutter clean 2>/dev/null || true
    print_success "Flutter cache cleaned"
    
    # Clean iOS Pods
    rm -rf ios/Pods 2>/dev/null || true
    rm -rf ios/Podfile.lock 2>/dev/null || true
    rm -rf ios/.symlinks 2>/dev/null || true
    rm -rf ios/Flutter/Flutter.podspec 2>/dev/null || true
    print_success "iOS Pods cleaned"
    
    # Clean build folders
    rm -rf build/ 2>/dev/null || true
    rm -rf .dart_tool/ 2>/dev/null || true
    print_success "Build files cleaned"
    
    # Clean CocoaPods cache (optional - skip if too slow)
    # pod cache clean --all 2>/dev/null || true
    # print_success "CocoaPods cache cleaned"
    
    echo ""
fi

# ═══════════════════════════════════════════════════════════════════════════════
# STEP 3: Flutter Dependencies
# ═══════════════════════════════════════════════════════════════════════════════
echo ""
print_step "📦 Updating Flutter dependencies..."
flutter pub get
print_success "Flutter dependencies ready"

# ═══════════════════════════════════════════════════════════════════════════════
# STEP 4: iOS Pods Installation
# ═══════════════════════════════════════════════════════════════════════════════
echo ""
print_step "🍎 Installing iOS CocoaPods..."

# Navigate to iOS directory
cd ios

# Run pod install (with encoding)
if [ "$1" == "--clean" ]; then
    # In full cleanup mode, also update repo
    pod install --repo-update
else
    # In normal mode, just pod install
    pod install
fi

# Return to main directory
cd ..

print_success "iOS Pods ready"

# ═══════════════════════════════════════════════════════════════════════════════
# STEP 5: Open iOS Simulator
# ═══════════════════════════════════════════════════════════════════════════════
if [ "$1" != "--android" ]; then
    echo ""
    print_step "📱 Checking iOS Simulator..."
    
    # Open Simulator application
    if ! pgrep -x "Simulator" > /dev/null; then
        print_step "Opening iOS Simulator..."
        open -a Simulator 2>/dev/null || print_warning "Could not open Simulator"
        sleep 3
        print_success "Simulator started"
    else
        print_success "Simulator already running"
    fi
    
    # Short wait for Flutter to detect devices
    sleep 2
fi

# ═══════════════════════════════════════════════════════════════════════════════
# STEP 6: Run Flutter Application
# ═══════════════════════════════════════════════════════════════════════════════
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════════════════════════${NC}"
echo -e "${BOLD}${GREEN}  🚀 Starting application...${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}💡 Hot Reload:${NC} Press ${BOLD}r${NC} after code changes"
echo -e "${YELLOW}💡 Hot Restart:${NC} Press ${BOLD}R${NC} for full restart"
echo -e "${YELLOW}💡 Quit:${NC} Press ${BOLD}q${NC}"
echo ""

if [ "$1" == "--android" ]; then
    flutter run -d android
else
    # Find iOS simulator ID from Flutter devices list
    echo -e "${BLUE}▶${NC} Searching for iOS Simulator..."
    
    # Get Simulator ID (in UUID format)
    SIMULATOR_ID=$(flutter devices 2>/dev/null | grep -i "simulator" | head -1 | awk -F'•' '{print $2}' | xargs)
    
    if [ -n "$SIMULATOR_ID" ]; then
        print_success "Target device found: $SIMULATOR_ID"
        echo ""
        flutter run -d "$SIMULATOR_ID"
    else
        print_warning "iOS Simulator not found, running on macOS..."
        flutter run -d macos
    fi
fi
