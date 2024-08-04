import Foundation

enum NetworkError: Error, Equatable {
  case invalidURL
  case emptyUser
  case decodingFailed
  case unknown(String)
  
  var description: String {
    switch self {
    case .invalidURL:
      return "The URL is invalid. Please try again later."
    case .emptyUser:
      return "The user name is empty. Please provide a valid user name."
    case .decodingFailed:
      return "Failed to decode the response from the server. Please try again."
    case .unknown(let error):
      return "An unknown error occurred: \(error). Please try again."
    }
  }
}
