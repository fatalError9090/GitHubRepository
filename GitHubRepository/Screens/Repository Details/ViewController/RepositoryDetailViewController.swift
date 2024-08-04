import UIKit
import Combine

final class RepositoryDetailViewController: UIViewController {
  
  private let viewModel: RepositoryDetailViewModel
  private let detailView = RepositoryDetailView()
  private var subscriptions = Set<AnyCancellable>()
  
  init(viewModel: RepositoryDetailViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    view = detailView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    bindViewModel()
  }
  
  private func bindViewModel() {
    viewModel.$fullName
      .receive(on: RunLoop.main)
      .sink { [weak self] fullName in
        self?.title = fullName
      }
      .store(in: &subscriptions)
    
    viewModel.$description
      .receive(on: RunLoop.main)
      .sink { [weak self] description in
        self?.detailView.updateDescriptionLabel(description)
      }
      .store(in: &subscriptions)
    
    viewModel.$language
      .receive(on: RunLoop.main)
      .sink { [weak self] language in
        self?.detailView.updateLanguageLabel(language)
      }
      .store(in: &subscriptions)
    
    viewModel.$stars
      .receive(on: RunLoop.main)
      .sink { [weak self] stars in
        self?.detailView.updateStarsLabel(stars)
      }
      .store(in: &subscriptions)
  }
}
