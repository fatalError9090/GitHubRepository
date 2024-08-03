import XCTest
import Combine
@testable import GitHubRepository

class GitHubServiceTests: XCTestCase {
  
  var sut: GitHubService!
  var mockSession: URLSession!
  var cancellables: Set<AnyCancellable>!
  
  override func setUp() {
    super.setUp()
    
    let configuration = URLSessionConfiguration.ephemeral
    configuration.protocolClasses = [URLProtocolMock.self]
    mockSession = URLSession(configuration: configuration)
    
    sut = GitHubService(session: mockSession)
    cancellables = []
  }
  
  override func tearDown() {
    sut = nil
    mockSession = nil
    cancellables = nil
    URLProtocolMock.testURLs = [:]
    URLProtocolMock.response = nil
    URLProtocolMock.error = nil
    super.tearDown()
  }
  
  func testFetchRepositoriesSuccess() {
    let jsonData = """
        [
            {"id": 1, "name": "Repo1", "description": "Description1"},
            {"id": 2, "name": "Repo2", "description": "Description2"}
        ]
        """.data(using: .utf8)!
    
    URLProtocolMock.testURLs = [URL(string: "https://api.github.com/users/GitHubRepositoryTest/repos"): jsonData]
    URLProtocolMock.response = HTTPURLResponse(
      url: URL(string: "https://api.github.com/users/GitHubRepositoryTest/repos")!,
      statusCode: 200,
      httpVersion: nil,
      headerFields: nil
    )
    
    let expectation = self.expectation(description: "Fetch Repositories")
    
    sut.repositoriesPublisher
      .sink(receiveCompletion: { completion in
        if case let .failure(error) = completion {
          XCTFail("Unexpected error: \(error)")
        }
      }, receiveValue: { repositories in
        XCTAssertEqual(repositories.count, 2)
        XCTAssertEqual(repositories[0].name, "Repo1")
        XCTAssertEqual(repositories[1].name, "Repo2")
        expectation.fulfill()
      })
      .store(in: &cancellables)
    
    sut.fetchRepositories(for: "GitHubRepositoryTest")
    
    waitForExpectations(timeout: 1, handler: nil)
  }
  
  func testFetchRepositoriesInvalidURL() {
    sut = GitHubService(session: mockSession, baseURL: "invalid_url")
    
    let expectation = self.expectation(description: "Fetch Repositories")
    
    sut.repositoriesPublisher
      .sink(receiveCompletion: { completion in
        if case let .failure(error) = completion {
          XCTAssertEqual(error, NetworkError.invalidURL)
          expectation.fulfill()
        }
      }, receiveValue: { _ in
        XCTFail("Expected to throw, but did not")
      })
      .store(in: &cancellables)
    
    sut.fetchRepositories(for: "GitHubRepositoryTest")
    
    waitForExpectations(timeout: 1, handler: nil)
  }
  
  func testFetchRepositoriesEmptyUser() {
    let expectation = self.expectation(description: "Fetch Repositories")
    
    sut.repositoriesPublisher
      .sink(receiveCompletion: { completion in
        if case let .failure(error) = completion {
          XCTAssertEqual(error, NetworkError.emptyUser)
          expectation.fulfill()
        }
      }, receiveValue: { _ in
        XCTFail("Expected to throw, but did not")
      })
      .store(in: &cancellables)
    
    sut.fetchRepositories(for: "")
    
    waitForExpectations(timeout: 1, handler: nil)
  }
  
  func testFetchRepositoriesDecodingError() {
    let jsonData = """
        [
            {"invalid_field": 1}
        ]
        """.data(using: .utf8)!
    
    URLProtocolMock.testURLs = [URL(string: "https://api.github.com/users/Apple/repos"): jsonData]
    URLProtocolMock.response = HTTPURLResponse(
      url: URL(string: "https://api.github.com/users/Apple/repos")!,
      statusCode: 200,
      httpVersion: nil,
      headerFields: nil
    )
    
    let expectation = self.expectation(description: "Fetch Repositories")
    
    sut.repositoriesPublisher
      .sink(receiveCompletion: { completion in
        if case let .failure(error) = completion {
          XCTAssertEqual(error, NetworkError.decodingFailed)
          expectation.fulfill()
        }
      }, receiveValue: { _ in
        XCTFail("Expected to throw, but did not")
      })
      .store(in: &cancellables)
    
    sut.fetchRepositories(for: "GitHubRepositoryTest")
    
    waitForExpectations(timeout: 1, handler: nil)
  }
}
