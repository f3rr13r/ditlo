//
//  Authentication.swift
//  Ditlo
//
//  Created by Harry Ferrier on 1/17/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import Foundation

// protocols
protocol AuthInfoProtocol {
    var emailAddress: String { get set }
    var password: String { get set }
}

// structs
struct LoginInfo: AuthInfoProtocol {
    var emailAddress: String
    var password: String
}

struct SignupInfo: AuthInfoProtocol {
    var emailAddress: String
    var name: String
    var password: String
}

struct AuthResponse {
    var success: Bool
    var errorMessage: String?
}
