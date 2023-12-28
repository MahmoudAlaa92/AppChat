//
//  LoginViewController.swift
//  AppChat
//
//  Created by mahmoud on 15/10/2023.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    private let scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    
    private let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let emailField : UITextField = {
        let field = UITextField()
        
        field.autocapitalizationType = .none
        field.returnKeyType = .continue
        field.autocorrectionType = .no
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = " Email Adress.. "
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        
        return field
    }()
    
    private let passwordField : UITextField = {
        let field = UITextField()
        
        field.autocapitalizationType = .none
        field.returnKeyType = .done
        field.autocorrectionType = .no
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = " passord .. "
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.isSecureTextEntry = true
        
        return field
    }()
    
    private let logInbutton : UIButton = {
        let logInbutton = UIButton()
        
        logInbutton.tintColor = .white
        logInbutton.backgroundColor = .link
        logInbutton.setTitle("Login In", for: .normal)
        logInbutton.layer.cornerRadius = 12
        logInbutton.layer.masksToBounds = true
        logInbutton.titleLabel?.font = .systemFont(ofSize: 21, weight: .medium)
        
        return logInbutton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Log In"
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Regiser", style: .done, target: self, action: #selector(didTabRegisterButton))
        
        logInbutton.addTarget(self, action: #selector(LogInButtonTapped), for: .touchUpInside)
        
        emailField.delegate = self
        passwordField.delegate = self
        
        
        // Add sub view
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(logInbutton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = scrollView.width/3
        imageView.frame = CGRect(x:(scrollView.width-size)/2
                                , y: 20
                                , width: size
                                , height: size)
        
        emailField.frame = CGRect(x: 30
                                , y: imageView.bottom+10
                                , width: scrollView.width-60
                                , height: 51 )
        
        passwordField.frame = CGRect(x: 30
                                     , y: emailField.bottom+10
                                     , width: scrollView.width-60
                                   , height: 51 )
        
        logInbutton.frame = CGRect(x: 30
                                     , y: passwordField.bottom+15
                                     , width: scrollView.width-60
                                     , height: 51 )
        
    }
    
    @objc func didTabRegisterButton (){
        let vc = RegisterViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
        
    }
    @objc private func  LogInButtonTapped(){
        
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        guard let email = emailField.text ,let password = passwordField.text ,
              password.count >= 6 ,!email.isEmpty ,!password.isEmpty else {
            alertUserLoginError()
            return
        }
        
        //Firebase Log In
        
        Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!){ [weak self] authResult ,error in
            
            guard let strongSelf = self else{
                return
            }
            guard let result = authResult ,error == nil else{
                print("Error when signin with email \(email)")
                return
            }
            
            let user = result.user
            print("logged In  user\(user)")
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            
        }
    }
    
    func alertUserLoginError(){
        let alert = UIAlertController(title: "Woops", message: "Please enter all information ", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
}

extension LoginViewController : UITextFieldDelegate {
     
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }else if textField == passwordField {
            LogInButtonTapped()
        }
        return true
    }
}
