# Plan: Yaki-ire — RPG Effectiveness Assessment Game

> Source PRD: https://github.com/5till/mindblade/issues/1

## Architectural decisions

- **Deployment**: Single HTML file to GitHub Pages at `5till.github.io/mindblade`. No build step. No external dependencies except Google Fonts.
- **Rendering**: Canvas for the game world (tiles, sprites, animations, environmental effects). HTML/CSS overlays for dialogue boxes, results screen, and conversion CTAs.
- **State machine**: Central `GameStateMachine` owns all transitions. States: `TITLE → CHARACTER_CREATE → PLAYING → ENCOUNTER → ZONE_TRANSITION → SUMMIT → RESULTS → POST_RESULTS`.
- **Data**: All 28 encounter definitions, 7 zone tile maps, and rank descriptions live in a pure `ContentDatabase` constant — no logic, just data.
- **Scoring**: Pure function `ScoringEngine` — no DOM access, no side effects. Input: array of response score objects. Output: per-dimension ranks (1–7) + overall rank.
- **Persistence**: `PersistenceManager` is the only module that touches `localStorage`. Full game state serialized on every encounter completion and zone transition.
- **Email capture**: `FORMSPREE_URL` and `CALENDAR_URL` are the two top-of-file constants an operator needs to configure. Formspree POST carries: email, real name, character name, all 7 dimension raw scores + ranks, overall rank, all 28 response records.
- **Audio**: `AudioManager` hooks defined from the start but all no-ops until the Audio Pass (Phase 8).
- **Art**: Phase 1–7 use programmatic canvas art. Phase 9 replaces with base64-encoded PNG assets embedded in an `ASSETS` constant.
- **Tile size**: 32×32px. Target 60fps via `requestAnimationFrame`.
- **Dialogue box spatial language**: Top box = tutorial prompts, system notifications, narrator (breaks fourth wall). Bottom box = NPC dialogue, encounter responses (in-world). Durable rule — applies to all phases.
- **Movement**: Instant on key press — no input delay before first step.
- **Encounter navigation**: Arrow keys highlight options, Space/Enter confirms. Number key shortcuts removed.
- **Response revision**: Re-talking to a completed NPC reopens encounter. Old score delta subtracted, new applied. Encounter stays marked complete.
- **Origins**: 4 cosmetic choices — The Exile, The Seeker, The Witness, The Warrior. Each has a hover description and a distinct outfit visual. No effect on scoring.

---

## Phase 1: HTML Shell + Title Screen + Character Creation

**User stories**: 1, 2, 3, 36, 37, 38, 39, 40, 41
**GitHub issue**: https://github.com/5till/mindblade/issues/2

### What to build

The complete HTML file scaffold: canvas setup, 60fps game loop, and the `GameStateMachine` skeleton with all state constants defined. The Yaki-ire title screen renders with the game palette (background `#0a0a0f`, accent `#4aeadc`) — title, subheading describing the term, and a Press Start prompt.

Character creation flow: two unlabeled character sprites side by side for gender selection (click to pick), name text input, 4 origin choices (The Exile, The Seeker, The Witness, The Warrior) each with a hover description and distinct outfit visual, and an outfit color palette picker. A live sprite preview updates in real time as gender and origin are changed. Confirmation transitions to a placeholder game world screen.

Two placeholder constants at the top of the file: `FORMSPREE_URL` and `CALENDAR_URL`.

### Acceptance criteria

- [ ] Single HTML file opens in a modern browser with no console errors
- [ ] Google Fonts (Exo 2 + DM Sans) load correctly
- [ ] Title screen renders with correct palette
- [ ] "Yaki-ire" title and subheading visible
- [ ] Press Start / any key advances to character creation
- [ ] Two unlabeled sprites shown side by side; clicking one selects gender
- [ ] 4 origin options displayed; hovering shows a short description for each
- [ ] Each origin has a visually distinct outfit treatment on the sprite
- [ ] Name text input present
- [ ] Outfit color palette picker present
- [ ] Live sprite preview updates in real time when gender or origin changes
- [ ] Confirm button disabled until gender, origin, and name are all set
- [ ] Confirming transitions to placeholder canvas screen
- [ ] All 9 `GameStateMachine` states defined
- [ ] 60fps game loop running
- [ ] `FORMSPREE_URL` and `CALENDAR_URL` constants at top of file with placeholder values

---

## Phase 2: Player Movement + Zone 1 World

**User stories**: 4, 5, 6, 15, 16, 42, 43, 44, 45, 46, 47, 48, 49
**GitHub issue**: https://github.com/5till/mindblade/issues/3

### What to build

Zone 1 (The Crossroads) as a fully navigable outdoor tile grid (grass, sky, crossroads aesthetic). Player starts in an open area outside a tutorial room. A floating tutorial prompt appears at the top of the screen ("WASD / ↑↓←→ to move") and fades after the player's first step. A second prompt ("SPACE / ENTER to interact") appears when the player is first adjacent to an NPC and fades after first use. Both prompts use the top dialogue box and never reappear after dismissal.

Zone 1 has two rooms connected by a corridor: the tutorial room (one NPC trigger) and the main room (three NPC triggers). The corridor between them is initially blocked. After completing the tutorial room encounter, the route opens with a visible animation. Player sprite drawn programmatically with gender and origin outfit variants, 2-frame walk animation, direction-aware facing. Movement is instant on key press with no input delay. Outfit color applied as a hue transform over the base sprite.

### Acceptance criteria

- [ ] Zone 1 renders as an outdoor crossroads environment (grass/sky tile treatment)
- [ ] Player starts outside the tutorial room in open space
- [ ] Floating "move" tutorial prompt appears at top on game start, fades after first step
- [ ] Floating "interact" tutorial prompt appears at top when first adjacent to NPC, fades after first use
- [ ] Tutorial prompts never reappear after dismissal (persisted in save state)
- [ ] Tutorial room contains exactly 1 NPC trigger position
- [ ] Main room contains exactly 3 NPC trigger positions
- [ ] Corridor between rooms is impassable until tutorial encounter is completed
- [ ] Corridor opens with a visible animation after tutorial encounter completes
- [ ] Player sprite reflects gender and origin outfit variant from character creation
- [ ] Outfit color visually distinct across palette options
- [ ] Movement is instant on key press (no delay before first step)
- [ ] Walk animation toggles between 2 frames during movement
- [ ] Player faces the correct direction when moving
- [ ] Wall tiles block movement
- [ ] Visual indicator when player is adjacent to a trigger
- [ ] Input disabled when `GameStateMachine` is not in `PLAYING` state

---

## Phase 3: Encounter System + Scoring Engine + Content Database

**User stories**: 7, 8, 9, 10, 50, 51, 52, 53
**GitHub issue**: https://github.com/5till/mindblade/issues/4

### What to build

Three tightly coupled systems: the dialogue box UI and `EncounterController` (option randomization, player selection, NPC reaction), the pure-function `ScoringEngine` (accumulate, normalize, overallRank, maxPossibleScores), and the `ContentDatabase` (all 28 encounter definitions). Zone 1's 4 encounters wired to their trigger tiles as the end-to-end proof. Option order randomized once per session.

Encounter navigation: arrow keys highlight options (visual selection state), Space/Enter confirms. Number key shortcuts removed. NPC reactions support up to 3 lines of text; Space/Enter advances through each line, last press closes the box. No auto-close timer. Re-talking to a completed NPC reopens the encounter — old score delta is subtracted, new delta applied on re-selection.

If implementation becomes unwieldy, the data entry for encounters 5–28 can be a sub-step after the Zone 1 mechanics are proven.

### Acceptance criteria

- [ ] Bottom dialogue box renders with semi-transparent dark background
- [ ] NPC dialogue displays in 1–3 lines
- [ ] 4 response options display in randomized order with arrow key highlight state
- [ ] Arrow keys (up/down) cycle through options; selected option visually highlighted
- [ ] Space/Enter confirms selected option
- [ ] Number key shortcuts (1–4) removed
- [ ] Option order randomized once per session (stored for save/resume consistency)
- [ ] NPC reaction text supports up to 3 lines; Space/Enter advances through each
- [ ] No auto-close timer — reaction stays until player dismisses
- [ ] Score delta from selected option accumulated correctly
- [ ] Re-talking to a completed NPC reopens the encounter
- [ ] On re-selection: old score delta subtracted, new delta applied
- [ ] Input disabled during `ENCOUNTER` state (except encounter navigation keys)
- [ ] All 28 encounters in `ContentDatabase` with correct dialogue, options, and score objects
- [ ] `ScoringEngine.maxPossibleScores` constant correct for all 7 dimensions
- [ ] `ScoringEngine.normalize()` maps raw scores to ranks 1–7 correctly
- [ ] `ScoringEngine.overallRank()` returns rounded average, clamped to [1, 7]
- [ ] Zone 1 all 4 encounters completable
- [ ] Score state logged to console after each encounter (debug aid)

---

## Phase 4: All 7 Zones + Zone Transitions

**User stories**: 11, 12, 13, 14, 21
**GitHub issue**: https://github.com/5till/mindblade/issues/5

### What to build

Complete game world: tile maps for zones 2–7 plus all inter-zone corridors. Each zone has a distinct environmental effect — fog in Zone 2, darkness gradient with limited visibility radius in Zone 6, etc. Zone transitions use a canvas fade. All 28 encounters wired to their zones. Summit area with oracle NPC whose atmospheric dialogue triggers the `RESULTS` state (stubbed).

### Acceptance criteria

- [ ] All 7 zones navigable with correct tile layouts
- [ ] Zone corridors connect zones with short walkable paths
- [ ] Each zone has visually distinct color treatment and environmental effect
- [ ] Zone 2 has fog/obscured tile effect
- [ ] Zone 6 has darkness gradient with limited visibility radius
- [ ] Zone transition canvas fade plays between each zone
- [ ] All 28 encounters triggerable in their correct zones
- [ ] Full playthrough possible: title → character creation → zones 1–7 → summit
- [ ] Oracle NPC has atmospheric reveal dialogue
- [ ] Interacting with oracle transitions to `RESULTS` state (stub acceptable)
- [ ] Player cannot bypass oracle without interacting

---

## Phase 4b: Full Playthrough Review [HITL]

**GitHub issue**: https://github.com/5till/mindblade/issues/6

### What to do

Play through the complete game end-to-end before building the results and conversion screens. This is the gate between content and payoff. Problems caught here are far cheaper to fix than after Phases 5–7 are built.

**Review checklist:**
- Pacing — does any zone drag or feel rushed?
- Encounter ordering — do the 4 encounters per zone feel like a natural progression?
- Dialogue tone — atmospheric RPG, or quiz with pixel art on top?
- Zone distinctiveness — do all 7 zones feel meaningfully different?
- Option quality — do choices feel like genuine decisions?
- Sound moments — log notes to issue #10 (Audio Pass)
- Art priorities — log notes to issue #11 (Art Pass)

### Acceptance criteria

- [ ] Full playthrough completed (all 28 encounters, oracle reached)
- [ ] Any dialogue or option text needing revision updated
- [ ] Any zone layout issues resolved
- [ ] Sound moment notes added to #10
- [ ] Art priority notes added to #11
- [ ] Sign-off: game is ready for results and conversion screens

---

## Phase 5: Save / Resume

**User stories**: 18, 19
**GitHub issue**: https://github.com/5till/mindblade/issues/7

### What to build

`PersistenceManager` wrapping `localStorage`. Full game state serialized on every encounter completion and zone transition. Title screen detects existing save and shows "Continue" alongside "New Game." Option order randomization preserved across sessions. "New Game" clears save state before starting.

### Acceptance criteria

- [ ] State saves after every encounter completion and zone transition
- [ ] "Continue" option visible on title screen when save exists
- [ ] Resume restores correct zone, position, encounter progress, and accumulated scores
- [ ] Encounter option order identical after resume
- [ ] "New Game" clears all `localStorage` state
- [ ] `PersistenceManager` is the only module that accesses `localStorage`
- [ ] `load()` returns `null` (no errors) when no save exists

---

## Phase 6: Results Screen

**User stories**: 22, 23, 24, 25, 26
**GitHub issue**: https://github.com/5till/mindblade/issues/8

### What to build

Character sheet as an HTML/CSS overlay. Displays: character sprite (larger), fantasy name + overall level label, 7 dimension stat bars (rank number + label + one-sentence description), Primary Strength and Growth Edge callouts. Pixel art borders and decorative elements in game palette. Results fully visible before any email input is requested. Stub "Continue" button below results (wired to `POST_RESULTS` state).

### Acceptance criteria

- [ ] Results screen renders as HTML/CSS overlay (not canvas)
- [ ] Character sprite displayed larger than in-game size
- [ ] Fantasy name and overall level label displayed
- [ ] All 7 dimension bars with correct rank, label, and description from PRD spec
- [ ] Primary Strength and Growth Edge visually highlighted
- [ ] Styled with pixel art borders in game palette
- [ ] Full results visible with no email required
- [ ] "Continue" stub visible below results

---

## Phase 7: Post-Results Conversion Screen

**User stories**: 27, 28, 29, 30, 31, 32, 33, 34, 35
**GitHub issue**: https://github.com/5till/mindblade/issues/9

### What to build

Three post-results CTAs presented as natural player-motivated next steps:

1. **Save your character sheet** — real name + email form → Formspree POST with full payload (email, real name, character name, all 7 dimension raw scores + ranks, overall rank, all 28 response records). Success: confirmation message. Error: user-visible message with retry.
2. **Book a free call** — link to `CALENDAR_URL`, opens in new tab.
3. **Retake the quest** — clears `localStorage`, returns to title, re-randomizes option orders.

This completes the demo build. Full funnel is live.

### Acceptance criteria

- [ ] All three CTAs visible below character sheet
- [ ] Save form requires real name and email
- [ ] Formspree POST includes all required fields (see PRD §Data Flow)
- [ ] Formspree success shows confirmation; error shows retry message
- [ ] Book link opens `CALENDAR_URL` in new tab
- [ ] Retake clears state, returns to title, new session has fresh option order randomization
- [ ] No hardcoded URLs — only `FORMSPREE_URL` and `CALENDAR_URL` constants used

---

## Phase 8: Audio Pass [HITL — after demo playthrough]

**User stories**: 17
**GitHub issue**: https://github.com/5till/mindblade/issues/10

### What to build

Fill in the `AudioManager` hooks (all no-ops in phases 1–7) with actual Web Audio API sounds. Sound design decisions made during the Phase 4b review — notes logged to issue #10. Keep sounds subtle and atmospheric. Embed audio as base64 if files are needed (maintain single-file constraint).

**Hooks to implement**: `playStep()`, `playInteract()`, `playDialogue()`, `playZoneTransition()`, `playResultsReveal()`

### Acceptance criteria

- [ ] To be defined during Phase 4b playthrough review (add notes to issue #10)

---

## Phase 9: Art Pass [HITL — after demo playthrough]

**User stories**: 15 (full quality)
**GitHub issue**: https://github.com/5till/mindblade/issues/11

### What to build

Replace programmatic canvas art with real pixel art assets created in Aseprite + AI generation. Assets base64-encoded and embedded in an `ASSETS` constant at the top of the HTML. Renderer switches from programmatic drawing to `drawImage()` calls. Outfit color applied via canvas composite operation.

**Asset scope**: player sprites (2 genders × outfit color variants × 4 directions × 2 walk frames), NPC sprites, 7 zone tilesets, 7 zone backgrounds, UI elements (dialogue box borders, character sheet frame), title screen illustration.

**Priority order** (to be confirmed during Phase 4b review): Zone 6 and Zone 2 highest visual impact → player sprite → NPC sprites → remaining zones.

### Acceptance criteria

- [ ] To be defined during Phase 4b playthrough review (add notes to issue #11)
