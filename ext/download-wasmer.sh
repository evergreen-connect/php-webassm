#!/usr/bin/env bash
set -euo pipefail

WASMER_VERSION="${WASMER_VERSION:-7.2.0}"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LIB_DIR="$SCRIPT_DIR/lib"
INCLUDE_DIR="$SCRIPT_DIR/include"

OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
MACHINE="$(uname -m)"

case "$MACHINE" in
    x86_64|amd64)  ARCH="amd64" ;;
    aarch64|arm64) ARCH="aarch64" ;;
    *)
        echo "error: unsupported architecture: $MACHINE" >&2
        exit 1
        ;;
esac

case "$OS" in
    linux)  OS="linux" ;;
    darwin)
        OS="darwin"
        if [ "$ARCH" = "aarch64" ]; then ARCH="arm64"; fi
        ;;
    *)
        echo "error: unsupported OS: $OS" >&2
        exit 1
        ;;
esac

URL="https://github.com/wasmerio/wasmer/releases/download/v${WASMER_VERSION}/wasmer-${OS}-${ARCH}.tar.gz"

if [ -f "$LIB_DIR/libwasmer.so" ] || [ -f "$LIB_DIR/libwasmer.dylib" ]; then
    INSTALLED=""
    if [ -f "$INCLUDE_DIR/wasmer.h" ]; then
        INSTALLED=$(grep '#define WASMER_VERSION ' "$INCLUDE_DIR/wasmer.h" 2>/dev/null \
            | sed 's/.*"\(.*\)".*/\1/' || true)
    fi
    if [ "$INSTALLED" = "$WASMER_VERSION" ]; then
        echo "wasmer $WASMER_VERSION already installed in $LIB_DIR"
        exit 0
    fi
fi

TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

echo "downloading wasmer $WASMER_VERSION for $OS/$ARCH..."
curl --retry 3 --retry-delay 2 -fSL "$URL" -o "$TMPDIR/wasmer.tar.gz"

echo "extracting..."
tar xzf "$TMPDIR/wasmer.tar.gz" -C "$TMPDIR"

mkdir -p "$LIB_DIR" "$INCLUDE_DIR"

cp "$TMPDIR/lib/libwasmer.so" "$LIB_DIR/" 2>/dev/null || true
cp "$TMPDIR/lib/libwasmer.dylib" "$LIB_DIR/" 2>/dev/null || true
cp "$TMPDIR/lib/libwasmer.a" "$LIB_DIR/" 2>/dev/null || true
cp "$TMPDIR/include/wasm.h" "$INCLUDE_DIR/"
cp "$TMPDIR/include/wasmer.h" "$INCLUDE_DIR/"
cp "$TMPDIR/include/wasmer_wasm.h" "$INCLUDE_DIR/" 2>/dev/null || true

echo "wasmer $WASMER_VERSION installed to $LIB_DIR"
