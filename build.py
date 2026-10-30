from pathlib import Path
from shutil import copytree


ROOT = Path(__file__).resolve().parent
copytree(ROOT / "frontend", ROOT / "public", dirs_exist_ok=True)
print("Published the expense dashboard frontend.")
