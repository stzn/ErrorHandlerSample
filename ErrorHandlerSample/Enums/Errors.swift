import Foundation

enum ApiError: LocalizedError {
    case firstError
    case firstNextError
    case secondError
    
    var errorDescription: String? {
        switch self {
        case .firstError:
            return "First Error"
        case .firstNextError:
            return "First Next Error"
        case .secondError:
            return "Second Error"
        }
    }
}

enum UnexpectedError: LocalizedError {
    case only
    var errorDescription: String? {
        return "Unexpected Error"
    }
    
}
