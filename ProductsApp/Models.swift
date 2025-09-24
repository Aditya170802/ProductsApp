import Foundation

// MARK: - Models
struct ProductResponse: Codable {
    let data: [Product]
    let pagination: Pagination
}

struct Product: Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let brand: String
    let stock: Int
    let image: String
    let specs: ProductSpecs
    let rating: ProductRating
}


struct ProductSpecs: Codable {
    let color: String?
    let weight: String?
    let storage: String?
    let battery: String?
    let waterproof: Bool?
    let screen: String?
    let ram: String?
    let capacity: String?
    let output: String?
    let connection: String?
}

struct ProductRating: Codable {
    let rate: Double
    let count: Int
}

struct Pagination: Codable {
    let page: Int
    let limit: Int
    let total: Int
}
