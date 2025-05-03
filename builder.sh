#!/bin/bash

APP_NAME="musily_installer"
BUILD_DIR="build/linux/x64/release/bundle"
OUTPUT_DIR="./output"
TEMP_DIR=$(mktemp -d)

mkdir -p "$OUTPUT_DIR"

echo "Creating tar.gz of the build..."
tar -czf "$TEMP_DIR/$APP_NAME.tar.gz" -C "$BUILD_DIR" .

echo "Converting tar.gz to C array..."
xxd -i "$TEMP_DIR/$APP_NAME.tar.gz" > "$TEMP_DIR/raw_hex.txt"

TAR_SIZE=$(stat -c%s "$TEMP_DIR/$APP_NAME.tar.gz")

cat > "$TEMP_DIR/binary_data.c" <<EOF
unsigned char app_data_tar_gz[] = {
$(grep -v "unsigned" "$TEMP_DIR/raw_hex.txt" | grep -v "=" | grep -v ";" | tr -d '\n' | sed 's/^/  /g')
};
unsigned int app_data_tar_gz_len = $TAR_SIZE;
EOF

echo "Created binary_data.c"

C_SRC_FILE="$TEMP_DIR/build_launcher.c"

cat > "$C_SRC_FILE" <<EOF
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

#include "binary_data.c"

#define APP_NAME "$APP_NAME"
#define TAR_FILE_PATH "/tmp/" APP_NAME ".tar.gz"
#define EXTRACT_DIR "/tmp/" APP_NAME "/"

void extract_tar() {
    system("mkdir -p " EXTRACT_DIR);
    char cmd[512];
    snprintf(cmd, sizeof(cmd), "tar -xzf %s -C %s", TAR_FILE_PATH, EXTRACT_DIR);
    system(cmd);
}

void run_app() {
    chdir(EXTRACT_DIR);
    system("./$APP_NAME &");
}

int main() {
    FILE *tar_file = fopen(TAR_FILE_PATH, "wb");
    if (!tar_file) {
        perror("Unable to create tar file");
        return 1;
    }

    fwrite(app_data_tar_gz, app_data_tar_gz_len, 1, tar_file);
    fclose(tar_file);

    extract_tar();
    run_app();

    return 0;
}
EOF

echo "Compiling the C source..."
gcc "$C_SRC_FILE" -o "$OUTPUT_DIR/$APP_NAME.run"

if [ $? -eq 0 ]; then
    rm -rf "$TEMP_DIR"
    echo "✅ Compilation complete. The standalone executable is located at $OUTPUT_DIR/$APP_NAME-launcher."
else
    echo "❌ Compilation failed. Temporary files are kept at $TEMP_DIR for debugging."
    echo "Content of binary_data.c (first 10 lines):"
    head -10 "$TEMP_DIR/binary_data.c"
fi