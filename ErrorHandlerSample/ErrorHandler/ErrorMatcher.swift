import Foundation

// 再利用性を高めるためにクロージャではなくクラスとして利用する
public protocol ErrorMatcher {
    func matches(_ error: Error) -> Bool
}

public struct ErrorTypeMatcher<E: Error>: ErrorMatcher {
    
    public init() {}
    public func matches(_ error: Error) -> Bool {
        return error is E
    }
}

public struct ClosureErrorMatcher: ErrorMatcher {
    
    private let matches: (Error) -> Bool
    
    public init(matches: @escaping (Error) -> Bool) {
        self.matches = matches
    }
    
    public func matches(_ error: Error) -> Bool {
        return self.matches(error)
    }
}

public func && (lhs: ErrorMatcher, rhs: ErrorMatcher) -> ErrorMatcher {
    return ClosureErrorMatcher(matches: { (error) -> Bool in
        return lhs.matches(error) && rhs.matches(error)
    })
}

public func || (lhs: ErrorMatcher, rhs: ErrorMatcher) -> ErrorMatcher {
    return ClosureErrorMatcher(matches: { (error) -> Bool in
        return lhs.matches(error) || rhs.matches(error)
    })
}
