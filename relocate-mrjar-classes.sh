#!/bin/bash
set -e

# Script to relocate multi-release JAR classes to match shaded package names
# Usage: relocate-mrjar-classes.sh <jar-path>

JAR_FILE="$1"
if [ ! -f "$JAR_FILE" ]; then
    echo "Error: JAR not found: $JAR_FILE"
    exit 1
fi

TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

echo "Extracting JAR to temporary directory..."
unzip -q "$JAR_FILE" -d "$TEMP_DIR"

# Relocate multi-release JAR classes
echo "Relocating multi-release JAR classes..."
if [ -d "$TEMP_DIR/META-INF/versions" ]; then
    for VERSION_DIR in "$TEMP_DIR/META-INF/versions"/*; do
        if [ -d "$VERSION_DIR" ]; then
            VERSION=$(basename "$VERSION_DIR")
            echo "  Processing Java $VERSION classes..."

            # Move com/sun/tools and com/sun/source -> shaded/com/sun/...
            if [ -d "$VERSION_DIR/com/sun" ]; then
                mkdir -p "$VERSION_DIR/shaded/com/sun"
                [ -d "$VERSION_DIR/com/sun/tools" ] && mv "$VERSION_DIR/com/sun/tools" "$VERSION_DIR/shaded/com/sun/" 2>/dev/null || true
                [ -d "$VERSION_DIR/com/sun/source" ] && mv "$VERSION_DIR/com/sun/source" "$VERSION_DIR/shaded/com/sun/" 2>/dev/null || true
                # Clean up empty dirs
                rmdir "$VERSION_DIR/com/sun" 2>/dev/null || true
                rmdir "$VERSION_DIR/com" 2>/dev/null || true
            fi

            # Move javax packages -> shaded/javax/...
            if [ -d "$VERSION_DIR/javax" ]; then
                mkdir -p "$VERSION_DIR/shaded/javax"
                [ -d "$VERSION_DIR/javax/annotation" ] && mv "$VERSION_DIR/javax/annotation" "$VERSION_DIR/shaded/javax/" 2>/dev/null || true
                [ -d "$VERSION_DIR/javax/lang" ] && mv "$VERSION_DIR/javax/lang" "$VERSION_DIR/shaded/javax/" 2>/dev/null || true
                [ -d "$VERSION_DIR/javax/tools" ] && mv "$VERSION_DIR/javax/tools" "$VERSION_DIR/shaded/javax/" 2>/dev/null || true
                # Clean up empty javax dir
                rmdir "$VERSION_DIR/javax" 2>/dev/null || true
            fi
        fi
    done
fi

echo "Repacking JAR..."
# Delete original JAR first
rm -f "$JAR_FILE"
cd "$TEMP_DIR"
zip -q -r "$JAR_FILE" .
cd - > /dev/null

echo "Successfully relocated multi-release JAR classes in $JAR_FILE"
