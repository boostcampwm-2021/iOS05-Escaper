//
//  LoginViewModel.swift
//  Escaper
//
//  Created by shinheeRo on 2021/11/23.
//

import Foundation

protocol LoginViewModelProperty {
    var usecase: UserUseCase { get set }
    var emailMessage: Observable<String> { get set }
    var passwordMessage: Observable<String> { get set }
}

protocol LoginViewModelConfirm {
    func confirmUser(email: String, password: String, completion: @escaping (Bool) -> Void)
}

protocol LoginViewModelCheckButton {
    func isLoginButtonEnabled() -> Bool
}

protocol LoginViewModelEditable {
    func startEditing()
}

protocol LoginViewModel: LoginViewModelProperty, LoginViewModelConfirm, LoginViewModelCheckButton, LoginViewModelEditable { }

class DefaultLoginViewModel: LoginViewModel {
    var usecase: UserUseCase
    var emailMessage: Observable<String>
    var passwordMessage: Observable<String>

    init(usecase: UserUseCase) {
        self.usecase = usecase
        self.emailMessage = Observable("")
        self.passwordMessage = Observable("")
    }

    func confirmUser(email: String, password: String, completion: @escaping (Bool) -> Void) {
        self.usecase.confirm(userEmail: email, userPassword: password) { result in
            switch result {
            case .success(let isConfirmed):
                if isConfirmed {
                    completion(true)
                } else {
                    self.emailMessage.value = Validator.notConfirmedErrorString
                    self.passwordMessage.value = Validator.notConfirmedErrorString
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
