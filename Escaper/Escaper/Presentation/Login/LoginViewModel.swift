//
//  LoginViewModel.swift
//  Escaper
//
//  Created by shinheeRo on 2021/11/23.
//

import Foundation

class LoginViewModel {
    private let usecase: UserUseCase
    var emailMessage: Observable<String>
    var passwordMessage: Observable<String>

    init(usecase: UserUseCase) {
        self.usecase = usecase
        self.emailMessage = Observable("")
        self.passwordMessage = Observable(" ")
    }

    func confirmUser(email: String, password: String, completion: @escaping (Bool) -> Void) {
        self.usecase.confirm(userEmail: email, userPassword: password) { result in
            switch result {
            case .success(let isConfirmed):
                if isConfirmed {
                    completion(true)
                } else {
                    self.emailMessage.value = MessageType.notConfirmedError.value
                    self.passwordMessage.value = MessageType.notConfirmedError.value
                    completion(false)
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    func isLoginButtonEnabled() -> Bool {
        return self.emailMessage.value=="" && self.passwordMessage.value==""
    }

    func startEditing() {
        self.emailMessage.value = ""
        self.passwordMessage.value = ""
    }
}
