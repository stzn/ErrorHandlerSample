import UIKit

final class RootViewController: UIViewController, AlertShowable {
    
    // Exclude from final error catch
    private let excludeErrors: [ErrorMatcher] = [
        { error in (error is ApiError) }
    ]
    
    private lazy var errorHandler = {
        
        ErrorHandler()
        .catch(UnexpectedError.self) { [unowned self] error in
            self.showAlert(title: "Root Error", message: error.localizedDescription)
        
        }
        .catch { [unowned self] error in

            // Propagate
            if self.excludeErrors.contains(where: { $0(error) }) {
                throw error
            }

            // Final error catch
            self.showAlert(title: "Root Error", message: "Somethig wrong!!!")
        }
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func start() {
        showFirst()
    }
    
    func showFirst() {
        let first = FirstFlowController(errorHandler)
        first.delegate = self
        add(childController: first)
        first.start()
    }
}

extension RootViewController: FirstFlowDelegate {
    func firstFlowDidFinish(_ flowController: FirstFlowController) {
        let second = SecondFlowController(errorHandler)
        second.delegate = self
        remove(childController: flowController)
        add(childController: second)
        second.start()
    }
}

extension RootViewController: SecondFlowDelegate {
    func secondFlowDidFinish(_ flowController: SecondFlowController) {
        remove(childController: flowController)
        showFirst()
    }
}
