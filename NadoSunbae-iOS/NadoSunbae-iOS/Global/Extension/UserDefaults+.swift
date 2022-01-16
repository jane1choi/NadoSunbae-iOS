//
//  UserDefaults+.swift
//  NadoSunbae-iOS
//
//  Created by 황지은 on 2022/01/05.
//

import Foundation

extension UserDefaults {
    
    /// UserDefaults key value가 많아지면 관리하기 어려워지므로 enum 'Keys'로 묶어 관리합니다.
    enum Keys {
        static var FCMTokenForDevice = "FCMTokenForDevice"
    }
}
