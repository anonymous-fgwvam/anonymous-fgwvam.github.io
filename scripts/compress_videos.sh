#!/usr/bin/env bash
# Compress demo videos to 720p H.264, no audio, no metadata.
# Usage: bash scripts/compress_videos.sh [input_dir] [output_dir]
set -euo pipefail

IN="${1:-raw_videos}"
OUT="${2:-videos}"

mkdir -p "$OUT"

shopt -s nullglob
files=("$IN"/*.mp4)
if [ ${#files[@]} -eq 0 ]; then
  echo "No .mp4 files found in $IN" >&2
  exit 1
fi

for f in "${files[@]}"; do
  base="$(basename "$f")"
  echo "Encoding $base -> $OUT/$base"
  ffmpeg -y -i "$f" \
    -vf "scale=1280:-2,fps=30" \
    -c:v libx264 -crf 26 -preset slow -pix_fmt yuv420p \
    -an -map_metadata -1 -movflags +faststart \
    "$OUT/$base"
done

echo "Done. Sizes:"
du -h "$OUT"/*.mp4