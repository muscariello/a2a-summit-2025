#!/bin/bash

# Build script for AI Agent Discovery slides
# Generates PDF presentation from Markdown source using Pandoc and Beamer

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo -e "${BLUE}🎯 Building AI Agent Discovery Slides${NC}"
echo "Working directory: $SCRIPT_DIR"

# Check if required files exist
if [ ! -f "ai-agent-discovery-slide-deck.md" ]; then
    echo -e "${RED}❌ Error: ai-agent-discovery-slide-deck.md not found${NC}"
    exit 1
fi

if [ ! -f "outshift-logo.png" ]; then
    echo -e "${YELLOW}⚠️  Warning: outshift-logo.png not found - logo may not display${NC}"
fi

# Check if pandoc is installed
if ! command -v pandoc &> /dev/null; then
    echo -e "${RED}❌ Error: pandoc is not installed${NC}"
    echo -e "${YELLOW}💡 Install with: brew install pandoc (macOS) or apt-get install pandoc (Linux)${NC}"
    exit 1
fi

# Check if LaTeX is available
if ! command -v pdflatex &> /dev/null; then
    echo -e "${RED}❌ Error: pdflatex is not installed${NC}"
    echo -e "${YELLOW}💡 Install LaTeX distribution (MacTeX for macOS, TeX Live for Linux)${NC}"
    exit 1
fi

echo -e "${YELLOW}🔧 Building slides...${NC}"

# Build the slides
pandoc ai-agent-discovery-slide-deck.md \
    -t beamer \
    -s \
    -o ai-agent-discovery-slides.pdf

# Check if build was successful
if [ $? -eq 0 ] && [ -f "ai-agent-discovery-slides.pdf" ]; then
    # Get file size
    SIZE=$(ls -lh ai-agent-discovery-slides.pdf | awk '{print $5}')
    echo -e "${GREEN}✅ Slides built successfully!${NC}"
    echo -e "${GREEN}📄 Output: ai-agent-discovery-slides.pdf (${SIZE})${NC}"

    # Optional: Open the PDF if on macOS
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo -e "${BLUE}🔍 Opening slides...${NC}"
        open ai-agent-discovery-slides.pdf
    fi
else
    echo -e "${RED}❌ Failed to build slides${NC}"
    exit 1
fi

echo -e "${GREEN}🎉 Build complete!${NC}"