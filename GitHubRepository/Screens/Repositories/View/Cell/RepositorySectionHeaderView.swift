import UIKit

class RepositorySectionHeaderView: UICollectionReusableView {
  
  static let reuseIdentifier = "RepositorySectionHeaderView"
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 24)
    label.textColor = .accent
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(titleLabel)
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
      titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
      titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(with title: String) {
    titleLabel.text = title
  }
}
