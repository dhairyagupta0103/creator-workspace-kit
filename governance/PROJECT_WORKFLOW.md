# Project workflow

## Folder contract
Each project lives in `projects/<id>/`:
- `project.json`: identity, category, status and version.
- `README.md`: purpose and preview/run notes.
- `PROGRESS.md`: concise resume point.
- `CHANGELOG.md`: meaningful completed changes.
- `index.html`, `styles.css`, `app.js`: static browser app.
- `assets/`: project-owned files.

## Create
Create a branch first, then run:

```sh
node scripts/create-project.mjs <slug> "<title>" "<summary>" <category>
```

If shell access is unavailable, create the same structure using the available GitHub file tools. Do not ask the creator to perform technical steps.

## Resume
Search matching branches first. An unfinished project may exist only on a branch and not yet appear on `main`. Read that branch's project catalogue and records, then continue there.

## Experiment and finish
Use `experiment/` for uncertain ideas and `work/` for planned features. Keep the first version small. Test and preview on the branch. When complete, open a PR to `main`.
