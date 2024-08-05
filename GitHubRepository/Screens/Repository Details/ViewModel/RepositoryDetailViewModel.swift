import Foundation
import Combine

final class RepositoryDetailViewModel: ObservableObject {

  @Published var fullName: String
  @Published var description: String
  @Published var language: String
  @Published var stars: String
  @Published var isFavorite: Bool
  
  private var repository: Repository

  init(repository: Repository) {
    self.repository = repository
    self.fullName = repository.fullName ?? "Unknown Repository"
    self.description = repository.description ?? "No description available."
    self.language = repository.language ?? "N/A"
    self.stars = "\(String(describing: repository.stargazersCount)) ⭐️"
    self.isFavorite = repository.isFavorite
  }
  
  func toggleFavorite() {
    repository.isFavorite.toggle()
    isFavorite = repository.isFavorite
  }
  
  func getRepository() -> Repository {
    return repository
  }
}
