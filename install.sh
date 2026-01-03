#!/bin/bash
#
# Mac Redact PDF - Installation Script
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "========================================"
echo "Mac Redact PDF - Installation"
echo "========================================"
echo

# Check for Python 3
if ! command -v python3 &> /dev/null; then
    echo "Error: Python 3 is required but not installed."
    echo "Install with: brew install python3"
    exit 1
fi
echo "[OK] Python 3 found: $(python3 --version)"

# Check for Tesseract
if ! command -v tesseract &> /dev/null; then
    echo ""
    echo "[WARNING] Tesseract OCR is not installed."
    echo "Install with: brew install tesseract"
    echo "Tesseract is required for processing scanned PDFs."
    echo ""
else
    echo "[OK] Tesseract found: $(tesseract --version 2>&1 | head -1)"
fi

# Check for Claude CLI
if ! command -v claude &> /dev/null; then
    echo ""
    echo "[WARNING] Claude CLI is not installed."
    echo "Download from: https://claude.ai/download"
    echo "Claude CLI is required for automatic client info detection."
    echo ""
else
    echo "[OK] Claude CLI found"
fi

# Create virtual environment
echo ""
echo "Setting up Python virtual environment..."
if [ ! -d "$SCRIPT_DIR/venv" ]; then
    python3 -m venv "$SCRIPT_DIR/venv"
    echo "[OK] Virtual environment created"
else
    echo "[OK] Virtual environment already exists"
fi

# Install dependencies
echo ""
echo "Installing Python dependencies..."
source "$SCRIPT_DIR/venv/bin/activate"
pip install -q -r "$SCRIPT_DIR/requirements.txt"
echo "[OK] Dependencies installed"
deactivate

# Make scripts executable
chmod +x "$SCRIPT_DIR/redact.sh"
chmod +x "$SCRIPT_DIR/redact_document.py"
echo "[OK] Scripts made executable"

# Install Quick Action
echo ""
echo "Installing Quick Action..."
SERVICES_DIR="$HOME/Library/Services"
WORKFLOW_NAME="Redact Client Info.workflow"

if [ -d "$SERVICES_DIR/$WORKFLOW_NAME" ]; then
    echo "[INFO] Quick Action already installed, updating..."
    rm -rf "$SERVICES_DIR/$WORKFLOW_NAME"
fi

cp -r "$SCRIPT_DIR/workflows/$WORKFLOW_NAME" "$SERVICES_DIR/"
echo "[OK] Quick Action installed to $SERVICES_DIR"

echo ""
echo "========================================"
echo "Installation Complete!"
echo "========================================"
echo ""
echo "Usage:"
echo "  1. Right-click any PDF or DOCX file in Finder"
echo "  2. Select Quick Actions > Redact Client Info"
echo ""
echo "Or use command line:"
echo "  $SCRIPT_DIR/redact.sh <file.pdf>"
echo ""
echo "If Quick Action doesn't appear (macOS Tahoe/Sequoia):"
echo "  1. Right-click any file in Finder"
echo "  2. Hover over Quick Actions > click Customize..."
echo "  3. Enable 'Redact Client Info'"
echo "  Or: System Settings > General > Login Items & Extensions > Finder"
echo "  4. Run: killall Finder"
echo ""
