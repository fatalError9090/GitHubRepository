import UIKit

final class RepositoryDetailView: UIView {

  lazy var descriptionLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  lazy var languageLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  lazy var starsLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupViews() {
    addSubview(descriptionLabel)
    addSubview(languageLabel)
    addSubview(starsLabel)
    
    NSLayoutConstraint.activate([
      descriptionLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      
      languageLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
      languageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      languageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      
      starsLabel.topAnchor.constraint(equalTo: languageLabel.bottomAnchor, constant: 8),
      starsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      starsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
    ])
  }
  
  func updateDescriptionLabel(_ description: String) {
    descriptionLabel.attributedText = description.formattedText(prefix: "Description")
  }
  
  func updateLanguageLabel(_ language: String) {
    languageLabel.attributedText = language.formattedText(prefix: "Language")
  }
  
  func updateStarsLabel(_ stars: String) {
    starsLabel.attributedText = stars.formattedText(prefix: "Stars")
  }
}
