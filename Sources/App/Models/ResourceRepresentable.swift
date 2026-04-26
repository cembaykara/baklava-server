import Vapor

/// Marker protocol for API resource payloads.
protocol ResourceRepresentable: Content {
    var id: UUID { get }
    var createdAt: Date? { get }
    var updatedAt: Date? { get }
}
