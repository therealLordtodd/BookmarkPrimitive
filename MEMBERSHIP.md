# BookmarkPrimitive — Cross-Family Membership

This primitive is a **cross-family contract**. It is declared in:

- [Document Editor family](../CONVENTIONS/document-editor-family-membership.md) — provides bookmark anchors, named destinations, auto-regeneration, cross-reference support for document-style apps
- [ReaderKit family](../CONVENTIONS/readerkit-family-membership.md) — annotation source of truth for bookmarks across all media types in reader sessions
- [TemporalMediaKit family](../CONVENTIONS/temporalmediakit-family-membership.md) — bookmarks for audio/video at timestamp anchors (audiobook chapter bookmarks, podcast episode bookmarks)

Public API changes follow the ripple checklist in **all three** families per the [Cross-Family Contracts Convention](../CONVENTIONS/cross-family-contracts-convention.md).

**Note:** BookmarkPrimitive is one of three primitives (with `CommentPrimitive` and `TrackChangesPrimitive`) that independently implement an **anchor pattern**. See [family-level convergence question](../RichTextEditorKit/docs/plans/2026-04-19-document-editor-dependency-audit.md#6-pending-coordinated-changes).

## Conventions This Primitive Participates In

- [x] [shared-types](../CONVENTIONS/shared-types-convention.md) — defines own anchor model (parallel to Comment/TrackChanges)
- [x] [cross-family-contracts](../CONVENTIONS/cross-family-contracts-convention.md)
- [x] [document-editor-family-membership](../CONVENTIONS/document-editor-family-membership.md)
- [x] [readerkit-family-membership](../CONVENTIONS/readerkit-family-membership.md)
- [x] [temporalmediakit-family-membership](../CONVENTIONS/temporalmediakit-family-membership.md)

## Cross-Family Role Notes

- **In Document Editor family**: bookmarks are named destinations within a `DocumentPrimitive` document; consumed by `RichTextEditorKit` for cross-reference rendering and document navigation.
- **In ReaderKit family**: bookmarks are user-saved positions within a reader session, persisted as the canonical annotation record regardless of which renderer (PDF, EPUB, Markdown, etc.) produced the anchor.
- **In TemporalMediaKit family**: bookmarks anchor to timestamps within an `AudioTrack`. The same `BookmarkAnchor` shape works across text-range anchors (text content) and timestamp anchors (time-based content); the `subjectID` field distinguishes the medium.

## Shared Types This Primitive Defines

- Bookmark anchors + named destinations + auto-regeneration semantics
- Cross-reference resolution
- `BookmarkStore` mutation surface with observable `BookmarkMutation` events
- Consumed by: `DocumentPrimitive`, `RichTextEditorKit`, ReaderKit hosts, TemporalMediaKit hosts

## Shared Types This Primitive Imports

- (none from any family — Foundation only)

## Siblings That Hard-Depend on This Primitive

In Document Editor family:
- `DocumentPrimitive` — composes bookmarks into the document
- `RichTextEditorKit` — re-exports bookmark surface

In ReaderKit family:
- ReaderKit hosts — persistent bookmark records across reader sessions

In TemporalMediaKit family:
- `AudiobookKit`, `PodcastKit` — timestamp-anchored bookmarks

Cross-family: `MediaAsset.id` from `MediaPrimitive` may be referenced as a bookmark `subjectID` for media-anchored bookmarks.

## Ripple-Analysis Checklist Before Modifying Public API

1. **Anchor model changes**: also consider whether the change should unify with `CommentPrimitive`'s and `TrackChangesPrimitive`'s anchor models (Document Editor family convergence question — §6 of dep audit).
2. **Run the [Document Editor ripple checklist](../CONVENTIONS/document-editor-family-membership.md)** — affects DocumentPrimitive composition + RichTextEditorKit re-exports.
3. **Run the [ReaderKit ripple checklist](../CONVENTIONS/readerkit-family-membership.md#readerkit-specific-ripple-checklist)** — affects every ReaderKit host that persists bookmark annotations.
4. **Run the [TemporalMediaKit ripple checklist](../CONVENTIONS/temporalmediakit-family-membership.md#temporalmediakit-specific-ripple-checklist)** — affects AudiobookKit and PodcastKit timestamp-anchored bookmarks.
5. **Mutation event changes** (`BookmarkMutation`) affect every observer.
6. Auto-regeneration behavior is a subtle semantic; document explicitly when changing.
7. Consult [Document Editor dependency audit](../RichTextEditorKit/docs/plans/2026-04-19-document-editor-dependency-audit.md).
8. Document the union of family impacts in the commit/PR body.

## Scope of Membership

Applies to modifications of BookmarkPrimitive's own code. Consumers just importing for their own app are unaffected.
