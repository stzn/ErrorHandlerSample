import Foundation

struct SecondViewModel {
    
    private let errorHandler: ErrorHandleable
    
    init(errorHandler: ErrorHandleable) {
        self.errorHandler = errorHandler
    }
    
    func throwError() throws {
        errorHandler.throw(ApiError.secondError)
    }
    
    func throwUnexpectedError() throws {
        errorHandler.throw(UnexpectedError.only)
    }
}
