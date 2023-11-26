//
//  ViewController.swift
//  GoogleDrive
//
//  Created by Шахова Анастасия on 24.11.2023.
//

import UIKit
import GoogleSignIn
import GoogleAPIClientForREST

final class LoginViewController: UIViewController {

    private let loginButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    @objc private func loginButtonTapped() {
        if GIDSignIn.sharedInstance()?.currentUser != nil {
            GIDSignIn.sharedInstance()?.signOut()
        } else {
            GIDSignIn.sharedInstance().delegate = self
            GIDSignIn.sharedInstance()?.presentingViewController = self
            GIDSignIn.sharedInstance().scopes = [kGTLRAuthScopeDriveReadonly]
            GIDSignIn.sharedInstance()?.signIn()
        }
    }
    
    private func fetchFiles(_ user: GIDGoogleUser) {
        let cloudFilesViewController = FilesInfoViewController()
        cloudFilesViewController.service.authorizer = user.authentication.fetcherAuthorizer()
        self.navigationController?.pushViewController(cloudFilesViewController, animated: true)
    }
}

//MARK: - SetupConstraints
extension LoginViewController {
    
    private func initialSetup() {
        view.backgroundColor = .white
        navigationItem.title = "GoogleDrive"
        
        loginButton.setTitle("Login with google drive", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.setTitleColor(.gray, for: .highlighted)
        loginButton.layer.cornerRadius = 10
        loginButton.layer.masksToBounds = true
        loginButton.backgroundColor = .darkGray
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: 280).isActive = true
    }
}

//MARK: - GIDSignInDelegate
extension LoginViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let _ = error {
            AlertManager.showBasicAlert(on: self, title: "Sign Error", message: error.localizedDescription)
        } else {
            fetchFiles(user)
        }
    }
}
