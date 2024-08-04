import Combine
import Foundation

enum ReposViewModelError: Error, Equatable {
  case repositoriesFetch(NetworkError)
}

enum ReposViewModelState: Equatable {
  case loading
  case finishedLoading
  case error(ReposViewModelError)
}

@MainActor
final class ReposViewModel: ObservableObject {
  enum Section { case repositories }
  
  private let reposService: GitHubServiceProtocol
  private var subscriptions = Set<AnyCancellable>()
  
  @Published private(set) var repositories: [Repository] = []
  @Published private(set) var state: ReposViewModelState = .loading
  @Published private(set) var userName: String = "Apple" // Default user name
  
  init(reposService: GitHubServiceProtocol) {
    self.reposService = reposService
    setupSubscription()
    fetchRepositories(for: userName)
  }
  
  func fetchRepositories(for user: String) {
    userName = user
    state = .loading
    reposService.fetchRepositories(for: user)
  }
}

private extension ReposViewModel {

  func setupSubscription() {
    reposService.repositoriesPublisher
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { [weak self] completion in
        switch completion {
        case .failure(let error):
          self?.state = .error(.repositoriesFetch(error))
        case .finished:
          self?.state = .finishedLoading
        }
      }, receiveValue: { [weak self] repos in
        self?.state = .finishedLoading
        self?.repositories = repos
      })
      .store(in: &subscriptions)
  }
}
