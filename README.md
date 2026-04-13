# BookmarkPrimitive

`BookmarkPrimitive` is a bookmark and cross-reference layer for document-style apps.

It gives you named anchors, a small observable store, auto-generated bookmark regeneration, and cross-reference resolution for things like “page 3”, “Section 2”, or “above / below”.

Use it when your app already has a document model and needs stable, app-owned bookmark concepts on top.

Do not use it as a document engine, layout engine, or navigation system by itself. This package tracks bookmarks; your host app still owns content IDs, scrolling, pagination, and rendering.

## What The Package Gives You

- `Bookmark` and `BookmarkAnchor` for named document anchors
- `BookmarkStore` as the main `@MainActor` observable store
- `CrossReference` and `ResolvedReference` for rendering references to bookmarks
- `BookmarkPositionResolver` so the host app can provide page numbers and relative position
- mutation callbacks for bookmark UIs and editor side effects

## When To Use It

- You have headings, sections, figures, or named anchors in a document
- You want manual bookmarks plus auto-generated bookmarks
- You want cross-references that can display title, number, page, or relative position
- You want bookmark state owned by the app instead of buried inside editor UI

## When Not To Use It

- You want the package to scroll the document or move the cursor for you
- You do not have stable content IDs in your document model
- You need a full outline/navigation framework with persistence, syncing, and layout all bundled together

## Install

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

## Quick Start

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

## Concrete Examples

### 1. Add, update, and remove manual bookmarks

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

### 2. Rebuild auto-generated bookmarks from document structure

```swift
store.regenerate(from: [
    (name: "Chapter 1", contentID: "h1-1", metadata: ["number": "1"]),
    (name: "Chapter 2", contentID: "h1-2", metadata: ["number": "2"])
])

let auto = store.autoBookmarks
let manual = store.manualBookmarks
```

`regenerate(from:)` only replaces auto-generated bookmarks. Manual bookmarks stay intact.

### 3. Resolve a title or numbered cross-reference

```swift
let ref = CrossReference(
    targetBookmarkID: bookmark.id,
    displayStyle: .numberAndTitle
)

let resolved = store.resolve(ref)
print(resolved.displayText)
```

If the bookmark metadata contains `"number"`, the display can become something like `2 Methods`.

### 4. Add page numbers or “above / below” with a resolver

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

### 5. Observe mutations for UI refresh or side effects

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

## How To Wire It Into A Host App

### 1. Treat `contentID` as your stable bridge to the document model

That is the core integration seam. If your editor cannot give a heading, figure, or block a stable ID, bookmark behavior will always be fragile.

### 2. Keep layout knowledge outside the package

`BookmarkPrimitive` should not know how your pages, columns, or block positions are computed. Put that in a host-app `BookmarkPositionResolver`.

### 3. Use auto-generated bookmarks for structure, manual bookmarks for intent

That split is one of the best parts of the package. Let headings and outlines rebuild automatically, while preserving user-created bookmarks across document changes.

### 4. Keep bookmark rendering and navigation in the host app

The package resolves display text. Your app should still decide how to scroll to a bookmark, highlight it, or present it in a sidebar.

### 5. Persist bookmarks in your app’s document model or store

The package’s model types are `Codable`, but there is no opinionated persistence system here. That is a good thing. It keeps ownership with the app.

## Important Constraints

- `BookmarkStore` is `@MainActor`
- `pageNumber` and `aboveBelow` display styles depend on a host-provided `BookmarkPositionResolver`
- Without a resolver, those styles fall back to the bookmark name
- This package does not own navigation, rendering, or layout

## Platform Support

| Platform | Minimum Version |
|----------|----------------|
| macOS | 15.0 |
| iOS | 17.0 |
