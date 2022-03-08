//
//  AutoSignInVC.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/02/16.
//

import UIKit

class AutoSignInVC: BaseVC {
    
    // MARK: Properties
    let email: String = UserDefaults.standard.string(forKey: UserDefaults.Keys.Email) ?? ""
    let PW: String = UserDefaults.standard.string(forKey: UserDefaults.Keys.PW) ?? ""
    let refreshToken: String = UserDefaults.standard.string(forKey: UserDefaults.Keys.RefreshToken) ?? ""
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        requestAutoSignIn()
    }
}

// MARK: Network
extension AutoSignInVC {
    
    /// 자동로그인 요청하는 메서드
    private func requestAutoSignIn() {
        self.activityIndicator.startAnimating()
        SignAPI.shared.requestSignIn(email: email, PW: PW, deviceToken: UserDefaults.standard.string(forKey: UserDefaults.Keys.FCMTokenForDevice) ?? "") { networkResult in
            switch networkResult {
            case .success(let res):
                self.activityIndicator.stopAnimating()
                if let data = res as? SignInDataModel {
                    self.setUpUserdefaultValues(data: data)
                    self.setUserToken(accessToken: data.accesstoken, refreshToken: data.refreshtoken)
                    let nadoSunbaeTBC = NadoSunbaeTBC()
                    nadoSunbaeTBC.modalPresentationStyle = .fullScreen
                    self.present(nadoSunbaeTBC, animated: true, completion: {
                        nadoSunbaeTBC.selectedIndex = NotificationInfo.shared.isPushComes ? 2 : 0
                        NotificationInfo.shared.isPushComes = false
                    })
                }
            default:
                self.activityIndicator.stopAnimating()
                print("Failed Auto SignIn")
                guard let signInVC = self.storyboard?.instantiateViewController(withIdentifier: SignInVC.className) as? SignInVC else { return }
                signInVC.modalPresentationStyle = .fullScreen
                self.present(signInVC, animated: true, completion: nil)
            }
        }
    }
}
