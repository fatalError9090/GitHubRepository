import XCTest
import Combine
@testable import GitHubRepository

@MainActor
final class ReposViewModelTests: XCTestCase {
  
  private var viewModel: ReposViewModel!
  private var reposService: MockGitHubService!
  private var subscriptions = Set<AnyCancellable>()
  
  override func setUp() {
    super.setUp()
    reposService = MockGitHubService()
    viewModel = ReposViewModel(reposService: reposService)
  }
  
  override func tearDown() {
    subscriptions = []
    viewModel = nil
    reposService = nil
    super.tearDown()
  }
  
  func testFetchRepositoriesSuccess() {
    // Given
    let repositories = [Repository(id: 1, name: "Repo1", description: "Description1")]
    let expectation = XCTestExpectation(description: "State should be finishedLoading and repositories should be set")
    
    // Observe changes
    viewModel.$state
      .dropFirst()
      .sink { state in
        if case .finishedLoading = state {
          expectation.fulfill()
        }
      }
      .store(in: &subscriptions)
    
    viewModel.$repositories
      .dropFirst()
      .sink { repos in
        if repos == repositories {
          expectation.fulfill()
        }
      }
      .store(in: &subscriptions)
    
    // When
    viewModel.fetchRepositories(for: "GitHubRepositoryTest")
    reposService.repositoriesPublisherSubject.send(repositories)
    
    // Then
    wait(for: [expectation], timeout: 1.0)
    XCTAssertEqual(viewModel.repositories, repositories)
    XCTAssertEqual(viewModel.state, .finishedLoading)
  }
  
  func testFetchRepositoriesFailure() {
    // Given
    let error = NetworkError.decodingFailed
    let expectation = XCTestExpectation(description: "State should be error")
    
    // Observe changes
    viewModel.$state
      .dropFirst()
      .sink { state in
        if case .error(let error) = state, error == .repositoriesFetch(.decodingFailed) {
          expectation.fulfill()
        }
      }
      .store(in: &subscriptions)
    
    // When
    viewModel.fetchRepositories(for: "GitHubRepositoryTest")
    reposService.repositoriesPublisherSubject.send(completion: .failure(error))
    
    // Then
    wait(for: [expectation], timeout: 1.0)
    XCTAssertEqual(viewModel.state, .error(.repositoriesFetch(error)))
  }
  
  func testUserNameUpdates() {
    // Given
    let userName = "NewUser"
    
    // When
    viewModel.fetchRepositories(for: userName)
    
    // Then
    XCTAssertEqual(viewModel.userName, userName)
  }
}

// Mock Service
final class MockGitHubService: GitHubServiceProtocol {

  var repositoriesPublisherSubject = PassthroughSubject<[Repository], NetworkError>()

  var repositoriesPublisher: AnyPublisher<[Repository], NetworkError> {
    return repositoriesPublisherSubject.eraseToAnyPublisher()
  }

  func fetchRepositories(for user: String) { }
}
