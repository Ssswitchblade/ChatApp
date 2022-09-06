//
//  ProfileVC.swift
//  ChatAppProject
//
//  Created by Admin on 12.06.2022.
//

import UIKit
import FirebaseAuth
class ProfileVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupConstraints()
        logOutBtn.addTarget(self, action: #selector(logOutBtnTpd), for: .touchUpInside)
    }
    
    @objc private func logOutBtnTpd() {
        
         
        
        do {
            try FirebaseAuth.Auth.auth().signOut()
            
            let vc = LoginViewController() 
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
            
        }
        catch {
            print("Error sign out")
        }
    }
    
    //UI setup
    private let logOutBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Log out", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor( UIColor.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate ([
            logOutBtn.widthAnchor.constraint(equalToConstant: 300),
            logOutBtn.heightAnchor.constraint(equalToConstant: 32),
            logOutBtn.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            logOutBtn.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor, constant: -300)
        ])
    }
        
    private func setupViews() {
        view.addSubview(logOutBtn)
    }
}
