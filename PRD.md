# PRD: Yaki-ire — RPG Effectiveness Assessment Game

> Source: https://github.com/5till/mindblade/issues/1

## Problem Statement

Self-reflective adults who sense they have untapped potential struggle to identify what's actually holding them back. They've tried self-help content, productivity systems, and therapy — with temporary results that don't stick. They're skeptical of coaching claims but still searching. Traditional assessments and quizzes feel like forms; this audience distrusts extraction-based lead-gen (email gates before value delivery). They need an experience that earns their engagement before asking anything in return, and that delivers genuine insight rather than flattery.

The coach needs a lead-gen asset that attracts this specific audience, qualifies them through deep engagement, captures their email alongside rich behavioral data, and opens a warm conversation.

## Solution

A single-file HTML/CSS/JS game titled **Yaki-ire** — named after the Japanese sword-hardening process where the blade is heated, quenched, and its true character revealed. The subheading on the title screen describes the term, setting the metaphor without explaining it.

The game is a top-down 8-bit RPG where the player navigates a grid-based world, encounters NPCs and situations, and makes choices that feel like gameplay decisions. A scoring system runs invisibly, tracking 7 dimensions of personal effectiveness across 28 encounters in 7 zones. At the end, the player receives a full character stat sheet — their real assessment results — before any email is requested. The reveal moment ("this game was reading me the whole time") earns the conversion.

The game is self-contained, deploys to GitHub Pages at `5till.github.io/mindblade`, and requires no backend. A separate landing page at the same URL sells the experience; the game delivers it.

## User Stories

### Player Experience

1. As a player, I want to land on a cinematic title screen with atmospheric pixel art and a "Press Start" prompt, so that I'm immediately drawn into the game world before any explanation.
2. As a player, I want to see the title "Yaki-ire" with a brief subheading that describes the term, so that I understand the metaphor without being lectured at.
3. As a player, I want to choose my character's gender, enter a character name, and select an outfit color before the game begins, so that I feel ownership over my avatar.
4. As a player, I want to navigate a grid-based world using arrow keys or WASD, so that movement feels like a real game.
5. As a player, I want my character to have a walk animation when moving, so that the game has visual life.
6. As a player, I want to interact with NPCs and objects by walking into them or pressing Space/Enter when adjacent, so that exploration feels natural.
7. As a player, I want dialogue to appear in a classic RPG dialogue box at the bottom of the screen, so that the presentation matches the genre.
8. As a player, I want each encounter to present a situation in 1-3 lines of evocative RPG dialogue, so that the scenario feels like gameplay, not a quiz.
9. As a player, I want 4 response options per encounter with their order randomized each session, so that no "correct" position pattern emerges.
10. As a player, I want a brief NPC reaction after my choice before the encounter resolves, so that my decision feels acknowledged.
11. As a player, I want to travel through 7 distinct zones with different visual palettes and themes, so that the world feels varied and the journey has progression.
12. As a player, I want short walkable corridors between zones, so that transitions feel earned rather than abrupt.
13. As a player, I want zone transitions to use a fade effect, so that moving between areas feels cinematic.
14. As a player, I want each zone to have a distinct environmental character (fog, tower, cave, arena, etc.) that matches its theme, so that the world feels intentional.
15. As a player, I want simple but deliberate pixel art with a GBA-quality aesthetic, so that the game looks polished rather than placeholder.
16. As a player, I want the color palette to stay consistent — dark background (#0a0a0f), cyan accent (#4aeadc), light text (#e0e8ef) — so that the visual identity is coherent throughout.
17. As a player, I want sound effects for footsteps, dialogue, and interactions (deferred to post-demo), so that the game has audio presence.
18. As a player, I want my progress saved automatically to localStorage, so that if I close the tab and return, I resume exactly where I left off.
19. As a player, I want a visual indicator that my save exists when I return to the title screen, so that I know I can continue.
20. As a player, I want to reach a final summit/sanctuary area after zone 7, so that the journey has a clear and satisfying ending.
21. As a player, I want an oracle NPC at the summit to acknowledge my journey in atmospheric language before the results appear, so that the reveal feels earned.
22. As a player, I want to see my full character stat sheet — all 7 dimension ranks, labels, and descriptions — before I'm asked for anything, so that the value is delivered first.
23. As a player, I want my character sheet to display my character's fantasy name and overall level (e.g., "The Wanderer — Level 5, Practicing"), so that the results feel personal.
24. As a player, I want my highest-ranked dimension highlighted as "Primary Strength" and my lowest highlighted as "Growth Edge", so that the most coaching-relevant data is immediately visible.
25. As a player, I want to see dimension stat bars with rank numbers and descriptive labels, so that I can understand my results at a glance.
26. As a player, I want the results screen styled as a classic RPG character sheet with pixel art borders and decorative elements, so that the presentation feels like a payoff rather than a report.
27. As a player, I want three clear next-step options below my results — save, book, or replay — so that I can choose my own level of engagement.
28. As a player, I want a "Save your character sheet" option that lets me enter my real name and email to receive my results, so that I have a personal reason to share my contact information.
29. As a player, I want a "Book a free call" option that links to a calendar booking page, so that I can take a high-commitment next step if I'm ready.
30. As a player, I want a "Retake the quest" option that clears my save and restarts the game, so that I can explore a different path without feeling trapped.
31. As a player, I want encounter option orders re-randomized on retake, so that a second playthrough feels genuinely different.

### Coach / Operator Experience

32. As a coach, I want to receive an email via Formspree for every player who saves their character sheet, so that I have a record of every qualified lead.
33. As a coach, I want the Formspree payload to include the player's real name, email, character name, all 7 dimension raw scores and ranks, and the specific option selected for every encounter, so that I have complete behavioral context for follow-up.
34. As a coach, I want to be able to reference the player's character name in follow-up ("I see you played as The Wanderer"), so that the first call opens warmly.
35. As a coach, I want the Formspree endpoint URL and calendar booking URL stored as single constants at the top of the HTML file, so that I can update them in under 30 seconds.
36. As a coach, I want the game to deploy as a single HTML file to GitHub Pages with no build step, so that updates are trivial.
37. As a coach, I want the landing page and game file to be separate, so that the landing page can be updated independently with copywriting, social proof, and conversion optimization.

## Implementation Decisions

### Architecture

- **Single HTML file** with inline CSS and JS. No build tools, no bundler, no external dependencies except Google Fonts (Exo 2 + DM Sans loaded via `<link>`).
- **Canvas-based rendering** for the game world (tiles, sprites, NPCs, animations). HTML/CSS overlays for dialogue boxes, the results screen, and the post-results CTAs.
- **60fps game loop** via `requestAnimationFrame`.
- **Tile size**: 32×32px.
- **Two placeholder constants** at the top of the file: `FORMSPREE_URL` and `CALENDAR_URL`.

### Modules

**GameStateMachine** — Central state manager. States: `TITLE`, `CHARACTER_CREATE`, `PLAYING`, `ENCOUNTER`, `ZONE_TRANSITION`, `SUMMIT`, `RESULTS`, `POST_RESULTS`.

**Renderer** — Owns the canvas context. Draws tile grids, player sprite, NPC sprites, zone backgrounds, environmental effects, walk animations. Programmatic art in demo; base64 PNG assets in art pass.

**InputController** — Listens to keydown/keyup. Maps Arrow/WASD to movement, Space/Enter to interact. Disabled during ENCOUNTER and RESULTS states.

**WorldMap** — One 2D tile array per zone. Tile values: passable, wall, NPC trigger, object trigger, zone-exit. Exposes `isPassable(x,y)`, `getTrigger(x,y)`, `getNPC(x,y)`.

**PlayerEntity** — Stores grid position, facing direction, character name, gender, outfit color, walk animation frame, current zone index.

**EncounterController** — Loads encounter from ContentDatabase. Randomizes option order. Returns `{scoreDelta, reactionText}` on selection.

**ScoringEngine** — Pure function. `accumulate(responses[])`, `normalize(rawScores, maxScores)`, `overallRank(ranks)`. No DOM access, no side effects.

**PersistenceManager** — Wraps localStorage. `save(state)`, `load() → state | null`, `clear()`. Only module that touches localStorage.

**ContentDatabase** — Pure data. 28 encounter definitions, 7 zone tile arrays, rank label/description tables, zone metadata.

**ResultsRenderer** — HTML/CSS overlay. Character sheet with dimension bars, rank labels, descriptions, Primary Strength + Growth Edge callouts.

**ConversionScreen** — Three CTAs: Save (Formspree POST), Book (CALENDAR_URL), Retake (clear + restart).

**AudioManager** — Web Audio API hooks. All no-ops in demo build.

### Scoring System

- Each option carries a score object mapping 1-3 dimensions to values 1-4.
- `maxPossibleScores`: sum of max possible score per dimension across all encounters.
- Final rank: `round((rawScore / maxPossibleScore) * 6) + 1`, clamped to [1,7].
- Overall rank: `round(average of all 7 dimension ranks)`, clamped to [1,7].
- Option order randomized once per session, stored in PersistenceManager.

### Rank Descriptions

**Agency:** 1→7: Experiencing life as happening to you → Designing responses and authoring path with full ownership.
**Clarity:** 1→7: Events and feelings fused in perception → Seeing situations exactly as they are, undistorted.
**Discernment:** 1→7: Reacting to surface events, frequently surprised → Seeing multiple layers deep, anticipating what others miss.
**Validation:** 1→7: Cannot proceed without external confirmation → Own authority, acting from internal criteria.
**Value:** 1→7: Worth depends entirely on others' reactions → Worth self-evident; praise and criticism are information, not identity.
**Security:** 1→7: Uncertainty paralyzes → Moving fluidly in the unknown, secure in own adaptability.
**Power:** 1→7: Energy goes to controlling others, conflict constant → Full command of own responses, presence creates productive environments.

(Full 42 descriptions — all ranks 1-7 for all 7 dimensions — are in the plan file: ./plans/yaki-ire.md)

### Data Flow

1. Player choice → `EncounterController.selectOption(index)` → score delta
2. `ScoringEngine.accumulate()` updates running totals
3. `PersistenceManager.save()` persists state
4. After 28 encounters → `ScoringEngine.normalize()` + `overallRank()` → results object
5. `ResultsRenderer` displays results
6. Save form submit → Formspree POST with full payload

## Out of Scope

- Mobile/touch support (deferred)
- Backend or database
- CRM integration
- Analytics, A/B testing, admin dashboard
- Multiplayer, accessibility, i18n
- External sprite files
