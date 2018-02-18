import Foundation

enum Storyboard: String  {
    
    case FirstViewController = "FirstViewController"
    case SecondViewController = "SecondViewController"
    case FirstNextViewController = "FirstNextViewController"

    var name: String {
        return self.rawValue
    }
}
