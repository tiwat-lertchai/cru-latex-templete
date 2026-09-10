# AGENTS.md

## Project overview

This repository is a XeLaTeX template for undergraduate research documents in
the Computer Science and Artificial Intelligence program, Faculty of Science,
Chandrakasem Rajabhat University (CRU). Its primary audience writes in Thai.
The bundled TH Sarabun New fonts and the Docker image make builds reproducible
without requiring a local TeX or font installation.

There are two independent document entry points:

- `main.tex` builds the complete research report or thesis.
- `research-proposal.tex` builds the CS1 research-topic proposal form.

Do not assume that a change to one document affects the other. Compile every
entry point touched by a change.

## Repository map

- `config/document-info.tex`: reusable metadata for `main.tex`, including
  titles, author information, advisers, academic year, keywords, and optional
  content switches.
- `config/layout.tex`: shared layout and LaTeX behavior for the complete report.
  Treat this as infrastructure; edit it only for intentional template-wide
  formatting changes.
- `config/proposal-info.tex`: reusable student, title, adviser, schedule,
  hardware, and software values for `research-proposal.tex`.
- `front-matter/`: title page, approval page, abstracts, and acknowledgements
  for the complete report.
- `chapters/`: numbered report chapters, assembled in order by `main.tex`.
- `back-matter/`: bibliography and appendices for the complete report.
- `figures/`: document images; `config/layout.tex` already adds this directory
  to the graphics search path.
- `fonts/`: the four required TH Sarabun New font files. Keep their filenames
  synchronized with the `fontspec` declarations.
- `logo/`: CRU branding used by the document.
- `examples/`: committed example PDF and README preview image.
- `Dockerfile` and `compose.yaml`: canonical XeLaTeX build environment.
- `output/`, `comparison/`, and `tmp/`: generated or working artifacts, not
  source files unless a task explicitly says otherwise.

## Source-of-truth rules

1. Edit LaTeX sources, configuration, images, or fonts—not generated `.pdf`,
   `.aux`, `.log`, `.toc`, `.lof`, `.lot`, `.fls`, `.fdb_latexmk`, or `.xdv`
   files.
2. For repeated report metadata, change `config/document-info.tex` instead of
   hard-coding the same value in front-matter files.
3. For proposal metadata, change `config/proposal-info.tex` instead of
   duplicating values in `research-proposal.tex`.
4. Edit `main.tex` only when adding, removing, or reordering complete-report
   sections. Add a new appendix by creating its file and then adding an
   `\input{...}` after `\appendix`.
5. Preserve user-specific content already present. Do not replace names,
   student IDs, research text, or pending placeholders unless the task asks for
   that content change.
6. Before editing, check `git status --short`. The worktree may contain user
   files or generated artifacts; do not discard or overwrite unrelated changes.

## Authoring conventions

- Save `.tex` files as UTF-8 and compile with XeLaTeX only. Do not switch the
  project to pdfLaTeX.
- Write Thai text directly. Use a blank line for a new paragraph; do not imitate
  indentation with repeated spaces, `\quad`, or `\qquad`.
- Escape LaTeX special characters in prose where appropriate, including `\%`,
  `\&`, `\_`, `\#`, and `\$`.
- Use `\textenglish{...}` when an English span needs explicit language
  handling.
- Each report chapter begins with `\chapter{...}`. Use `\section`,
  `\subsection`, and `\subsubsection` for the hierarchy; do not hand-type
  section numbers.
- Put table captions above tables and figure captions below figures. Place each
  `\label` immediately after its `\caption`, and use stable prefixes such as
  `tab:`, `fig:`, and `eq:`.
- Keep images in `figures/` and refer to them by filename when using the report
  layout's configured graphics path. Remember that Docker/Linux paths are
  case-sensitive.
- Prefer semantic LaTeX commands over manual spacing or page-position hacks.
  If a localized spacing adjustment is unavoidable, explain why in a comment.
- Existing structural comments are bilingual in the form `ไทย / English`.
  Follow that style when adding comments intended to guide template users.
- Keep institution names, degree terminology, page numbering, margins, and
  typography consistent with the existing template unless the task explicitly
  changes CRU formatting requirements.

## Optional report content

The switches at the top of `config/document-info.tex` control optional content:

- `\includeenglishabstracttrue` / `\includeenglishabstractfalse`
- `\secondauthortrue` / `\secondauthorfalse`
- `\coadvisortrue` / `\coadvisorfalse`

When enabling a switch, also populate its related metadata. Do not modify the
title-page or approval-page table structure merely to turn these items on.

## Build and verification

Docker Compose is the canonical verification path. Use `docker compose` when
available; `docker-compose` is the compatible standalone alternative.

Build the complete report:

```bash
docker compose run --rm latex
```

Build the proposal:

```bash
docker compose run --rm latex -xelatex -interaction=nonstopmode -halt-on-error research-proposal.tex
```

Clean complete-report build artifacts when necessary:

```bash
docker compose run --rm latex -C main.tex
```

For every LaTeX change:

1. Compile each affected entry point and require a zero exit status.
2. Inspect the log for `LaTeX Error`, undefined control sequences, missing
   files, undefined references/citations, and serious overfull boxes. Do not
   treat a produced PDF alone as proof of success.
3. When layout, pagination, tables, figures, fonts, or front matter changes,
   render or open the affected PDF pages and visually inspect them. Check Thai
   glyphs, clipping, line breaks, spacing, page numbers, and caption placement.
4. If a template-wide change intentionally updates the public example, rebuild
   and review `examples/example-thesis.pdf` and its preview image. Do not update
   these artifacts for ordinary research-content edits.

If Docker is unavailable, report that verification limitation clearly. A local
`latexmk -xelatex` build is useful only when the required TeX packages and fonts
are known to match the Docker environment.

## Definition of done

A change is complete when the requested source files are updated, unrelated
worktree changes remain untouched, all affected documents compile successfully,
and visually sensitive changes have been inspected in the resulting PDF. In the
handoff, state which entry points were built and mention any remaining warnings
or placeholders that require the user's confirmation.
