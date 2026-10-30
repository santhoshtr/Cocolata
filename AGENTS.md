# AGENTS.md

Guidance for coding agents that work in this repository.

## What this is

Cocolata is a handwriting-style variable typeface for Malayalam and Latin. The
font is *generated*, not hand-drawn: MetaPost programs describe each glyph
parametrically, a Rust tool turns the rendered SVGs into UFO masters and
OpenType features, and `fontc` interpolates them into a single variable font
(`wght` 100–900).

## Build pipeline

The full chain, orchestrated by the root `Makefile`:

1. **MetaPost → SVG** (`make glyphs`): `sources/Makefile` runs `mpost` on every
   `sources/glyphs/*.mp`, once per weight. The weight is selected by
   `VARIANT=<Style>`, which loads `sources/config/<Style>.mp` (sets `thick`,
   `contrast`). Output: `sources/svgs/<Style>/*.svg`.
2. **SVG → UFO masters + features** (`make ufo`): the Rust binary's `build`
   subcommand reads `config.yaml` + `Cocolata.designspace`, converts each
   style's SVGs to a `.ufo` under `sources/ufo/`, and writes `features.fea`.
3. **UFO → variable TTF** (`make build`): `fontc` compiles the designspace into
   `fonts/Cocolata-variable.ttf`, then the Rust `postprocess` subcommand mutates
   it in place (adds a `prep` program, strips AAT tables, builds STAT).
4. **WOFF2**: Rust `woff2` subcommand compresses the TTF.

`STYLES` and `UFO` make variables are derived dynamically by invoking the Rust
binary (`Cocolata styles`), so the binary is built first if missing.

## Commands

```bash
make            # full build (ufo + variable TTF + woff2); ~15 min, use make -jN
make init       # build only the Rust tool (target/release/Cocolata)
make glyphs     # regenerate per-style SVGs from MetaPost
make ufo        # rebuild UFO masters from SVGs
make test       # ots-sanitize + fontspector QA (writes tests/fontspector-report.*)
make proofs     # hb-view PDF specimens into proofs/
make metrics-report   # vertical-metrics report for the built TTF
make dev        # inotify watch loop: rebuild UFOs on glyph source change
make clean

cargo build --release      # the font tool
cargo test                 # Rust unit tests
cargo clippy

# Run the tool directly (subcommands: build, styles, postprocess, woff2, report)
target/release/Cocolata build --designspace Cocolata.designspace
RUST_LOG=info target/release/Cocolata build ...   # env_logger controls verbosity
```

Single weight while iterating: `VARIANT=Bold make -C sources` regenerates only
Bold SVGs; the `build` subcommand has a `--style` flag for static-only builds.

## Rust tool architecture (`src/`)

`main.rs` is a clap CLI. The `build` subcommand defaults to **variable** mode
(`variable_font.rs`): it builds one `MalayalamFont` master per designspace
source, then merges per-weight feature data into a single unified `features.fea`
via the `templates/features.fea.j2` Jinja template. Static mode
(`malayalam_font.rs`) builds one UFO per style with its own features.

Per-master build sequence (see `build_static_fonts` / `build_masters`):
`build` (SVG conversion + composites) → `set_font_info` → `update_font_version`
→ `build_glyph_groups` → `build_kern` → `set_glyph_order` → write glyphs +
features.

Module map:
- `malayalam_font.rs` — core `MalayalamFont`: SVG→glyph conversion (via
  `svg2glif`), empty/control glyphs, collects `salts`/`onums`/`sups` variant maps.
- `composite.rs` — synthesized glyphs (space, Latin diacritics, La-conjuncts,
  u-signs) built as UFO components rather than outlines.
- `glyphnames.rs` — the naming authority. Maps codepoints → glyph names
  (Malayalam `ml_` prefix, chillu normalization, AGL for Latin), and
  `parse_glyph_filename` interprets the `<name>.<variant>` SVG filename
  convention (variants: `alt1/2/3`, `narrow`, `wide`, `oldnum`, `sups`, `alt`).
- `features.rs` — OpenType feature generation (GSUB/GPOS, conjuncts, reph,
  chillus, anchors, calt, salt). Largest module; data-prepares for the Jinja
  template.
- `kerning.rs`, `groups.rs`, `fontinfo.rs`, `config.rs` — kerning pairs, glyph
  classes/groups, name/metrics metadata, `config.yaml` deserialization.
- `postprocess.rs` — post-`fontc` binary surgery on the variable TTF using the
  `fontations` read/write tables.
- `report.rs` — vertical-metrics report.

## Key files

- `config.yaml` — font metadata, metrics, and **glyph classes** (Latin sets,
  Malayalam consonant/conjunct classes, kerning classes). Drives feature/kerning
  generation; this is where glyph membership lives.
- `Cocolata.designspace` — 9 weight masters (Thin 100 → Black 900) + named
  instances. The single `wght` axis.
- `sources/glyphs/*.mp` — one MetaPost program per glyph; `sources/pens.mp`
  defines the nib/stroke pens; `sources/config/<Style>.mp` sets per-weight
  parameters; `sources/glyphs/include/` holds conjunct/component sub-glyphs.

## Notes / gotchas

- The build is **Rust-based**. `.gitlab-ci.yml` still references Python, poetry,
  and ruff — those are stale from the pre-Rust migration and not part of the
  current build. CI's real build step is `make build release`.
- Requires Rust ≥ 1.99, edition 2024. External binaries on PATH: `mpost`
  (texlive-metapost), `fontc`, `fontspector`, `hb-view` (libharfbuzz-bin),
  `ots-sanitize`, `fc-cache`. The devcontainer (`.devcontainer/`) provisions all
  of these.
- Glyph names use a `ml_` prefix for Malayalam; understand `glyphnames.rs`
  before touching anything that references glyph names by string.

## Run builds in the devcontainer

Run `make`, `cargo`, `fontc`, `mpost` and `typst` in the devcontainer. Do not
run them on the host. The host toolchain is different (for example, the host
`rustc` is older than `rust-version` in `Cargo.toml`). Do not "fix" toolchain
errors that you see on the host.

```bash
devcontainer exec --workspace-folder . bash -c '<command>'   # from the repo root
```

If you add a build tool, add it to `.devcontainer/devcontainer.json`. Also
install it in the running container.

## Glyph edit loop

The maintainer usually has `make dev` running. It runs `make ufo` when a file
in `sources/glyphs/` changes. The UFOs in `sources/ufo/` are updated in less
than one second.

- After you edit `sources/glyphs/*.mp`, do not start your own render or build
  to check the result. Wait for `make dev`, then inspect in Fontra (see below).
  To wait, compare file times:
  `until [ sources/ufo/Cocolata-Regular.ufo/glyphs/<name>.glif -nt sources/glyphs/<file>.mp ]; do sleep 2; done`
- `make dev` watches only the top level of `sources/glyphs/`. Changes in
  `sources/glyphs/include/`, `sources/pens.mp` or `sources/config/` do not
  start a rebuild. For these, ask the maintainer to run `make ufo`.
- If `make dev` is not running, ask before you start a build.

## Inspect glyphs in Fontra

The maintainer runs a Fontra server on this project at `http://localhost:8000`.
Fontra reads the UFOs, so it shows the result of `make dev`. Use the Playwright
browser tools.

- Editor: `http://localhost:8000/editor.html?project=Cocolata.designspace#<hash>`
- Overview of all glyphs:
  `http://localhost:8000/fontoverview.html?project=Cocolata.designspace#<hash>`

`<hash>` is the view state: base64 of zlib-compressed JSON. In the editor, the
`text` key holds the test string. To show a different string, make a new hash:

```bash
python3 -c 'import base64,json,zlib,sys; print(base64.b64encode(zlib.compress(json.dumps({"text": sys.argv[1]}).encode())).decode())' 'A0123456789T'
```

### Measure, do not guess

A screenshot shows the shape. For heights and widths, get the numbers from
Fontra in the page (`browser_evaluate`):

```js
async () => {
  const fc = window.editorController.fontController;
  await fc.reloadGlyphs(["eight"]);            // after a source change
  const g = await fc.getGlyphInstance("eight", {weight: 400});
  return {top: g.bounds.yMax, bottom: g.bounds.yMin, advance: g.xAdvance};
}
```

- Use `bounds` (tight bounds of the outline). Do not use `controlBounds`. It
  includes off-curve points, and the values are too large.
- The axis name is `weight`, not `wght`. Fontra ignores an unknown key and
  gives the default location without an error.
- Use AGL glyph names (`zero`, `eight`). Malayalam glyphs use the `ml_` prefix
  (see `src/glyphnames.rs`).
- Check more than one weight (100, 400, 900). The masters can be different.
- Fontra caches glyphs in the page. A navigation that changes only the `#hash`
  does not reload the page. After a source change, call
  `fc.reloadGlyphs([...])` or reload the page.
- The Fontra server also caches glyphs. It uses a file watcher to see changes
  to the UFOs, and sometimes the watcher does not see a rebuild. Then the
  server gives the old outline, also after a page reload. Before you trust a
  result, compare the number of points: `(await fc.getGlyph(name))` has a
  layer per master; `layer.glyph.path.numPoints` must be equal to the number
  of `<point` elements in `sources/ufo/Cocolata-<Style>.ufo/glyphs/<name>.glif`.
  If they are different, ask the maintainer to restart Fontra.

Reference values at weight 400: the tops of the capitals `A` and `T` are at 735
(`0.95X` in MetaPost plus the stroke). Round shapes go a little above this
height (overshoot).

### Screenshots

Playwright can save files only in the repository. It writes them to
`.playwright-mcp/`. Do not commit this directory.
