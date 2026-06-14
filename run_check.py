"""
run_check.py
────────────
Run this script to verify your dataset is ready before training.
Place in project root and run: python run_check.py

Written for Bhawna (ML Engineer).
"""

from pathlib import Path

checks = {
    "Stage 1 — Lemon vs Others": {
        "path": "data/stage1_binary",
        "classes": ["lemon_leaf", "other_leaf", "other_object"],
        "min_images": 300
    },
    "Stage 2 — Disease Classification": {
        "path": "data/stage2_disease",
        "classes": ["healthy", "citrus_canker", "greasy_spot",
                    "sooty_mold", "yellow_mosaic", "powdery_mildew"],
        "min_images": 100
    }
}

print("\n" + "="*50)
print("  Lemon Disease Dataset Check")
print("="*50)

all_ok = True
total_images = 0

for stage_name, info in checks.items():
    print(f"\n📂 {stage_name}")
    print(f"   Path: {info['path']}")
    print()

    for cls in info["classes"]:
        folder = Path(info["path"]) / cls

        if not folder.exists():
            print(f"   ✗  MISSING folder: {folder}")
            all_ok = False
            continue

        images = (list(folder.glob("*.jpg")) +
                  list(folder.glob("*.jpeg")) +
                  list(folder.glob("*.png")) +
                  list(folder.glob("*.JPG")) +
                  list(folder.glob("*.PNG")))
        count = len(images)
        total_images += count

        if count >= info["min_images"]:
            bar = "█" * min(20, count // 20)
            print(f"   ✓  {cls:<20} {count:>4} images  {bar}")
        else:
            needed = info["min_images"] - count
            print(f"   ⚠  {cls:<20} {count:>4} images  (need {needed} more)")
            all_ok = False

print()
print("="*50)
print(f"  Total images found: {total_images}")
print("="*50)

if all_ok:
    print("\n  ✅ Dataset ready! You can start training.")
    print("     Run: python -m ml.training.train_stage1")
else:
    print("\n  ⚠️  Fix the issues above before training.")
    print("     Add more images to folders marked with ⚠")
print()
