import UIKit
import Combine

final class ReposViewController: UIViewController {
  
  private typealias DataSource = UICollectionViewDiffableDataSource<ReposViewModel.Section, Repository>
  private typealias Snapshot = NSDiffableDataSourceSnapshot<ReposViewModel.Section, Repository>
  
  private lazy var contentView = ListView()
  private let viewModel: ReposViewModel
  private var subscriptions = Set<AnyCancellable>()
  private var dataSource: DataSource?
  
  init(viewModel: ReposViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    view = contentView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    configureDataSource()
    bindViewModel()
  }
}

private extension ReposViewController {

  func setupViews() {
    view.backgroundColor = .systemBackground
    navigationController?.navigationBar.prefersLargeTitles = true
    contentView.collectionView.register(RepositoryCollectionViewCell.self, forCellWithReuseIdentifier: RepositoryCollectionViewCell.identifier)
  }

  func configureDataSource() {
    dataSource = DataSource(collectionView: contentView.collectionView) { (collectionView, indexPath, repository) -> UICollectionViewCell? in
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RepositoryCollectionViewCell.identifier, for: indexPath) as? RepositoryCollectionViewCell else {
        return UICollectionViewCell()
      }
      cell.configure(with: repository)
      return cell
    }
  }

  func bindViewModel() {
    viewModel.$repositories
      .receive(on: RunLoop.main)
      .sink { [weak self] _ in
        self?.updateSections()
      }
      .store(in: &subscriptions)
    
    viewModel.$state
      .receive(on: RunLoop.main)
      .sink { [weak self] state in
        switch state {
        case .loading:
          self?.contentView.startLoading()
        case .finishedLoading:
          self?.contentView.finishLoading()
        case .error(let error):
          self?.contentView.finishLoading()
          self?.showErrorAlert(error: error)
        }
      }
      .store(in: &subscriptions)
    
    viewModel.$userName
      .receive(on: RunLoop.main)
      .sink { [weak self] userName in
        self?.title = userName
      }
      .store(in: &subscriptions)
  }

  func updateSections() {
    guard let dataSource = dataSource else { return }
    var snapshot = Snapshot()
    snapshot.appendSections([.repositories])
    snapshot.appendItems(viewModel.repositories)
    dataSource.apply(snapshot, animatingDifferences: true)
  }

  func showErrorAlert(error: ReposViewModelError) {
    let message: String
    switch error {
      case .repositoriesFetch(let networkError): message = networkError.description
    }
    let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    present(alert, animated: true)
  }
}
