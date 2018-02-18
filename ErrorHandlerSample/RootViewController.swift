import UIKit

final class RootViewController: UIViewController {
    
    private var errorHandler = ErrorHandler.default
    private var token: NSObjectProtocol?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        
        token = NotificationCenter.default.addObserver(forName: .errorOccured, object: nil, queue: nil) { [weak self] note in
            guard let strongSelf = self,
                let info = note.userInfo,
                let error = info["error"] as? Error else {
                    return
            }
            strongSelf.errorHandler.handle(error)
        }
    }
    
    deinit {
        token = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
