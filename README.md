# SysML Context Package

Contents assembled for the agent:
- `formal-25-09-05.pdf` — full specification PDF (symlink to root file).
- `context_examples/` — curated one-per-grammar pairs (47/47 grammar types).
- `generation_prompts/` — 104 extra prompts (NL only, real files), each folder contains `nl.txt` for generation.

Usage for the agent:
1) Load `context_examples/` pairs to cover every grammar type.
2) Use `generation_prompts/` as extra NL prompts for generation; there is no paired `design.sysml` here by design.
3) Always read `nl.txt` and `design.sysml` together in `context_examples/`; for `generation_prompts/`, only `nl.txt` is available.
