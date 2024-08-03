import Foundation

class GitHubService: GitHubServiceProtocol {

  private let session: URLSession
  private let baseURL: String

  init(session: URLSession = .shared, baseURL: String = "https://api.github.com/users") {
    self.session = session
    self.baseURL = baseURL
  }

  func fetchRepositories(for user: String) async throws -> [Repository] {
    guard !user.isEmpty else {
      throw NetworkError.emptyUser
    }

    guard let url = URL(string: "\(baseURL)/\(user)/repos"), url.host != nil else {
      throw NetworkError.invalidURL
    }

    let (data, _) = try await session.data(from: url)
    do {
      let repositories = try JSONDecoder().decode([Repository].self, from: data)
      return repositories
    } catch {
      throw NetworkError.decodingFailed
    }
  }
}
