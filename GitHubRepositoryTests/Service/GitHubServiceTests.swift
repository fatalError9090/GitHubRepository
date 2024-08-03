import XCTest
@testable import GitHubRepository

class GitHubServiceTests: XCTestCase {
  var sut: GitHubService!
  var mockSession: URLSession!

  override func setUp() {
    super.setUp()

    let configuration = URLSessionConfiguration.ephemeral
    configuration.protocolClasses = [URLProtocolMock.self]
    mockSession = URLSession(configuration: configuration)
    
    sut = GitHubService(session: mockSession)
  }

  override func tearDown() {
    sut = nil
    mockSession = nil
    super.tearDown()
  }

  func testFetchRepositoriesSuccess() async throws {
    let jsonData = """
        [
            {"id": 1, "name": "Repo1", "description": "Description1"},
            {"id": 2, "name": "Repo2", "description": "Description2"}
        ]
        """.data(using: .utf8)!

    URLProtocolMock.testURLs = [URL(
      string: "https://api.github.com/users/GitHubRepositoryTest/repos"
    )!: jsonData]
    URLProtocolMock.response = HTTPURLResponse(
      url: URL(
        string: "https://api.github.com/users/GitHubRepositoryTest/repos"
      )!,
      statusCode: 200,
      httpVersion: nil,
      headerFields: nil
    )!

    let repositories = try await sut.fetchRepositories(for: "GitHubRepositoryTest")

    XCTAssertEqual(repositories.count, 2)
    XCTAssertEqual(repositories[0].name, "Repo1")
    XCTAssertEqual(repositories[1].name, "Repo2")
  }

  func testFetchRepositoriesInvalidURL() async throws {
    sut = GitHubService(session: mockSession, baseURL: "invalid_url")
    
    do {
      _ = try await sut.fetchRepositories(for: "GitHubRepositoryTest")
      XCTFail("Expected to throw, but did not")
    } catch let error as NetworkError {
      XCTAssertEqual(error, NetworkError.invalidURL)
    } catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testFetchRepositoriesEmptyUser() async throws {
    do {
      _ = try await sut.fetchRepositories(for: "")
      XCTFail("Expected to throw, but did not")
    } catch let error as NetworkError {
      XCTAssertEqual(error, NetworkError.emptyUser)
    } catch {
      XCTFail("Unexpected error: \(error)")
    }
  }

  func testFetchRepositoriesDecodingError() async throws {
    let jsonData = """
        [
            {"invalid_field": 1}
        ]
        """.data(using: .utf8)!
    
    URLProtocolMock.testURLs = [URL(
      string: "https://api.github.com/users/GitHubRepositoryTest/repos"
    )!: jsonData]
    URLProtocolMock.response = HTTPURLResponse(
      url: URL(
        string: "https://api.github.com/users/GitHubRepositoryTest/repos"
      )!,
      statusCode: 200,
      httpVersion: nil,
      headerFields: nil
    )!
    
    do {
      _ = try await sut.fetchRepositories(for: "GitHubRepositoryTest")
      XCTFail("Expected to throw, but did not")
    } catch let error as NetworkError {
      XCTAssertEqual(error, NetworkError.decodingFailed)
    }
  }
}
