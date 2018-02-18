import UIKit

final class FirstNextViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    
    var viewModel: FirstNextViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = "Hello, \(viewModel.user.name)."
    }
    
    @IBAction func errorButtonTapped(_ sender: Any) {
        try? viewModel.throwError()
    }
    @IBAction func firstNextErrorButtonTapped(_ sender: Any) {
        try? viewModel.throwFirstNextError()
    }
    @IBAction func unexpectedButtonTapped(_ sender: Any) {
        try? viewModel.throwUnexpectedError()
    }
    @IBAction func nserrorButtonTapped(_ sender: Any) {
        try? viewModel.throwNSError()
    }
}

extension FirstNextViewController: StoryboardLoadable {
    
    static var storyboardName: String {
        return Storyboard.FirstNextViewController.name
    }
}

