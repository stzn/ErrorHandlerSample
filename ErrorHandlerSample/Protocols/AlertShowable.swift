import UIKit

protocol AlertShowable {
    func showAlert(title: String?, message: String?)
    func showErrorAlert(message: String)
}
