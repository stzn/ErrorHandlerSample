import Foundation

struct ApiClient {
    static func doAsync(action: @escaping () -> Void) {
        DispatchQueue.global().async {
            sleep(1)
            action()
        }
    }
}
