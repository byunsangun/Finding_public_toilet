//
//  AuthenticationViewController.swift
//  Lab05
//
//  Created by 변상운 on 2020/10/24.
//  Copyright © 2020 sangun. All rights reserved.
//

import Foundation
import UIKit
import KakaoSDKAuth
import KakaoSDKUser

class AuthenticationViewController: UIViewController {
    
    var toiletIndexSent = ""
    var toiletIndex = ""
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toiletIndex = toiletIndexSent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let loginState = self.defaults.bool(forKey: "loginState")
        
        if(loginState == true){
            setUserInfo()
        }
    }
    
    @IBAction func authenticationKakao(_ sender: Any) {
        
        AuthApi.shared.loginWithKakaoAccount {(oauthToken, error) in
           if let error = error {
             print(error)
           }
           else {
            print("loginWithKakaoAccount() success.")
            
            //do something
            _ = oauthToken
            let accessToken = oauthToken?.accessToken
            
            //카카오 로그인을 통해 사용자 토큰을 발급 받은 후 사용자 관리 API 호출
            self.setUserInfo()
           }
        }

        
    }
    
    func setUserInfo() {
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            }
            else {
                print("me() success.")
                //do something
                _ = user
                let ReviewViewController = self.storyboard?.instantiateViewController(identifier: "ReviewViewController") as! ReviewViewController
                ReviewViewController.toiletIndexSent = self.toiletIndex
                
                if let name = user?.kakaoAccount?.profile?.nickname {
                    ReviewViewController.myNameSent = name
                }
                
                if let url = user?.kakaoAccount?.profile?.profileImageUrl,
                    let data = try? Data(contentsOf: url) {
                    ReviewViewController.myImageSent = UIImage(data: data)!
                }
                
                var loginState = self.defaults.bool(forKey: "loginState")
                loginState = true
                self.defaults.set(loginState, forKey: "loginState")
                
                self.navigationController?.pushViewController(ReviewViewController, animated: true)
                
            }
        }
    }
    
}
