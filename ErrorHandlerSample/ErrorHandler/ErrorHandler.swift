import Foundation

extension Notification.Name {
    public static let errorOccured = Notification.Name("errorOccured")
}

public enum HandleStrategy {
    case next
    case stop
}

public typealias ErrorAction = (Error) -> HandleStrategy
public typealias Tag = String
    
public final class ErrorHandler {
    
    private var errorActions: [(ErrorMatcher, ErrorAction)] = []
    private var onNoMatch:[ErrorAction] = []
    private var alwaysActions: [ErrorAction] = []
    private var errorStack: [Error] = []
    
    private var tagsDictionary = [Tag: [ErrorMatcher]]()

    public init() {}
    
    public func on(matches: @escaping ((Error)-> Bool), do action: @escaping ErrorAction) -> ErrorHandler {
        let matcher = ClosureErrorMatcher(matches: matches)
        return on(matcher, do: action)
    }
    
    public func on(_ matcher: ErrorMatcher, do action: @escaping ErrorAction) -> ErrorHandler {
        errorActions.append((matcher, action))
        return self
    }
    
    public func onNoMatch(do action: @escaping ErrorAction) -> ErrorHandler {
        onNoMatch.append(action)
        return self
    }
    
    public func always(do action: @escaping ErrorAction) -> ErrorHandler {
        alwaysActions.append(action)
        return self
    }
    
    
    public func handle(_ error: Error) {
        
        // 最後に必ず実行するアクション
        defer {
            for alwaysAction in alwaysActions.reversed() {
                let alwaysHandleStrategy = alwaysAction(error)
                if case .stop = alwaysHandleStrategy {
                    break
                }
            }
        }

        // 条件にあったエラーに対してアクションをする
        var found = false
        for (matcher, action) in errorActions.reversed() {
            if matcher.matches(error) {
                found = true
                let strategy = action(error)
                // stopがあっても引き続きアクションは実行していく
                if case .stop = strategy {
                    return
                }
            }
        }
        
        // アクション済みの場合は終了
        if found { return }
        
        // 条件に合うエラーではなかったエラーに対してアクションをする
        for otherwise in onNoMatch.reversed() {
            let strategy = otherwise(error)
            if case .stop = strategy {
                break
            }
        }
    }
    
    
    // tagでグループ化して共通のエラーアクションを実行する
    public func tag(matches: @escaping ((Error) -> Bool), with tag: Tag) -> ErrorHandler {
        let matcher = ClosureErrorMatcher(matches: matches)
        return self.tag(matcher, with: tag)
    }
    public func tag(_ matcher: ErrorMatcher, with tag: Tag) -> ErrorHandler {
        if tagsDictionary[tag] != nil {
            tagsDictionary[tag]?.append(matcher)
        } else {
            tagsDictionary[tag] = [matcher]
        }
        return self
    }
    public func on(tag: Tag, do action: @escaping ErrorAction) -> ErrorHandler {
        guard let taggedMatchers = tagsDictionary[tag] else { return self }
        let matcherActionPairs = taggedMatchers.map({ ($0, action) })
        errorActions.append(contentsOf: matcherActionPairs)
        return self
    }
    
    // ErrorのTypeにまとめて同じアクションを設定する
    public func onError<T: Error>(ofType type: T.Type, do action: @escaping ErrorAction) -> ErrorHandler {
        return on(ErrorTypeMatcher<T>(), do: action)
    }
    public func on<E:Error & Equatable>(_ error: E, do action: @escaping ErrorAction) -> ErrorHandler {
        return self.on(matches: { (handleError) -> Bool in
            guard let handleError = handleError as? E else { return false }
            return handleError == error
        }, do: action)

    }
    public func onNSError(domain: String, code: Int? = nil, do action: @escaping ErrorAction) -> ErrorHandler {
        return self.on(NSErrorMatcher(domain: domain, code: code), do: action)
    }
    
    public func postError(_ error: Error) {
        NotificationCenter.default.post(name: .errorOccured, object: nil, userInfo: ["error": error])
    }
}

public func tryWith(_ handler: ErrorHandler, closure: () throws -> Void) {
    do {
        try closure()
    } catch {
        handler.handle(error)
    }
}


