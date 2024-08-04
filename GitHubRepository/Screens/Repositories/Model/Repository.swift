import Foundation

struct Repository: Codable, Hashable {
  
  let id: Int
  let name: String
  let description: String?
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  
  static func == (lhs: Repository, rhs: Repository) -> Bool {
    lhs.id == rhs.id
  }
}
