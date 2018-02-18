import Foundation

struct SecondViewModel {
    
    private let errorHandler: ErrorHandler
    
    init(errorHandler: ErrorHandler) {
        self.errorHandler = errorHandler
    }
    
    func throwError() throws {
        errorHandler.postError(ApiError.secondError)
    }
    
    func throwUnexpectedError() throws {
        errorHandler.postError(UnexpectedError.only)
    }
}
