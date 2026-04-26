import Vapor

struct Response<T: ResourceRepresentable>: Content {
    let data: T
}

struct PageResponse<T: ResourceRepresentable>: Content {
    let data: [T]
}
