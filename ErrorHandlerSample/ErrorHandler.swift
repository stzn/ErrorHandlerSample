import Foundation

public typealias HandleAction<T> = (T) throws -> ()
public typealias ErrorMatcher = (Error) -> Bool

public protocol ErrorHandleable: class {
    func `throw`(_: Error, finally: @escaping (Bool) -> Void)
    func `catch`(action: @escaping HandleAction<Error>) -> ErrorHandleable
}

public class ErrorHandler: ErrorHandleable {
    private var parent: ErrorHandler?
    private let action: HandleAction<Error>
    
    public convenience init(action: @escaping HandleAction<Error> = { throw $0 }) {
        self.init(action: action, parent: nil)
    }
    
    private init(action: @escaping HandleAction<Error>, parent: ErrorHandler? = nil) {
        self.action = action
        self.parent = parent
    }

    public func `throw`(_ error: Error, finally: @escaping (Bool) -> Void) {
        `throw`(error, previous: [], finally: finally)
    }
    
    private func `throw`(_ error: Error, previous: [ErrorHandler], finally: ((Bool) -> Void)? = nil) {
        // Phase1
        if let parent = parent {
            parent.`throw`(error, previous: previous + [self], finally: finally)
            return
        }
        // Phase2
        serve(error, next: AnyCollection(previous.reversed()), finally: finally)
    }
    
    private func serve(_ error: Error, next: AnyCollection<ErrorHandler>, finally: ((Bool) -> Void)? = nil) {
        do {
            try action(error)
            finally?(true)
        } catch {
            if let nextHandler = next.first {
                nextHandler.serve(error, next: next.dropFirst(), finally: finally)
            } else {
                finally?(false)
            }
        }
    }
    
    public func `catch`(action: @escaping HandleAction<Error>) -> ErrorHandleable {
        return ErrorHandler(action: action, parent: self)
    }
}

public extension ErrorHandleable {
    func `do`<A>(_ section: () throws -> A) {
        do {
            _ = try section()
        } catch {
            `throw`(error)
        }
    }
}

public extension ErrorHandleable {
    func `throw`(_ error: Error) {
        `throw`(error, finally: { _ in })
    }
}

public extension ErrorHandleable {
    func `catch`<K: Error>(_ type: K.Type, action: @escaping HandleAction<K>) -> ErrorHandleable {
        return `catch`(action: { (e) in
            if let k = e as? K {
                try action(k)
            } else {
                throw e
            }
        })
    }
    func `catch`<K: Error>(_ value: K, action: @escaping HandleAction<K>) -> ErrorHandleable where K: Equatable {
        return `catch`(action: { (e) in
            if let k = e as? K, k == value {
                try action(k)
            } else {
                throw e
            }
        })
    }
}

public extension ErrorHandleable {
    
    func listen(action: @escaping (Error) -> ()) -> ErrorHandleable {
        return `catch`(action: { e in
            action(e)
            throw e
        })
    }
    
    func listen<K: Error>(_ type: K.Type, action: @escaping (K) -> ()) -> ErrorHandleable where K: Equatable {
        return `catch`(type, action: { e in
            action(e)
            throw e
        })
    }
    
    func listen<K: Error>(_ value: K, action: @escaping (K) -> ()) -> ErrorHandleable where K: Equatable {
        return `catch`(value, action: { e in
            action(e)
            throw e
        })
    }
}

