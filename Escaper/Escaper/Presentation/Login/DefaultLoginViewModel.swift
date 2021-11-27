//
//  LoginViewModel.swift
//  Escaper
//
//  Created by shinheeRo on 2021/11/23.
//

import Foundation

protocol LoginViewModelProperty {
    var usecase: UserUseCaseInterface { get set }
    var emailMessage: Observable<String> { get set }
    var passwordMessage: Observable<String> { get set }
}

protocol LoginViewModelConfirm {
    func confirmUser(email: String, password: String, completion: @escaping (Result<User, UserError>) -> Void)
}

protocol LoginViewModelCheckButton {
    func isLoginButtonEnabled() -> Bool
}

protocol LoginViewModelEditable {
    func startEditing()
}

protocol LoginViewModel: LoginViewModelProperty, LoginViewModelConfirm, LoginViewModelCheckButton, LoginViewModelEditable { }

class DefaultLoginViewModel: LoginViewModel {
    var usecase: UserUseCaseInterface
    var emailMessage: Observable<String>
    var passwordMessage: Observable<String>

    init(usecase: UserUseCase) {
        self.usecase = usecase
        self.emailMessage = Observable("")
        self.passwordMessage = Observable("")
    }

    func confirmUser(email: String, password: String, completion: @escaping (Result<User, UserError>) -> Void) {
        self.usecase.confirm(userEmail: email, userPassword: password) { result in
            switch result {
            case .success(let user):
                completion(.success(user))
            case .failure(.notExist):
                self.emailMessage.value = Validator.notConfirmedErrorString
                self.passwordMessage.value = Validator.notConfirmedErrorString
                completion(.failure(.notExist))
            case .failure(.networkUnconneted):
                completion(.failure(.networkUnconneted))
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
