#!/bin/bash
set -e

# Check if directory argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <comics-directory>"
    echo "Example: $0 /path/to/comics"
    exit 1
fi

COMICS_DIR="$1"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONVERTER_DIR="$SCRIPT_DIR/pdf-to-cbz-converter/pdf-to-cbz-python"
VENV_DIR="$SCRIPT_DIR/pdf-to-cbz-converter/.venv"

echo "=== PDF to CBZ Converter ==="

# Check if converter exists
if [ ! -d "$CONVERTER_DIR" ]; then
    echo "Error: pdf-to-cbz-converter directory not found at $CONVERTER_DIR"
    echo "Run: git submodule update --init --recursive"
    exit 1
fi

# Check if python script exists
if [ ! -f "$CONVERTER_DIR/pdf_to_cbz.py" ]; then
    echo "Error: pdf_to_cbz.py not found at $CONVERTER_DIR"
    exit 1
fi

# Check if Comics directory exists
if [ ! -d "$COMICS_DIR" ]; then
    echo "Error: Directory not found: $COMICS_DIR"
    exit 1
fi

# Create virtual environment if it doesn't exist
if [ ! -d "$VENV_DIR" ]; then
    echo "Creating Python virtual environment..."
    python3 -m venv "$VENV_DIR"
fi

# Activate virtual environment
echo "Activating virtual environment..."
source "$VENV_DIR/bin/activate"

# Install requirements
echo "Installing requirements..."
pip install -q --upgrade pip
pip install -q -r "$CONVERTER_DIR/requirements.txt"

# Find and convert all PDFs
echo "Searching for PDFs in $COMICS_DIR..."
pdf_count=0
converted_count=0

while IFS= read -r -d '' pdf_file; do
    pdf_count=$((pdf_count + 1))

    # Get the directory and filename
    pdf_dir="$(dirname "$pdf_file")"
    pdf_basename="$(basename "$pdf_file" .pdf)"
    cbz_file="$pdf_dir/$pdf_basename.cbz"

    # Check if CBZ already exists
    if [ -f "$cbz_file" ]; then
        echo "Skipping (CBZ exists): $pdf_file"
        continue
    fi

    echo "Converting: $pdf_file"

    # Run conversion
    cd "$CONVERTER_DIR"
    if python3 pdf_to_cbz.py "$pdf_file" -d 150 -f png; then
        converted_count=$((converted_count + 1))
        echo "✓ Converted: $pdf_basename.cbz"
    else
        echo "✗ Failed: $pdf_file"
    fi

done < <(find "$COMICS_DIR" -type f -name "*.pdf" -print0)

# Deactivate virtual environment
deactivate

echo ""
echo "=== Conversion Complete ==="
echo "Found: $pdf_count PDFs"
echo "Converted: $converted_count PDFs"
echo "Skipped: $((pdf_count - converted_count)) PDFs (already converted)"
