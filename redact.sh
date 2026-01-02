#!/bin/bash
#
# Redact Client Information from Documents
# Uses Claude CLI to identify and redact sensitive client data
#
# Usage: ./redact.sh <file.pdf or file.docx>
#

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_PATH="$SCRIPT_DIR/venv"
PYTHON_SCRIPT="$SCRIPT_DIR/redact_document.py"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if file argument provided
if [ -z "$1" ]; then
    echo -e "${RED}Error: No file provided${NC}"
    echo "Usage: $0 <file.pdf or file.docx>"
    exit 1
fi

# Check if file exists
if [ ! -f "$1" ]; then
    echo -e "${RED}Error: File not found: $1${NC}"
    exit 1
fi

# Check file extension
EXT="${1##*.}"
EXT_LOWER=$(echo "$EXT" | tr '[:upper:]' '[:lower:]')

if [ "$EXT_LOWER" != "pdf" ] && [ "$EXT_LOWER" != "docx" ]; then
    echo -e "${RED}Error: Unsupported file type: .$EXT${NC}"
    echo "Supported types: .pdf, .docx"
    exit 1
fi

# Check if virtual environment exists, create if not
if [ ! -d "$VENV_PATH" ]; then
    echo -e "${YELLOW}Creating virtual environment...${NC}"
    python3 -m venv "$VENV_PATH"

    echo -e "${YELLOW}Installing dependencies...${NC}"
    source "$VENV_PATH/bin/activate"
    pip install -q -r "$SCRIPT_DIR/requirements.txt"
else
    source "$VENV_PATH/bin/activate"
fi

# Check if Claude CLI is available
if ! command -v claude &> /dev/null; then
    echo -e "${RED}Error: Claude CLI not found${NC}"
    echo "Please install Claude CLI from: https://claude.ai/download"
    deactivate
    exit 1
fi

# Run the redaction script
echo -e "${GREEN}Starting redaction process...${NC}"
python "$PYTHON_SCRIPT" "$1"

# Capture exit code
EXIT_CODE=$?

deactivate

if [ $EXIT_CODE -eq 0 ]; then
    echo -e "${GREEN}Redaction complete!${NC}"

    # Show notification on macOS
    if command -v osascript &> /dev/null; then
        FILENAME=$(basename "$1")
        osascript -e "display notification \"Redacted: $FILENAME\" with title \"Document Redaction Complete\""
    fi
else
    echo -e "${RED}Redaction failed with exit code: $EXIT_CODE${NC}"
fi

exit $EXIT_CODE
