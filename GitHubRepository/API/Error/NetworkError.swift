import Foundation

enum NetworkError: Error, Equatable {
  case invalidURL
  case emptyUser
  case decodingFailed
  case unknown(String)
}
