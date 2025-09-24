import Foundation

// MARK: - Network Service Protocol
protocol NetworkServiceProtocol {
    func fetchProducts(page: Int, completion: @escaping (Result<ProductResponse, Error>) -> Void)
}

// MARK: - Network Service
class NetworkService: NetworkServiceProtocol {
    private let baseURL = "https://fakeapi.net/products"
    
    enum NetworkError: Error {
        case invalidURL
        case noData
        case decodingError
        case noInternetConnection
        
        var localizedDescription: String {
            switch self {
            case .invalidURL:
                return "Invalid URL"
            case .noData:
                return "No data received"
            case .decodingError:
                return "Failed to decode data"
            case .noInternetConnection:
                return "No internet connection"
            }
        }
    }
    
    func fetchProducts(page: Int, completion: @escaping (Result<ProductResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)?page=\(page)&limit=10&category=electronics") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                if (error as NSError).code == NSURLErrorNotConnectedToInternet {
                    completion(.failure(NetworkError.noInternetConnection))
                } else {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let productResponse = try JSONDecoder().decode(ProductResponse.self, from: data)
                completion(.success(productResponse))
            } catch {
                completion(.failure(NetworkError.decodingError))
            }
        }
        
        task.resume()
    }
}
