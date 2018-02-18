import Foundation

extension ErrorHandler {
    
    static var `default`: ErrorHandler {
        
        return ErrorHandler()
            .onError(ofType: ApiError.self,
                do: { error -> HandleStrategy in
                    print(error.localizedDescription)
                    AlertManager.shared.showErrorAlert(message: error.localizedDescription)
                    return .next
            })
            .onError(ofType: UnexpectedError.self,
                     do: { error -> HandleStrategy in
                        print(error.localizedDescription)
                        AlertManager.shared.confirm(title: "Error", message: "Exit?")
                        return .next
            })
           .onNSError(domain: "stzn.sample.nserror",
                do: { error -> HandleStrategy in
                    let nserror = error as NSError
                    let message = "NSError \n domain:\(nserror.domain) \n code:\(nserror.code) \n userInfo:\(nserror.userInfo)"
                    print(message)
                    AlertManager.shared.showErrorAlert(message: message)
                    return .next
            })
            .onNoMatch(do: {_ in
                AlertManager.shared.showErrorAlert(message: "Something wrong!!")
                print("Something wrong!!")
                return .stop
            })
            .always(do: { _ in
                print("Finish error handle!!")
                return .stop
            })
    }
}
