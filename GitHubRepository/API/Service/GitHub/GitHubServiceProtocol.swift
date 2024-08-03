import Foundation

protocol GitHubServiceProtocol {
  func fetchRepositories(for user: String) async throws -> [Repository]
}
