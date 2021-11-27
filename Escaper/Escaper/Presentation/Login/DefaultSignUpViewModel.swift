//
//  SignUpViewModel.swift
//  Escaper
//
//  Created by shinheeRo on 2021/11/23.
//

import Foundation

protocol SignUpViewModelProperty {
    var usecase: UserUseCaseInterface { get }
    var emailMessage: Observable<String> { get set }
    var passwordMessage: Observable<String> { get set }
    var passwordCheckMessage: Observable<String> { get set }
}

protocol SignUpViewModelCheck {
    func checkEmail(text: String)
    func checkPassword(text: String)
    func checkDiscordance(text1: String, text2: String)
}

protocol SignUpViewModelEnableButton {
    func isSignupButtonEnabled() -> Bool
}

protocol SignUpViewModelUser {
    func queryUser(email: String, completion: @escaping (Bool) -> Void)
    func addUser(email: String, password: String, urlString: String)
}

protocol SignUpViewModel: SignUpViewModelProperty, SignUpViewModelCheck, SignUpViewModelEnableButton, SignUpViewModelUser { }

class DefaultSignUpViewModel: SignUpViewModel {
    internal var usecase: UserUseCaseInterface
    var emailMessage: Observable<String>
    var passwordMessage: Observable<String>
    var passwordCheckMessage: Observable<String>

    init(usecase: UserUseCase) {
        self.usecase = usecase
        self.emailMessage = Observable("")
        self.passwordMessage = Observable("")
        self.passwordCheckMessage = Observable(" ")
    }

    func checkEmail(text: String) {
        self.emailMessage.value = Validator.checkEmailFormat(text: text)
    }

    func checkPassword(text: String) {
        self.passwordMessage.value = Validator.checkNumberOfDigits(text: text)
    }

    func checkDiscordance(text1: String, text2: String) {
        self.passwordCheckMessage.value = Validator.checkDiscordance(text1: text1, text2: text2)
    }

    func isSignupButtonEnabled() -> Bool {
        return emailMessage.value=="" && passwordMessage.value=="" && passwordCheckMessage.value==""
    }

    func queryUser(email: String, completion: @escaping (Bool) -> Void) {
        self.usecase.query(userEmail: email) { result in
            switch result {
            case .success(let isExist):
                if isExist {
                    self.emailMessage.value = Validator.alreadyExistErrorString
                    completion(true)
                } else {
                    completion(false)
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    func addUser(email: String, password: String, urlString: String) {
        if let name = Helper.parseUsername(email: email) {
            let user = User(email: email, name: name, password: password, imageURL: urlString, score: 0)
            self.usecase.add(user: user)
        }
    }
}
