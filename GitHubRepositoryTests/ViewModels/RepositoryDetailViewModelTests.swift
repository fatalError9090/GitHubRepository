import XCTest
import Combine
@testable import GitHubRepository 

final class RepositoryDetailViewModelTests: XCTestCase {
    
    var viewModel: RepositoryDetailViewModel!
    var repository: Repository!
    var subscriptions: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        
        // Sample repository data
        repository = Repository(
            id: 1,
            name: "TestRepo",
            fullName: "TestUser/TestRepo",
            description: "This is a test repository",
            stargazersCount: 123,
            language: "Swift",
            isFavorite: false
        )
        
        viewModel = RepositoryDetailViewModel(repository: repository)
        subscriptions = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        viewModel = nil
        repository = nil
        subscriptions = nil
        
        super.tearDown()
    }
    
    func testFullName() {
        let expectation = XCTestExpectation(description: "Full name should be published")
        
        viewModel.$fullName
            .sink { fullName in
                XCTAssertEqual(fullName, "TestUser/TestRepo")
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testDescription() {
        let expectation = XCTestExpectation(description: "Description should be published")
        
        viewModel.$description
            .sink { description in
                XCTAssertEqual(description, "This is a test repository")
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLanguage() {
        let expectation = XCTestExpectation(description: "Language should be published")
        
        viewModel.$language
            .sink { language in
                XCTAssertEqual(language, "Swift")
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testStars() {
        let expectation = XCTestExpectation(description: "Stars should be published")
        
        viewModel.$stars
            .sink { stars in
                XCTAssertEqual(stars, "123 ⭐️")
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testDefaultValuesForNilRepositoryProperties() {
        let repositoryWithNilProperties = Repository(
            id: 2,
            name: "TestRepoNil",
            fullName: nil,
            description: nil,
            stargazersCount: 0,
            language: nil
        )
        
        viewModel = RepositoryDetailViewModel(repository: repositoryWithNilProperties)
        
        let fullNameExpectation = XCTestExpectation(description: "Default full name should be published")
        viewModel.$fullName
            .sink { fullName in
                XCTAssertEqual(fullName, "Unknown Repository")
                fullNameExpectation.fulfill()
            }
            .store(in: &subscriptions)
        
        let descriptionExpectation = XCTestExpectation(description: "Default description should be published")
        viewModel.$description
            .sink { description in
                XCTAssertEqual(description, "No description available.")
                descriptionExpectation.fulfill()
            }
            .store(in: &subscriptions)
        
        let languageExpectation = XCTestExpectation(description: "Default language should be published")
        viewModel.$language
            .sink { language in
                XCTAssertEqual(language, "N/A")
                languageExpectation.fulfill()
            }
            .store(in: &subscriptions)
        
        let starsExpectation = XCTestExpectation(description: "Stars should be published")
        viewModel.$stars
            .sink { stars in
                XCTAssertEqual(stars, "0 ⭐️")
                starsExpectation.fulfill()
            }
            .store(in: &subscriptions)
        
        wait(for: [fullNameExpectation, descriptionExpectation, languageExpectation, starsExpectation], timeout: 1.0)
    }
  
  func testToggleFavorite() {
    let expectation = XCTestExpectation(description: "Favorite status should toggle")
    
    viewModel.$isFavorite
      .dropFirst() // ignore the initial value
      .sink { isFavorite in
        XCTAssertEqual(isFavorite, true)
        expectation.fulfill()
      }
      .store(in: &subscriptions)
    
    viewModel.toggleFavorite()
    
    wait(for: [expectation], timeout: 1.0)
    XCTAssertTrue(viewModel.isFavorite)
    XCTAssertTrue(viewModel.getRepository().isFavorite)
  }
  
  func testToggleFavoriteTwice() {
    let expectation = XCTestExpectation(description: "Favorite status should toggle twice")
    
    viewModel.$isFavorite
      .dropFirst(2) // ignore the initial value and the first toggle
      .sink { isFavorite in
        XCTAssertEqual(isFavorite, false)
        expectation.fulfill()
      }
      .store(in: &subscriptions)
    
    viewModel.toggleFavorite()
    viewModel.toggleFavorite()
    
    wait(for: [expectation], timeout: 1.0)
    XCTAssertFalse(viewModel.isFavorite)
    XCTAssertFalse(viewModel.getRepository().isFavorite)
  }
  
  func testGetRepository() {
    let fetchedRepository = viewModel.getRepository()
    XCTAssertEqual(fetchedRepository.id, repository.id)
    XCTAssertEqual(fetchedRepository.name, repository.name)
    XCTAssertEqual(fetchedRepository.fullName, repository.fullName)
    XCTAssertEqual(fetchedRepository.description, repository.description)
    XCTAssertEqual(fetchedRepository.stargazersCount, repository.stargazersCount)
    XCTAssertEqual(fetchedRepository.language, repository.language)
    XCTAssertEqual(fetchedRepository.isFavorite, repository.isFavorite)
  }
}
