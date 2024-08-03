import Combine
import Foundation

protocol GitHubServiceProtocol: AnyObject {
  var repositoriesPublisher: AnyPublisher<[Repository], NetworkError> { get }

  func fetchRepositories(for user: String)
}
