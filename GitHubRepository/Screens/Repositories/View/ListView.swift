import UIKit

final class ListView: UIView {

  lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
  lazy var activityIndicationView = UIActivityIndicatorView(style: .medium)
  
  init() {
    super.init(frame: .zero)
    
    addSubviews()
    setUpConstraints()
    setUpViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func addSubviews() {
    let subviews = [collectionView, activityIndicationView]
    
    subviews.forEach {
      addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
    }
  }
  
  func startLoading() {
    collectionView.isUserInteractionEnabled = false
    activityIndicationView.isHidden = false
    activityIndicationView.startAnimating()
  }
  
  func finishLoading() {
    collectionView.isUserInteractionEnabled = true
    activityIndicationView.stopAnimating()
  }
  
  private func setUpConstraints() {
    let defaultMargin: CGFloat = 16.0
    
    NSLayoutConstraint.activate([
      collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: defaultMargin),
      collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -defaultMargin),
      collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: defaultMargin),
      
      activityIndicationView.centerXAnchor.constraint(equalTo: centerXAnchor),
      activityIndicationView.centerYAnchor.constraint(equalTo: centerYAnchor),
      activityIndicationView.heightAnchor.constraint(equalToConstant: 50),
      activityIndicationView.widthAnchor.constraint(equalToConstant: 50.0)
    ])
  }
  
  private func setUpViews() {
    collectionView.backgroundColor = .systemBackground
  }
  
  private func createLayout() -> UICollectionViewLayout {
    let size = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .estimated(80))
    let item = NSCollectionLayoutItem(layoutSize: size)
    let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [item])
    
    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
    section.interGroupSpacing = 5
    
    return UICollectionViewCompositionalLayout(section: section)
  }
}
