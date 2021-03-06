import Foundation

struct FirstNextViewModel {
    
    private let errorHandler: ErrorHandleable
    let user: User
    
    init(errorHandler: ErrorHandleable, user: User) {
        self.errorHandler = errorHandler
        self.user = user
    }
    
    func throwError() throws {
        
        asyncAction {
            throw ApiError.firstError
        }
    }
 
    func throwFirstNextError() throws {
        asyncAction {
            throw ApiError.firstNextError
        }
    }

    func throwUnexpectedError() throws {
        asyncAction {
            throw UnexpectedError.only
        }
    }
    
    func throwNSError() throws {
        asyncAction {
            throw NSError(domain: "example.stzn.nseeror", code: 999, userInfo: ["message": "This is NSError!!"])
        }
    }
    func asyncAction(callback: @escaping () throws -> Void) {
        ApiClient.doAsync {
            
            do {
                try callback()
            } catch let error {
                self.errorHandler.throw(error)
            }
        }
    }
}
