# Uploading No Crack Nag to the Steam Workshop

This bundle was assembled by `build.sh`. The in-game uploader (Main Menu →
Workshop → Create and upload) reads the folder laid out here.

## First publish

1. Copy the assembled `NoCrackNag/` folder (the one next to this file) into
   `C:\Users\<you>\Zomboid\Workshop\` so you have
   `...\Zomboid\Workshop\NoCrackNag\Contents\mods\NoCrackNag\42\mod.info`
   plus `workshop.txt` and `preview.png` at `...\Workshop\NoCrackNag\`.
2. Restart Project Zomboid (it scans the Workshop folder at launch).
3. Main Menu → Workshop → "Create and upload" → pick **No Crack Nag**.
4. Steam assigns a Workshop id. Paste it back into
   `workshop-meta/workshop.txt` as `id=<number>` so future `build.sh` runs
   target the same item for updates.

## Updates

Bump `modversion=` in `Contents/mods/NoCrackNag/42/mod.info`, re-run
`./build.sh <out>`, and re-upload the same item (id is now filled in).

## Notes

- Build 42 only. The mod is client-side; each player who wants the nag gone
  subscribes to it. It does nothing on its own — it only filters output from
  RepairWallCracksExtended (Workshop id 2964212585).
- `preview.png` must be a 256×256 (or larger square) PNG. Not yet created —
  add one before publishing.
