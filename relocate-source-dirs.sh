#!/bin/bash
set -e

# Script to reorganize shaded source JAR directory structure to match package declarations
# Usage: relocate-source-dirs.sh <sources-jar-path>

SOURCES_JAR="$1"
if [ ! -f "$SOURCES_JAR" ]; then
    echo "Error: Sources JAR not found: $SOURCES_JAR"
    exit 1
fi

TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

echo "Extracting sources JAR to temporary directory..."
unzip -q "$SOURCES_JAR" -d "$TEMP_DIR"

# Create shaded directory structure
mkdir -p "$TEMP_DIR/shaded"

# Relocate directories that were shaded
echo "Relocating source directories to match shaded packages..."

# Move com/sun/tools -> shaded/com/sun/tools
if [ -d "$TEMP_DIR/src" ]; then
    find "$TEMP_DIR/src" -type d -path "*/classes/com" | while read -r COM_DIR; do
        CLASSES_DIR=$(dirname "$COM_DIR")
        if [ -d "$CLASSES_DIR/com/sun/tools" ] || [ -d "$CLASSES_DIR/com/sun/source" ]; then
            mkdir -p "$CLASSES_DIR/shaded/com/sun"
            [ -d "$CLASSES_DIR/com/sun/tools" ] && mv "$CLASSES_DIR/com/sun/tools" "$CLASSES_DIR/shaded/com/sun/" 2>/dev/null || true
            [ -d "$CLASSES_DIR/com/sun/source" ] && mv "$CLASSES_DIR/com/sun/source" "$CLASSES_DIR/shaded/com/sun/" 2>/dev/null || true
        fi
    done
fi

# Move javax/annotation/processing, javax/lang, javax/tools -> shaded/javax/...
if [ -d "$TEMP_DIR/src" ]; then
    find "$TEMP_DIR/src" -type d -path "*/classes/javax" | while read -r JAVAX_DIR; do
        CLASSES_DIR=$(dirname "$JAVAX_DIR")
        mkdir -p "$CLASSES_DIR/shaded/javax"
        [ -d "$CLASSES_DIR/javax/annotation" ] && mv "$CLASSES_DIR/javax/annotation" "$CLASSES_DIR/shaded/javax/" 2>/dev/null || true
        [ -d "$CLASSES_DIR/javax/lang" ] && mv "$CLASSES_DIR/javax/lang" "$CLASSES_DIR/shaded/javax/" 2>/dev/null || true
        [ -d "$CLASSES_DIR/javax/tools" ] && mv "$CLASSES_DIR/javax/tools" "$CLASSES_DIR/shaded/javax/" 2>/dev/null || true
        # Clean up empty javax dir if it exists
        [ -d "$CLASSES_DIR/javax" ] && rmdir "$CLASSES_DIR/javax" 2>/dev/null || true
    done
fi

# Also handle test sources if present
if [ -d "$TEMP_DIR/make/langtools/netbeans/nb-javac/test" ]; then
    cd "$TEMP_DIR/make/langtools/netbeans/nb-javac/test"

    # Move com/sun/tools and com/sun/source -> shaded/com/sun/...
    if [ -d "com/sun" ]; then
        mkdir -p "shaded/com/sun"

        # Move tools if it exists
        if [ -d "com/sun/tools" ]; then
            if [ -d "shaded/com/sun/tools" ]; then
                # Merge into existing
                cp -r com/sun/tools/* shaded/com/sun/tools/
                rm -rf com/sun/tools
            else
                mv com/sun/tools shaded/com/sun/
            fi
        fi

        # Move source if it exists
        if [ -d "com/sun/source" ]; then
            if [ -d "shaded/com/sun/source" ]; then
                # Merge into existing
                cp -r com/sun/source/* shaded/com/sun/source/
                rm -rf com/sun/source
            else
                mv com/sun/source shaded/com/sun/
            fi
        fi

        # Clean up empty dirs
        rmdir "com/sun" 2>/dev/null || true
        rmdir "com" 2>/dev/null || true
    fi

    # Move javax packages -> shaded/javax/...
    if [ -d "javax" ]; then
        mkdir -p "shaded/javax"
        for pkg in annotation lang tools; do
            if [ -d "javax/$pkg" ]; then
                if [ -d "shaded/javax/$pkg" ]; then
                    cp -r "javax/$pkg"/* "shaded/javax/$pkg/"
                    rm -rf "javax/$pkg"
                else
                    mv "javax/$pkg" "shaded/javax/"
                fi
            fi
        done
        rmdir "javax" 2>/dev/null || true
    fi

    cd - > /dev/null
fi

# Flatten OpenJDK module structure (src/MODULE_NAME/share/classes/* -> *)
echo "Flattening OpenJDK module structure..."
if [ -d "$TEMP_DIR/src" ]; then
    # Move all module contents to temp root
    for MODULE_DIR in "$TEMP_DIR/src"/*; do
        if [ -d "$MODULE_DIR/share/classes" ]; then
            # Copy contents up to root, merging if necessary
            cp -r "$MODULE_DIR/share/classes"/* "$TEMP_DIR/"
        fi
    done
    # Remove the src directory
    rm -rf "$TEMP_DIR/src"
fi

# Also flatten the make/langtools/netbeans/nb-javac structure if present
if [ -d "$TEMP_DIR/make" ]; then
    # Keep test sources but flatten unnecessary nesting - actually, just remove make/ entirely
    # since test sources are already under shaded/ after our relocation
    rm -rf "$TEMP_DIR/make"
fi

echo "Repacking sources JAR..."
# Delete original JAR first (zip -r updates existing files instead of replacing)
rm -f "$SOURCES_JAR"
cd "$TEMP_DIR"
zip -q -r "$SOURCES_JAR" .
cd - > /dev/null

echo "Successfully reorganized source directories in $SOURCES_JAR"
