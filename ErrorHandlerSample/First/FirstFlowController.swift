import UIKit

protocol FirstFlowDelegate: class {
    func firstFlowDidFinish(_ flowController: FirstFlowController)
}

final class FirstFlowController: UIViewController {
    
    private let navigation = UINavigationController()
    private let errorHandler: ErrorHandler
    weak var delegate: FirstFlowDelegate?
    
    init(_ errorHandler: ErrorHandler) {
        self.errorHandler = errorHandler
        super.init(nibName: nil, bundle: nil)
        add(childController: navigation)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        childViewControllers.first?.view.frame = view.bounds
    }

    func start() {
        let viewController = FirstViewController.fromStoryboard()
        viewController.delegate = self
        let viewModel = FirstViewModel(errorHandler: errorHandler)
        viewController.viewModel = viewModel
        navigation.viewControllers = [viewController]
    }
}

extension FirstFlowController: FirstViewDelegate {
    func goToNext(user: User) {
        let viewController = FirstNextViewController.fromStoryboard()
        let viewModel = FirstNextViewModel(errorHandler: errorHandler, user: user)
        viewController.viewModel = viewModel
        navigation.pushViewController(viewController, animated: true)
    }
    
    func goToSecond() {
        navigation.popViewController(animated: true)
        self.delegate?.firstFlowDidFinish(self)
    }
}
