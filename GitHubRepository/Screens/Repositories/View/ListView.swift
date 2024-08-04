import UIKit

final class ListView: UIView {

  lazy var collectionView: UICollectionView = {
    let layout = createLayout()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.register(
      RepositorySectionHeaderView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: RepositorySectionHeaderView.reuseIdentifier
    )
    return collectionView
  }()
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
    let defaultMargin: CGFloat = 8.0
    
    NSLayoutConstraint.activate([
      collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: defaultMargin),
      collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -defaultMargin),
      collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 16.0),
      
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
    section.interGroupSpacing = 20
    
    let headerSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .estimated(44)
    )
    let header = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: headerSize,
      elementKind: UICollectionView.elementKindSectionHeader,
      alignment: .top
    )
    section.boundarySupplementaryItems = [header]

    return UICollectionViewCompositionalLayout(section: section)
  }
}
