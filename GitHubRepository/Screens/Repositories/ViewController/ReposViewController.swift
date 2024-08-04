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
  
  @objc func searchButtonTapped() {
    let alertController = UIAlertController(title: "Search User", message: "Enter GitHub username", preferredStyle: .alert)
    alertController.addTextField { textField in
      textField.placeholder = "Username"
    }
    let searchAction = UIAlertAction(title: "Search", style: .default) { [weak self] _ in
      guard let username = alertController.textFields?.first?.text, !username.isEmpty else { return }
      self?.viewModel.fetchRepositories(for: username)
    }
    alertController.addAction(searchAction)
    alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    present(alertController, animated: true, completion: nil)
  }
}

private extension ReposViewController {

  func setupViews() {
    view.backgroundColor = .systemBackground
    navigationController?.navigationBar.prefersLargeTitles = true
    contentView.collectionView.register(RepositoryCollectionViewCell.self, forCellWithReuseIdentifier: RepositoryCollectionViewCell.identifier)
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonTapped))
  }

  func configureDataSource() {
    dataSource = DataSource(collectionView: contentView.collectionView) { (collectionView, indexPath, repository) -> UICollectionViewCell? in
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RepositoryCollectionViewCell.identifier, for: indexPath) as? RepositoryCollectionViewCell else {
        return UICollectionViewCell()
      }
      cell.configure(with: repository)
      return cell
    }
    
    dataSource?.supplementaryViewProvider = { (collectionView, kind, indexPath) in
      guard kind == UICollectionView.elementKindSectionHeader else { return nil }
      guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RepositorySectionHeaderView.reuseIdentifier, for: indexPath) as? RepositorySectionHeaderView else {
        return nil
      }
      // Set the header title based on the section type
      let section = self.dataSource?.snapshot().sectionIdentifiers[indexPath.section]
      headerView.configure(with: section?.title ?? "")
      return headerView
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
