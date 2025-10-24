#!/bin/bash

# Script to generate URDF files from xacro for different robot variants
# Run this script from the package root directory

set -e  # Exit on error

# Define paths
FILEPATH_XACRO="urdf/wxai.urdf.xacro"
OUTPUT_DIR="urdf/generated/wxai"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

echo "Generating URDF files from $FILEPATH_XACRO"
echo "Output directory: $OUTPUT_DIR"
echo ""

# Function to remove XML comments and ros2_control sections from a file
urdf_cleanup() {
    local file="$1"
    # Remove XML comments (<!-- ... -->) including multiline comments
    sed -i 's/<!--.*-->//g' "$file"
    # Remove ros2_control tags and everything between them (multiline)
    sed -i '/<ros2_control/,/<\/ros2_control>/d' "$file"
    # Remove lines that are now empty or only whitespace
    sed -i '/^[[:space:]]*$/d' "$file"
}

# Generate base variant
echo "Generating base variant..."
xacro "$FILEPATH_XACRO" variant:=base > "$OUTPUT_DIR/wxai_base.urdf"
urdf_cleanup "$OUTPUT_DIR/wxai_base.urdf"
echo "  ✓ Created wxai_base.urdf"

# Generate follower variant
echo "Generating follower variant..."
xacro "$FILEPATH_XACRO" variant:=follower > "$OUTPUT_DIR/wxai_follower.urdf"
urdf_cleanup "$OUTPUT_DIR/wxai_follower.urdf"
echo "  ✓ Created wxai_follower.urdf"

# Generate follower_compliant variant
echo "Generating follower_compliant variant..."
xacro "$FILEPATH_XACRO" variant:=follower_compliant > "$OUTPUT_DIR/wxai_follower_compliant.urdf"
urdf_cleanup "$OUTPUT_DIR/wxai_follower_compliant.urdf"
echo "  ✓ Created wxai_follower_compliant.urdf"

# Generate leader variant - left arm
echo "Generating leader variant (left arm)..."
xacro "$FILEPATH_XACRO" variant:=leader arm_side:=left > "$OUTPUT_DIR/wxai_leader_left.urdf"
urdf_cleanup "$OUTPUT_DIR/wxai_leader_left.urdf"
echo "  ✓ Created wxai_leader_left.urdf"

# Generate leader variant - right arm
echo "Generating leader variant (right arm)..."
xacro "$FILEPATH_XACRO" variant:=leader arm_side:=right > "$OUTPUT_DIR/wxai_leader_right.urdf"
urdf_cleanup "$OUTPUT_DIR/wxai_leader_right.urdf"
echo "  ✓ Created wxai_leader_right.urdf"

echo ""
echo "All URDF files generated successfully in $OUTPUT_DIR"
