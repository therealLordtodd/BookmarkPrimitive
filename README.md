# BookmarkPrimitive

BookmarkPrimitive provides bookmark storage and cross-reference resolution for document editors.

## Quick Start

```swift
import BookmarkPrimitive

let bookmark = Bookmark(
    name: "Introduction",
    anchor: BookmarkAnchor(contentID: "intro-heading")
)

let store = BookmarkStore()
store.add(bookmark)

let reference = CrossReference(
    targetBookmarkID: bookmark.id,
    displayStyle: .title
)
let resolved = store.resolve(reference)
```

## Key Types
- `Bookmark`: Named anchor with optional metadata and auto-generated flag.
- `BookmarkAnchor`: Content ID plus optional offset.
- `BookmarkStore`: Observable store with add, remove, update, regenerate, lookup, and resolve APIs.
- `CrossReference`: A reference to a bookmark with title, page number, number-and-title, or above/below display.
- `BookmarkPositionResolver`: Host-provided page number and relative-position resolver.
- `ResolvedReference`: Display text plus validity flag.

## Common Operations
- Use `bookmark(named:)`, `bookmark(for:)`, or `bookmark(forContentID:)` for lookup.
- Use `regenerate(from:)` to rebuild generated heading/table bookmarks without touching manual bookmarks.
- Assign `positionResolver` before resolving page-number or above/below references.
- Register observers with `addObserver(_:)` when UI needs to react to bookmark changes.

## Testing

Run:

```bash
swift test
```
