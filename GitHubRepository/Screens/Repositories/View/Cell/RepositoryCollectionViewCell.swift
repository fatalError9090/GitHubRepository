import UIKit

final class RepositoryCollectionViewCell: UICollectionViewCell {
  
  static let identifier = "RepositoryCollectionViewCell"
  
  private lazy var nameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 18)
    label.numberOfLines = 0
    label.textColor = .accent
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private lazy var descriptionLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14)
    label.textColor = UIColor(named: "descriptionText")
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureCell()
    addSubviews()
    setUpConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureCell() {
    contentView.layer.cornerRadius = 8
    contentView.layer.masksToBounds = true
    contentView.backgroundColor = UIColor(named: "backgroundColor")
    
    layer.shadowColor = UIColor(named: "backgroundColor")?.cgColor
    layer.shadowOpacity = 1.0
    layer.shadowOffset = CGSize(width: 0, height: 3)
    layer.shadowRadius = 4
    layer.masksToBounds = false
  }
  
  private func addSubviews() {
    let subviews = [nameLabel, descriptionLabel]
    
    subviews.forEach {
      contentView.addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
    }
  }
  
  private func setUpConstraints() {
    let defaultMargin: CGFloat = 16.0
    
     NSLayoutConstraint.activate([
       nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: defaultMargin),
       nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: defaultMargin),
       nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -defaultMargin),
       
       descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: defaultMargin/2),
       descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: defaultMargin),
       descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -defaultMargin),
       descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -defaultMargin)
     ])
   }
  
  func configure(with repository: Repository) {
    nameLabel.text = repository.name
    descriptionLabel.text = repository.description ?? ""
  }
}
