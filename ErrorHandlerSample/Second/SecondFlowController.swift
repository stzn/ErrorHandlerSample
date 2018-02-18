import UIKit

protocol SecondFlowDelegate: class {
    func secondFlowDidFinish(_ flowController: SecondFlowController)
}


final class SecondFlowController: UIViewController {

    private let navigation = UINavigationController()
    private let errorHandler: ErrorHandler
    weak var delegate: SecondFlowDelegate?

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
        let viewController = SecondViewController.fromStoryboard()
        viewController.delegate = self
        let viewModel = SecondViewModel(errorHandler: errorHandler)
        viewController.viewModel = viewModel
        navigation.viewControllers = [viewController]
    }
}

extension SecondFlowController: SecondViewDelegate {
    func goToFirst() {
        navigation.popViewController(animated: true)
        self.delegate?.secondFlowDidFinish(self)
    }
}
