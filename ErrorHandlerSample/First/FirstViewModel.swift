import Foundation

struct FirstViewModel {
    
    private let errorHandler: ErrorHandler
    
    init(errorHandler: ErrorHandler) {
        self.errorHandler = errorHandler
    }
    
    func nextButtonTapped(callback: @escaping (User) -> Void) {
        fetchNextInformation { result in
            switch result {
            case .success(let user):
                callback(user)
            case .error(let error):
                self.errorHandler.postError(error)
            }
        }
    }
    
    func fetchNextInformation(callback: @escaping (Result<User>) -> Void) {
        ApiClient.doAsync {
            if arc4random() % 2 == 0 {
                callback(.success(User(name: "Me")))
            } else {
                callback(.error(ApiError.firstError))
            }
        }
    }
}
