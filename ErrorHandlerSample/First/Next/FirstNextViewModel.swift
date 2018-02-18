import Foundation

struct FirstNextViewModel {
    
    private let errorHandler: ErrorHandler
    let user: User
    
    init(errorHandler: ErrorHandler, user: User) {
        self.errorHandler = errorHandler
        self.user = user
    }
    
    func throwError() throws {
        
        asyncAction {
            self.errorHandler.postError(ApiError.firstError)
        }
    }
 
    func throwFirstNextError() throws {
        asyncAction {
            self.errorHandler.postError(ApiError.firstNextError)
        }
    }

    func throwUnexpectedError() throws {
        asyncAction {
            self.errorHandler.postError(UnexpectedError.only)
        }
    }
    
    func throwNSError() throws {
        asyncAction {
            self.errorHandler.postError(NSError(domain: "stzn.sample.nserror", code: 999, userInfo: ["message": "This is NSError!!"]))
        }
    }
    func asyncAction(callback: @escaping () -> Void) {
        ApiClient.doAsync {
            callback()
        }
    }
}
