//
//  AuthenticationHelperMethods.swift
//  Ditlo
//
//  Created by Harry Ferrier on 1/17/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import Foundation

func isSignUpInfoValid(with signUpInfo: SignupInfo) -> Bool {
    if !signUpInfo.emailAddress.isEmpty && !signUpInfo.name.isEmpty && !signUpInfo.password.isEmpty && signUpInfo.emailAddress.isValidEmail() {
        return true
    } else {
        return false
    }
}

func isLogInInfoValid(with logInInfo: LoginInfo) -> Bool {
    if !logInInfo.emailAddress.isEmpty && !logInInfo.password.isEmpty && logInInfo.emailAddress.isValidEmail() {
        return true
    } else {
        return false
    }
}

func isForgotPasswordEmailAddressValid(with emailAddress: String) -> Bool {
    return !emailAddress.isEmpty && emailAddress.isValidEmail()
}
