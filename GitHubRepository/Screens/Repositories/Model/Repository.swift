import Foundation

struct Repository: Codable, Hashable {
  
  let id: Int
  let name: String
  let fullName: String?
  let description: String?
  let stargazersCount: Int
  let language: String?
  var isFavorite: Bool = false
  
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case fullName = "full_name"
    case description
    case stargazersCount = "stargazers_count"
    case language
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  
  static func == (lhs: Repository, rhs: Repository) -> Bool {
    lhs.id == rhs.id
  }
}
