# Mac Redact PDF

A macOS tool that automatically identifies and redacts client information from PDF and DOCX files using Claude AI. Perfect for lawyers and professionals who need to share documents while protecting sensitive client data.

## Features

- **AI-Powered Detection**: Uses Claude CLI to intelligently identify client-identifying information
- **Automatic Redaction**: Detects names, case numbers, addresses, SSNs, phone numbers, and more
- **Multiple Formats**: Supports both PDF and DOCX files
- **Quick Action Integration**: Right-click any document in Finder to redact
- **Permanent Redaction**: PDF redactions use black boxes that cannot be removed
- **Smart OCR**: Automatically OCRs scanned documents when needed

## What Gets Redacted

Claude AI analyzes documents to identify:

- Client names (full names, variations, family members)
- Case numbers and docket numbers
- Addresses (street, city, zip)
- Phone numbers
- Email addresses
- Social Security numbers
- Dates of birth
- Driver's license numbers
- Account numbers (bank, medical, financial)
- Other identifying details

## Requirements

- macOS 10.15 or later
- Python 3.8+
- [Claude CLI](https://claude.ai/download) - Anthropic's command-line interface
- Tesseract OCR (for scanned PDFs)

## Installation

### 1. Clone the Repository

```bash
cd ~/github
git clone https://github.com/markwbennett/mac-redact-pdf.git
cd mac-redact-pdf
```

### 2. Install Tesseract OCR

```bash
brew install tesseract
```

### 3. Install Claude CLI

Download and install from: https://claude.ai/download

Verify installation:
```bash
claude --version
```

### 4. Set Up Python Environment

The script automatically creates a virtual environment on first run, or you can set it up manually:

```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### 5. Install the Quick Action

Copy the Quick Action to your Services folder:

```bash
cp -r workflows/Redact\ Client\ Info.workflow ~/Library/Services/
```

**Note**: You may need to enable the Quick Action. Right-click any file, hover over Quick Actions, click Customize, and enable "Redact Client Info".

## Usage

### Quick Action (Recommended)

1. Right-click any PDF or DOCX file in Finder
2. Select **Quick Actions** > **Redact Client Info**
3. Wait for processing (a notification appears when complete)
4. Find the redacted file next to the original with `_redacted` suffix

### Command Line

```bash
# Auto-detect and redact client info using Claude
./redact.sh document.pdf

# Or use the Python script directly
source venv/bin/activate
python redact_document.py document.pdf
```

### Advanced Options

```bash
# Redact specific terms only (skip Claude analysis)
python redact_document.py document.pdf --terms "John Smith" "Case 123"

# Add extra terms to Claude's detection
python redact_document.py document.pdf --add-terms "Confidential Project"

# Specify output file
python redact_document.py document.pdf -o cleaned_document.pdf

# Process DOCX files the same way
python redact_document.py contract.docx
```

## How It Works

1. **Text Extraction**: Extracts all text from the document
2. **AI Analysis**: Sends text to Claude CLI with a specialized prompt to identify client information
3. **Term Collection**: Claude returns a JSON array of terms to redact
4. **Document Processing**:
   - **PDF**: Adds permanent black box redactions that remove underlying text
   - **DOCX**: Replaces sensitive text with `[REDACTED]`
5. **Output**: Saves redacted file with `_redacted` suffix

### PDF Processing Details

- **Native PDFs**: Text is directly searchable and redacted
- **Scanned PDFs**: Automatically detected and OCR'd before redaction
- **Mixed PDFs**: Each page processed according to its type

## Example Output

```
============================================================
Document Redaction Tool with Claude AI
============================================================

Extracting text for analysis...
Asking Claude to identify client information...

Identified 15 term(s) to redact:
  - John Smith
  - Smith
  - 4:24-cr-00123
  - 123 Main Street
  - Houston
  - 555-123-4567
  - john.smith@email.com
  ... and 8 more

Processing PDF: /Users/mark/Documents/motion.pdf
  Analyzing PDF structure...
    Found 8 native page(s), 2 scanned page(s)
  Removing text layer from 2 scanned page(s)...
  Performing OCR on 2 scanned page(s)...
  Searching for 15 term(s) to redact...
    Page 1: Redacting 'John Smith'
    Page 1: Redacting '4:24-cr-00123'
    Page 3: Redacting '555-123-4567'
    ...

  Applied 23 redaction(s)
  Saving to: /Users/mark/Documents/motion_redacted.pdf

============================================================
Redaction complete!
Redacted file: /Users/mark/Documents/motion_redacted.pdf
============================================================
```

## Troubleshooting

### "Claude CLI not found"

Install Claude CLI from https://claude.ai/download and ensure it's in your PATH.

### "tesseract is not installed"

```bash
brew install tesseract
```

### Quick Action not appearing (macOS Tahoe/Sequoia)

**Method 1 - Via Finder (Easiest):**
1. Right-click any PDF file in Finder
2. Hover over **Quick Actions**
3. Click **Customize...** at the bottom
4. Enable "Redact Client Info" in the Extensions window

**Method 2 - Via System Settings:**
1. Open **System Settings**
2. Go to **General** → **Login Items & Extensions**
3. Click on **Finder** (under Extensions section)
4. Enable "Redact Client Info"

**If still not working:**
```bash
killall Finder
```

### OCR quality issues

- Ensure source PDFs are at least 200 DPI
- For better results, rescan at 300+ DPI

## Security Notes

- **Local Processing**: All document processing happens locally
- **Claude API**: Only extracted text is sent to Claude for analysis
- **No Cloud Storage**: Documents are never uploaded anywhere
- **Permanent Redaction**: PDF redactions remove underlying text completely

## License

MIT

## Contributing

Contributions welcome! Please open an issue or PR.

## Credits

- [PyMuPDF](https://pymupdf.readthedocs.io/) for PDF processing
- [Tesseract OCR](https://github.com/tesseract-ocr/tesseract) for text recognition
- [Claude CLI](https://claude.ai) for AI-powered information detection
