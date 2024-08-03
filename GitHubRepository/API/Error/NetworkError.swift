import Foundation

enum NetworkError: Error {
  case invalidURL
  case emptyUser
  case decodingFailed
}
