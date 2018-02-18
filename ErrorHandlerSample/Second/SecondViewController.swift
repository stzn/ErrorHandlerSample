import UIKit

protocol SecondViewDelegate: class {
    func goToFirst()
}

final class SecondViewController: UIViewController {

    var viewModel: SecondViewModel!
    weak var delegate: SecondViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func errorButtonTapped(_ sender: Any) {
        try? viewModel.throwError()
    }
    @IBAction func backButtonTapped(_ sender: Any) {
        delegate?.goToFirst()
    }
    @IBAction func unexpectedButtonTapped(_ sender: Any) {
        try? viewModel.throwUnexpectedError()
    }
}

extension SecondViewController: StoryboardLoadable {
    
    static var storyboardName: String {
        return Storyboard.SecondViewController.name
    }
}
