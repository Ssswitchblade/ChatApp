//
//  RegisterViewController.swift
//  ChatAppProject
//
//  Created by Admin on 05.06.2022.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        
        firstNameField.delegate = self
        lastNameField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        registerBtn.addTarget(self, action: #selector(regBtnTpd), for: .touchUpInside)
        
        title = "Create account"
        view.backgroundColor = .white
    }
    
    @objc private func regBtnTpd() {
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        guard let firstName = firstNameField.text, let lastName = lastNameField.text,
              let email = emailTextField.text, let password = passwordTextField.text,
              !firstName.isEmpty, !lastName.isEmpty, !email.isEmpty, !password.isEmpty,
              password.count >= 6 else {
            logInUserError(message: "Please enter all information")
            return
        }
        
        DatabaseManager.shared.validateNewUser(with: email, completion: { [weak self] exists in
            guard let strongSelf = self else { return }
            guard !exists else {
                //User alredy exists
                print("errr")
                strongSelf.logInUserError(message: "This user already exists!")
                return
            }
            
            //Firebase create user
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { [weak self] authResult, error in
                guard let result = authResult, error == nil else {
                    print("Error creating a user")
                    return
                }
                
                UserDefaults.standard.setValue(email, forKey: "email")
                UserDefaults.standard.setValue("\(firstName) \(lastName)", forKey: "name")
                
                DatabaseManager.shared.insertUser(with: ChatAppUser(firstName: firstName, lastName: lastName, email: email))
                
                strongSelf.navigationController?.dismiss(animated: true)
            })
        })
        
    }
    
    private func logInUserError(message: String) {
        let alert = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(action)
        present(alert, animated: true)
        
    }
    
    //UI Setup
    private let imageUser: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.fill")
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let firstNameField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "First name..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let lastNameField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Last name..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let emailTextField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Email Address..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let passwordTextField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Password..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        field.translatesAutoresizingMaskIntoConstraints = false
        field.isSecureTextEntry = true
        return field
    }()
    
    private let registerBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
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
            firstNameField.widthAnchor.constraint(equalToConstant: 300),
            firstNameField.heightAnchor.constraint(equalToConstant: 32),
            firstNameField.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            firstNameField.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor, constant: -150)
        ])
        
        NSLayoutConstraint.activate ([
            lastNameField.widthAnchor.constraint(equalToConstant: 300),
            lastNameField.heightAnchor.constraint(equalToConstant: 32),
            lastNameField.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            lastNameField.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor, constant: -100)
        ])
        
        NSLayoutConstraint.activate ([
            emailTextField.widthAnchor.constraint(equalToConstant: 300),
            emailTextField.heightAnchor.constraint(equalToConstant: 32),
            emailTextField.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            emailTextField.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor, constant: -50)
        ])
        
        NSLayoutConstraint.activate ([
            passwordTextField.widthAnchor.constraint(equalToConstant: 300),
            passwordTextField.heightAnchor.constraint(equalToConstant: 32),
            passwordTextField.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            passwordTextField.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate ([
            registerBtn.widthAnchor.constraint(equalToConstant: 300),
            registerBtn.heightAnchor.constraint(equalToConstant: 32),
            registerBtn.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            registerBtn.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor, constant: 50)
        ])
        
        NSLayoutConstraint.activate ([
            imageUser.widthAnchor.constraint(equalToConstant: 120),
            imageUser.heightAnchor.constraint(equalToConstant: 120),
            imageUser.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            imageUser.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor, constant: -250)
        ])
    }
    
    private func setupViews() {
        view.addSubview(imageUser)
        view.addSubview(firstNameField)
        view.addSubview(lastNameField)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(registerBtn)
    }
}

extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
        switch textField {
        case firstNameField:
            lastNameField.becomeFirstResponder()
        case lastNameField:
            emailTextField.becomeFirstResponder()
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            regBtnTpd()
        default:
            print("Error")
        }
        return true 
    }
}
