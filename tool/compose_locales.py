"""Merge tool/locale_chunks/fa_*.json and ps_*.json into lib/l10n/app_fa.arb and app_ps.arb."""
from __future__ import annotations

import json
import glob
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent


def _load_chunks(prefix: str) -> dict[str, str]:
    out: dict[str, str] = {}
    paths = sorted(glob.glob(str(ROOT / "tool" / "locale_chunks" / f"{prefix}_*.json")))
    for p in paths:
        chunk = json.loads(Path(p).read_text(encoding="utf-8"))
        out.update(chunk)
    return out


def _build(locale: str, tr: dict[str, str]) -> dict:
    en = json.loads((ROOT / "lib" / "l10n" / "app_en.arb").read_text(encoding="utf-8"))
    out: dict = {}
    for k, v in en.items():
        if k == "@@locale":
            out[k] = locale
        elif k.startswith("@"):
            out[k] = v
        elif isinstance(v, str):
            out[k] = tr.get(k, v)
        else:
            out[k] = v
    return out


def main() -> None:
    fa = _load_chunks("fa")
    ps = _load_chunks("ps")
    enc = json.dumps(_build("fa", fa), ensure_ascii=False, indent=2) + "\n"
    (ROOT / "lib" / "l10n" / "app_fa.arb").write_text(enc, encoding="utf-8")
    encp = json.dumps(_build("ps", ps), ensure_ascii=False, indent=2) + "\n"
    (ROOT / "lib" / "l10n" / "app_ps.arb").write_text(encp, encoding="utf-8")
    print("merged", len(fa), "fa keys,", len(ps), "ps keys")


if __name__ == "__main__":
    main()
