import Foundation
import Combine

final class RepositoryDetailViewModel: ObservableObject {

  @Published var fullName: String
  @Published var description: String
  @Published var language: String
  @Published var stars: String

  init(repository: Repository) {
    self.fullName = repository.fullName ?? "Unknown Repository"
    self.description = repository.description ?? "No description available."
    self.language = repository.language ?? "N/A"
    self.stars = "\(String(describing: repository.stargazersCount)) ⭐️"
  }
}
