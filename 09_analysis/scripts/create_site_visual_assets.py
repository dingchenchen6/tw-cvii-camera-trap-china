#!/usr/bin/env python3
"""Generate public website visual assets from open-licensed source material.

The script crops figures from local PDF page renders that are already used in the
project audit trail. It does not download or modify source PDFs.
"""

from pathlib import Path

from PIL import Image, ImageOps


ROOT = Path(__file__).resolve().parents[2]
MEDIA_DIR = ROOT / "assets" / "media"
PDF_PREVIEW_DIR = ROOT / "tmp" / "pdf_preview"


def crop_image(source: Path, bbox: tuple[int, int, int, int], target: Path, max_width: int = 1400) -> None:
    image = Image.open(source).convert("RGB")
    crop = ImageOps.autocontrast(image.crop(bbox))
    if crop.width > max_width:
        ratio = max_width / crop.width
        crop = crop.resize((max_width, round(crop.height * ratio)), Image.Resampling.LANCZOS)
    target.parent.mkdir(parents=True, exist_ok=True)
    crop.save(target, quality=92, optimize=True)


def main() -> None:
    crop_image(
        PDF_PREVIEW_DIR / "zhao" / "page-10.png",
        (108, 648, 866, 1096),
        MEDIA_DIR / "huangshan-camera-trap-species.jpg",
    )
    crop_image(
        PDF_PREVIEW_DIR / "zhao" / "page-04.png",
        (108, 205, 870, 695),
        MEDIA_DIR / "huangshan-camera-network.jpg",
    )
    crop_image(
        PDF_PREVIEW_DIR / "zhao" / "page-12.png",
        (110, 650, 850, 1038),
        MEDIA_DIR / "huangshan-nocturnal-index.jpg",
    )


if __name__ == "__main__":
    main()
