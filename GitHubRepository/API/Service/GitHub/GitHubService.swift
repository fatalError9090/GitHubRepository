import Combine
import Foundation

final class GitHubService: GitHubServiceProtocol {
  
  private let session: URLSession
  private let baseURL: String
  private let _repositoriesPublisher = PassthroughSubject<[Repository], NetworkError>()
  private var subscriptions = Set<AnyCancellable>()
  
  var repositoriesPublisher: AnyPublisher<[Repository], NetworkError> {
    _repositoriesPublisher.eraseToAnyPublisher()
  }
  
  init(session: URLSession = .shared, baseURL: String = "https://api.github.com/users") {
    self.session = session
    self.baseURL = baseURL
  }
  
  func fetchRepositories(for user: String) {
    guard !user.isEmpty else {
      _repositoriesPublisher.send(completion: .failure(.emptyUser))
      return
    }
    
    guard let url = URL(string: "\(baseURL)/\(user)/repos"), url.host != nil else {
      _repositoriesPublisher.send(completion: .failure(.invalidURL))
      return
    }
    
    session.dataTaskPublisher(for: url)
      .map(\.data)
      .decode(type: [Repository].self, decoder: JSONDecoder())
      .mapError { error in
        if let _ = error as? DecodingError {
          return NetworkError.decodingFailed
        }
        return NetworkError.unknown(error.localizedDescription)
      }
      .sink(receiveCompletion: { completion in
        if case let .failure(error) = completion {
          self._repositoriesPublisher.send(completion: .failure(error))
        }
      }, receiveValue: { repositories in
        self._repositoriesPublisher.send(repositories)
      })
      .store(in: &subscriptions)
  }
}
