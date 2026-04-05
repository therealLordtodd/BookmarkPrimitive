import Foundation

public enum CrossReferenceStyle: String, Codable, Sendable {
    case pageNumber
    case title
    case numberAndTitle
    case aboveBelow
}

public struct CrossReference: Codable, Sendable, Equatable {
    public var targetBookmarkID: BookmarkID
    public var displayStyle: CrossReferenceStyle

    public init(
        targetBookmarkID: BookmarkID,
        displayStyle: CrossReferenceStyle = .title
    ) {
        self.targetBookmarkID = targetBookmarkID
        self.displayStyle = displayStyle
    }
}

public struct ResolvedReference: Sendable, Equatable {
    public var bookmarkName: String
    public var displayText: String
    public var isValid: Bool

    public init(bookmarkName: String, displayText: String, isValid: Bool) {
        self.bookmarkName = bookmarkName
        self.displayText = displayText
        self.isValid = isValid
    }
}
