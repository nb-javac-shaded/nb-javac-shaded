#!/bin/bash

# Verify that the shaded JARs contain properly relocated classes

echo "Checking nb-javac-shaded..."
echo "  Shaded classes (should have results):"
jar tf nb-javac-shaded/target/nb-javac-shaded-26.27.jar | grep "^shaded/com/sun/tools/" | head -3
echo "  Original classes (should be empty):"
jar tf nb-javac-shaded/target/nb-javac-shaded-26.27.jar | grep "^com/sun/tools/" | head -3

echo ""
echo "Checking nb-javac-api-shaded..."
echo "  Shaded classes (should have results):"
jar tf nb-javac-api-shaded/target/nb-javac-api-shaded-26.27.jar | grep "^shaded/com/sun/source/" | head -3
echo "  Original classes (should be empty):"
jar tf nb-javac-api-shaded/target/nb-javac-api-shaded-26.27.jar | grep "^com/sun/source/" | head -3

echo ""
echo "  Shaded javax.tools (should have results):"
jar tf nb-javac-api-shaded/target/nb-javac-api-shaded-26.27.jar | grep "^shaded/javax/tools/" | head -3
echo "  Original javax.tools (should be empty):"
jar tf nb-javac-api-shaded/target/nb-javac-api-shaded-26.27.jar | grep "^javax/tools/" | head -3

echo ""
echo "File sizes:"
ls -lh nb-javac-shaded/target/nb-javac-shaded-26.27.jar nb-javac-api-shaded/target/nb-javac-api-shaded-26.27.jar | awk '{print $9, $5}'

echo ""
echo "If the 'Original classes' sections are empty and 'Shaded classes' show results, shading worked correctly!"
