//
//  ViewController.swift
//  LocalAuthenticationSample
//
//  Created by 今枝 稔晴 on 2020/02/06.
//  Copyright © 2020 今枝 稔晴. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var faceIdDescriptionLabel: UILabel!
    
    enum AuthenticationState {
        case loggedin, loggedout
    }
    var state: AuthenticationState = .loggedout {
        didSet {
            headerView.backgroundColor = self.state == .loggedin ? .systemGreen : .systemGray
            button.backgroundColor = self.state == .loggedout ? .systemGreen : .systemGray
            faceIdDescriptionLabel.isHidden = state == .loggedin || context.biometryType != .faceID
        }
    }
    var context: LAContext = LAContext()

    override func viewDidLoad() {
        super.viewDidLoad()
        // これを実行しないと context.biometryType が有効にならないので一度実行
        context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
        state = .loggedout
    }

    @IBAction func didTabLoginButton(_ sender: Any) {
        
        guard state == .loggedout else {
            state = .loggedout
            return
        }
        
        context = LAContext()
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) {
            
            let reason = "パスワードを入力してください"
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, error in
                if success {
                    DispatchQueue.main.async { [unowned self] in
                        self.state = .loggedin
                    }
                } else if let laError = error as? LAError {
                    switch laError.code {
                    case .authenticationFailed:
                        break
                    case .userCancel:
                        break
                    case .userFallback:
                        break
                    case .systemCancel:
                        break
                    case .passcodeNotSet:
                        break
                    case .touchIDNotAvailable:
                        break
                    case .touchIDNotEnrolled:
                        break
                    case .touchIDLockout:
                        break
                    case .appCancel:
                        break
                    case .invalidContext:
                        break
                    case .notInteractive:
                        break
                    @unknown default:
                        break
                    }
                }
            }
        } else {
            // 生体認証ができない場合の認証画面表示など
        }
    }
}

