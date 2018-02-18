import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var rootViewController: RootViewController!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        rootViewController = RootViewController()
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        
        rootViewController.start()
        
        return true
    }
}

