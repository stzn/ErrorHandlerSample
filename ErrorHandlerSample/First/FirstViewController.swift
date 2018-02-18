import UIKit

protocol FirstViewDelegate: class {
    func goToNext(user: User)
    func goToSecond()
}

final class FirstViewController: UIViewController {

    var viewModel: FirstViewModel!
    weak var delegate: FirstViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        viewModel.nextButtonTapped { [weak self] user in
            
            guard let strongSelf = self else {
                return
            }
            DispatchQueue.main.async {
                strongSelf.delegate?.goToNext(user: user)
            }
        }
    }
    @IBAction func goSecondButtonTapped(_ sender: Any) {
        delegate?.goToSecond()
    }
}

extension FirstViewController: StoryboardLoadable {
    
    static var storyboardName: String {
        return Storyboard.FirstViewController.name
    }
}
