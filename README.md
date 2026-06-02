# BookmarkPrimitive
**Primitive** · [GitHub](https://github.com/therealLordtodd/BookmarkPrimitive)

> [!NOTE]
> **TL;DR** — A bookmark and cross-reference layer for document-style apps: named anchors, an observable store, auto-regeneration, and reference resolution for things like "page 3" or "above / below". Reach for it when your app already has a document model and needs stable, app-owned bookmark concepts on top.

## Overview

`BookmarkPrimitive` gives a document-style app named anchors, a small observable store, auto-generated bookmark regeneration, and cross-reference resolution for references like "page 3", "Section 2", or "above / below".

Use it when your app already has a document model and needs stable, app-owned bookmark concepts on top. Don't use it as a document engine, layout engine, or navigation system by itself — this package tracks bookmarks; your host app still owns content IDs, scrolling, pagination, and rendering.

**What it gives you:**

- `Bookmark` and `BookmarkAnchor` for named document anchors
- `BookmarkStore` as the main `@MainActor` observable store
- `CrossReference` and `ResolvedReference` for rendering references to bookmarks
- `BookmarkPositionResolver` so the host app can provide page numbers and relative position
- mutation callbacks for bookmark UIs and editor side effects

**Reach for it when:**

- You have headings, sections, figures, or named anchors in a document
- You want manual bookmarks plus auto-generated bookmarks
- You want cross-references that can display title, number, page, or relative position
- You want bookmark state owned by the app instead of buried inside editor UI

**Skip it when:**

- You want the package to scroll the document or move the cursor for you
- You do not have stable content IDs in your document model
- You need a full outline/navigation framework with persistence, syncing, and layout all bundled together

## 🚀 Quick start

```swift
import BookmarkPrimitive

let store = BookmarkStore()

let intro = Bookmark(
    name: "Introduction",
    anchor: BookmarkAnchor(contentID: "heading-1")
)

store.add(intro)

let resolved = store.resolve(
    CrossReference(targetBookmarkID: intro.id, displayStyle: .title)
)

print(resolved.displayText)
```

## 🔌 Wiring it in

### 1. Add the dependency

```swift
dependencies: [
    .package(path: "../BookmarkPrimitive"),
]
targets: [
    .target(
        name: "MyEditor",
        dependencies: ["BookmarkPrimitive"]
    )
]
```

### 2. Treat `contentID` as your stable bridge to the document model

That is the core integration seam. If your editor cannot give a heading, figure, or block a stable ID, bookmark behavior will always be fragile.

### 3. Keep layout knowledge outside the package

`BookmarkPrimitive` should not know how your pages, columns, or block positions are computed. Put that in a host-app `BookmarkPositionResolver`.

### 4. Use auto-generated bookmarks for structure, manual bookmarks for intent

Let headings and outlines rebuild automatically, while preserving user-created bookmarks across document changes.

### 5. Keep bookmark rendering and navigation in the host app

The package resolves display text. Your app should still decide how to scroll to a bookmark, highlight it, or present it in a sidebar.

### 6. Persist bookmarks in your app's document model or store

The package's model types are `Codable`, but there is no opinionated persistence system here. That keeps ownership with the app.

## ⚠️ Caveats

- `BookmarkStore` is `@MainActor`.
- `pageNumber` and `aboveBelow` display styles depend on a host-provided `BookmarkPositionResolver`.
- Without a resolver, those styles fall back to the bookmark name.
- This package does not own navigation, rendering, or layout.

## Examples

### Add, update, and remove manual bookmarks

```swift
let store = BookmarkStore()

let bookmark = Bookmark(
    name: "Methods",
    anchor: BookmarkAnchor(contentID: "section-methods")
)

store.add(bookmark)
store.update(bookmark.id, name: "Methods and Setup")
store.remove(bookmark.id)
```

### Rebuild auto-generated bookmarks from document structure

```swift
store.regenerate(from: [
    (name: "Chapter 1", contentID: "h1-1", metadata: ["number": "1"]),
    (name: "Chapter 2", contentID: "h1-2", metadata: ["number": "2"])
])

let auto = store.autoBookmarks
let manual = store.manualBookmarks
```

`regenerate(from:)` only replaces auto-generated bookmarks. Manual bookmarks stay intact.

### Resolve a title or numbered cross-reference

```swift
let ref = CrossReference(
    targetBookmarkID: bookmark.id,
    displayStyle: .numberAndTitle
)

let resolved = store.resolve(ref)
print(resolved.displayText)
```

If the bookmark metadata contains `"number"`, the display can become something like `2 Methods`.

### Add page numbers or "above / below" with a resolver

```swift
struct LayoutResolver: BookmarkPositionResolver {
    func pageNumber(for anchor: BookmarkAnchor) -> Int? {
        // Bridge to your layout engine
        3
    }

    func isAbove(anchor: BookmarkAnchor, relativeTo currentAnchor: BookmarkAnchor) -> Bool {
        // Compare positions in your document model
        true
    }
}

store.positionResolver = LayoutResolver()

let pageRef = CrossReference(
    targetBookmarkID: bookmark.id,
    displayStyle: .pageNumber
)

let relativeRef = CrossReference(
    targetBookmarkID: bookmark.id,
    displayStyle: .aboveBelow
)

print(store.resolve(pageRef).displayText)
print(store.resolve(relativeRef, from: BookmarkAnchor(contentID: "current-block")).displayText)
```

### Observe mutations for UI refresh or side effects

```swift
let observerID = store.addObserver { mutation in
    switch mutation {
    case .added(let id):
        print("Added \(id)")
    case .updated(let id):
        print("Updated \(id)")
    case .removed(let id):
        print("Removed \(id)")
    case .regenerated:
        print("Bookmarks regenerated")
    }
}

store.removeObserver(observerID)
```

## 📋 Reference

### Public surface

| Type | Why it matters |
|---|---|
| `Bookmark` | Named document anchor with metadata. |
| `BookmarkAnchor` | Wraps a host-provided `contentID` — the stable bridge to your document model. |
| `BookmarkStore` | The main `@MainActor` observable store. Owns add/update/remove, regeneration, resolution, and observers. |
| `CrossReference` | A reference to a bookmark plus a `displayStyle`. |
| `ResolvedReference` | The resolved result carrying `displayText`. |
| `BookmarkPositionResolver` | Host-provided seam for page numbers and relative position. |

### Display styles

| Style | Renders |
|---|---|
| `.title` | The bookmark title. |
| `.numberAndTitle` | Number + title (e.g. `2 Methods`) when metadata contains `"number"`. |
| `.pageNumber` | Page number from the host `BookmarkPositionResolver`. |
| `.aboveBelow` | Relative position ("above" / "below") from the host resolver. |

### Platforms

| Platform | Minimum |
|---|---|
| macOS | 15.0 |
| iOS | 17.0 |
