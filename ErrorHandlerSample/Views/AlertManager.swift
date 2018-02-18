import UIKit

struct AlertManager: AlertShowable {
    
    static var shared = AlertManager()
    private init() {}
    
    private var vc: UIViewController {
        return UIApplication.shared.keyWindow!.rootViewController!
    }
    
    func showAlert(title: String?, message: String?) {
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        DispatchQueue.main.async {
            self.showAlert(title: title, message: message, actions: [okAction])
        }
    }
    
    func showErrorAlert(message: String) {
        DispatchQueue.main.async {
            self.showAlert(title: "Error", message: message)
        }
    }
    
    func showAlert(title: String?, message: String?, actions: [UIAlertAction]? = nil, handler: ((UIAlertAction) -> Void)? = nil) {
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .crossDissolve
        
        if let actions = actions {
            actions.forEach { action in
                controller.addAction(action)
            }
        } else {
            let okAction = UIAlertAction(title: "OK", style: .default, handler: handler)
            controller.addAction(okAction)
        }
        
        vc.present(controller, animated: true, completion: nil)
        
        return
    }
    
    func confirm(title: String, message: String, okTitle: String = "Yes", cancelTitle: String = "No", okHandler: ((UIAlertAction) -> Void)? = nil, cancelHandler: ((UIAlertAction) -> Void)? = nil) {
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .crossDissolve
        
        let okAction = UIAlertAction(title: okTitle, style: .default, handler: okHandler)
        controller.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: cancelTitle, style: .default, handler: cancelHandler)
        controller.addAction(cancelAction)
        
        vc.present(controller, animated: true, completion: nil)
        return
    }
}
