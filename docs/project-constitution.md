# BookmarkPrimitive — Project Constitution

**Created:** 2026-04-16
**Authors:** Todd Cowing + Claude (Opus 4.7)

This document records the *why* behind foundational decisions. It is written for future collaborators — human and AI — who weren't in the room when these choices were made. The development plan tells you what we're building. AGENTS.md tells you how to build it. This document tells you why we made the decisions we made, and where we believe this is going.

Fill in the project-specific sections as decisions are made. The **Founding Principles** apply to every project in the portfolio without exception — they are the intent behind the work. The **Portfolio-Wide Decisions** are pre-filled conventional choices that follow from those principles; they apply unless explicitly overridden here with a documented reason.

---

## What BookmarkPrimitive Is Trying to Be

BookmarkPrimitive is a bookmark and cross-reference layer for document-style apps. It provides named anchors, a small `@MainActor` observable `BookmarkStore`, auto-generated-vs-manual bookmark regeneration, and cross-reference resolution for things like "page 3", "Section 2", or "above/below". It deliberately does not scroll the document, move the cursor, or own layout — host apps keep content IDs, pagination, and rendering; a host-supplied `BookmarkPositionResolver` is the only seam for page numbers and relative position. It is the right layer when your app already has a document model and needs stable, app-owned bookmark concepts on top.

---

## Foundational Decisions

### Shared Portfolio Doctrine

The shared founding principles and portfolio-wide defaults now live in the Foundation Libraries wiki:

- `/Users/todd/Library/CloudStorage/GoogleDrive-todd@cowingfamily.com/My Drive/The Commons/Libraries/Foundation Libraries/operations/portfolio-doctrine.md`

Use this local constitution for project-specific decisions, not copied portfolio boilerplate.

---

### Project-Specific Decisions

*Add an entry here for every significant architectural, tooling, or directional decision made for this project. Write it at decision time, not retroactively. Future collaborators need to understand the reasoning, not just the outcome.*

*Template for each entry:*

#### [Decision Title]

**Decision:** [One sentence stating what was decided.]

**Why:** [The reasoning. What alternatives were considered? What made this the right call for this project at this time? What would cause us to revisit it?]

**Trade-offs accepted:** [What are we giving up? What assumptions does this depend on?]

---

*Add more entries as decisions are made.*

---

## Tech Stack and Platform Choices

**Platform:** macOS 15+, iOS 17+
**Primary language:** Swift 6.0
**UI framework:** None — bookmark rendering, navigation, and sidebar UI live in the host app
**Data layer:** Codable value types; `@MainActor` observable `BookmarkStore`; host-provided `BookmarkPositionResolver` for page/relative-position data

**Why this stack:** Contentless — the package owns bookmark state, mutation, and resolution; the host owns document model, scrolling, and rendering. The `contentID` on `BookmarkAnchor` is the single bridge to the host's document model, keeping this primitive usable across wildly different editors.

---

## Who This Is Built For

*Who are the primary users or operators of this software? Humans, AI agents, or both? This shapes everything from UI density to conductorship defaults.*

[ ] Primarily humans
[ ] Primarily AI agents
[ ] Both, roughly equally
[ ] Both — humans build it, AIs operate it
[X] Both — AIs build it, humans operate it

**Notes:** A developer-facing primitive for editors and document tools. Host editors expose the human and AI-facing bookmark surfaces.

---

## Where This Is Going

[To be filled in as project direction crystallizes.]

---

## Open Questions

*None recorded yet.*

---

## Amendment Process

Use this process whenever a foundational decision changes or a new decision is added.

1. Update the relevant section in this constitution in the same change as the code/docs that motivated the update.
2. For each new or changed decision entry, include:
   - **Decision**
   - **Why**
   - **Trade-offs accepted**
   - **Revisit trigger** (what condition should cause reconsideration)
3. Add a matching row in the **Decision Log** with date and a concise summary.
4. If the amendment changes implementation rules, update `AGENTS.md` and any affected style guide files in the same change.
5. Record who approved the amendment (human + AI collaborator when applicable).

Minor wording clarifications that do not change meaning do not require a new decision entry, but should still be noted in the Decision Log.

---

## Decision Log

*Brief chronological record of significant decisions. Add an entry whenever a non-trivial decision is made that isn't already captured in the sections above.*

| Date | Decision | Decided by |
|------|----------|------------|
| 2026-04-16 | Constitution created and Founding Principles established | Both |
