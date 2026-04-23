# BookmarkPrimitive — Document Editor Family Membership

This primitive is a member of the Document Editor primitive family. It provides bookmark anchors, named destinations, auto-regeneration, and cross-reference support for document-style apps.

**Note:** BookmarkPrimitive is one of three primitives (with CommentPrimitive and TrackChangesPrimitive) that independently implement an **anchor pattern**. See [family-level convergence question](../RichTextEditorKit/docs/plans/2026-04-19-document-editor-dependency-audit.md#6-pending-coordinated-changes).

## Conventions This Primitive Participates In

- [x] [shared-types](../CONVENTIONS/shared-types-convention.md) — defines own anchor model (parallel to Comment/TrackChanges)
- [ ] [typed-static-constants](../CONVENTIONS/typed-static-constants-convention.md) — not participating
- [x] [document-editor-family-membership](../CONVENTIONS/document-editor-family-membership.md)

## Shared Types This Primitive Defines

- Bookmark anchors + named destinations + auto-regeneration semantics
- Cross-reference resolution
- Consumed by: `DocumentPrimitive`, `RichTextEditorKit`, hosts

## Shared Types This Primitive Imports

- (none from the family — Foundation only)

## Siblings That Hard-Depend on This Primitive

- `DocumentPrimitive` — composes bookmarks into the document
- `RichTextEditorKit` — re-exports bookmark surface

## Ripple-Analysis Checklist Before Modifying Public API

1. **Anchor model changes**: also consider whether the change should unify with CommentPrimitive's and TrackChangesPrimitive's anchor models (family convergence question — §6 of dep audit).
2. Changes to named-destination resolution: affects cross-references in DocumentPrimitive; hosts depending on stable destinations may see regression.
3. Auto-regeneration behavior: subtle semantic change; document explicitly.
4. Consult [dependency audit](../RichTextEditorKit/docs/plans/2026-04-19-document-editor-dependency-audit.md).
5. Document ripple impact in the commit/PR.

## Scope of Membership

Applies to modifications of BookmarkPrimitive's own code. Consumers just importing for their own app are unaffected.
