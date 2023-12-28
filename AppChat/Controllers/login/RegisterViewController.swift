//
//  RegisterViewController.swift
//  AppChat
//
//  Created by mahmoud on 15/10/2023.
//

import UIKit
import PhotosUI
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    
    private let scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(systemName:"person.circle.fill")
        imageView.tintColor = .gray
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        
        return imageView
    }()
    
    private let emailField : UITextField = {
        let emailField = UITextField()
        emailField.placeholder = " Enter your Email .."
        emailField.autocapitalizationType = .none
        emailField.autocorrectionType = .no
        emailField.backgroundColor = .white
        emailField.returnKeyType = .continue
        emailField.layer.cornerRadius = 12
        emailField.layer.borderWidth = 1
        emailField.layer.borderColor = UIColor.lightGray.cgColor
        emailField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        emailField.leftViewMode = .always
        
        return emailField
    }()
    
    private let firstName : UITextField = {
        let firstName = UITextField()
        firstName.placeholder = " First Name"
        firstName.autocapitalizationType = .none
        firstName.autocorrectionType = .no
        firstName.backgroundColor = .white
        firstName.returnKeyType = .continue
        firstName.layer.cornerRadius = 12
        firstName.layer.borderWidth = 1
        firstName.layer.borderColor = UIColor.lightGray.cgColor
        firstName.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        firstName.leftViewMode = .always
        
        return firstName
    }()
    
    private let lastName : UITextField = {
        let lastName = UITextField()
        lastName.placeholder = " Last Name"
        lastName.autocapitalizationType = .none
        lastName.autocorrectionType = .no
        lastName.backgroundColor = .white
        lastName.returnKeyType = .continue
        lastName.layer.cornerRadius = 12
        lastName.layer.borderWidth = 1
        lastName.layer.borderColor = UIColor.lightGray.cgColor
        lastName.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        lastName.leftViewMode = .always
        
        return lastName
    }()
    
    private let passwordField : UITextField = {
        let passwordField = UITextField()
        passwordField.placeholder = " Enter your password .."
        passwordField.backgroundColor = .white
        passwordField.layer.cornerRadius = 12
        passwordField.layer.borderWidth = 1
        passwordField.returnKeyType = .done
        passwordField.layer.borderColor = UIColor.lightGray.cgColor
        passwordField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        passwordField.leftViewMode = .always
        passwordField.autocapitalizationType = .none
        passwordField.autocorrectionType = .no
        passwordField.isSecureTextEntry = true
        return passwordField
    }()
    
    private let registerButton : UIButton = {
        let registerButton = UIButton()
        registerButton.tintColor = .white
        registerButton.backgroundColor = .systemGreen
        registerButton.setTitle("Register", for: .normal)
        registerButton.layer.cornerRadius = 12
        registerButton.layer.masksToBounds = true
        registerButton.titleLabel?.font = .systemFont(ofSize: 21, weight: .medium)
        
        return registerButton
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(scrollView)
        
        firstName.delegate = self
        lastName.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        
        
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for:.touchUpInside )

        // add sub View
        
        scrollView.addSubview(firstName)
        scrollView.addSubview(lastName)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(registerButton)
        
        imageView.isUserInteractionEnabled = true
        scrollView.isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTabChangeProfilePicture))
        imageView.addGestureRecognizer(gesture)
        
    }
    
    @objc private func didTabChangeProfilePicture() {
        presentPhotoActionSheet()
    }
    
  
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        scrollView.frame = view.bounds
        let size = scrollView.width/3
        
        imageView.frame = CGRect(x:(scrollView.width-size)/2
                               , y:20
                               , width:size
                               , height:size )
        
        imageView.layer.cornerRadius = imageView.width/2
        
        firstName.frame = CGRect(x:30
                               , y:imageView.bottom + 10
                               , width:scrollView.width-60
                               , height:51 )
        
        lastName.frame = CGRect(x:30
                              , y:firstName.bottom + 10
                              , width:scrollView.width-60
                              , height:51 )
        
        emailField.frame = CGRect(x:30
                                , y:lastName.bottom + 10
                                , width:scrollView.width-60
                                , height:51 )
        
        passwordField.frame = CGRect(x:30
                                   , y:emailField.bottom + 10
                                   , width:scrollView.width - 60
                                   , height:51 )
        
        registerButton.frame = CGRect(x:30
                                    , y:passwordField.bottom + 10
                                    , width:scrollView.width - 60
                                    , height:51 )

    }
    
    @objc private func  registerButtonTapped(){
        
        firstName.resignFirstResponder()
        lastName.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
     
        guard let firsName = firstName.text,
              let lastName = lastName.text,
              let email = emailField.text,
              let password = passwordField.text,
              !firsName.isEmpty,
              !lastName.isEmpty,
              !email.isEmpty,   
              password.count >= 6
        else{
            alertUserRegisterError()
            return
        }
        
        //Firebase Log In
        
        DatabaseManager.shared.userExists(email: email) { [weak self] Exist in
            guard let strongSelf = self else{
                return
            }
            guard !Exist else {
                // user already exist
                strongSelf.alertUserRegisterError(message: "Email address already exist.")
                return
            }
            
            Auth.auth().createUser(withEmail: email, password: password){  authResult ,error in
               
                guard  authResult != nil ,error == nil else {
                    print("Error when creating user")
                    return
                }
                
                DatabaseManager.shared.insertUser(with: chatAppUser(
                    firstName: firsName,
                    lastName: lastName,
                    emailAdress: email))
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            }
        }
       
    }
    
    func alertUserRegisterError(message: String = "Please enter all information to create new account."){
        let alert = UIAlertController(title: "Woops",
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
}

extension RegisterViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstName{
            lastName.becomeFirstResponder()
        }else if textField == lastName {
            emailField.becomeFirstResponder()
        }
        else if textField == emailField {
            passwordField.becomeFirstResponder()
        }else if textField == passwordField{
            registerButtonTapped()
        }
        return true
    }
}

extension RegisterViewController : UIImagePickerControllerDelegate ,PHPickerViewControllerDelegate ,UINavigationControllerDelegate  {
  
    
    func presentPhotoActionSheet (){
        let actionSheet = UIAlertController(title: "Profile Picture",
                                      message: "How to place the image",
                                      preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo ", style: .default ,handler: { [weak self] _ in
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo ", style: .default ,handler: { [weak self] _ in
            self?.presentPhotoPicker()
        }))
        present(actionSheet,animated: true)

    }
    
    func presentCamera(){
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc,animated: true)
    }
    
    func presentPhotoPicker(){

        var vc = PHPickerConfiguration()
        vc.filter = .images
        let picker = PHPickerViewController(configuration: vc)
        picker.delegate = self
        picker.isEditing = true
        present(picker,animated: true)
        
    }
    
     func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
         picker.dismiss(animated: true)
        
         if let selectedImage = results.first?.itemProvider, selectedImage.canLoadObject(ofClass: UIImage.self){
             
             
             selectedImage.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                 DispatchQueue.main.async {
                     guard let self = self ,let image = image as? UIImage ,error == nil else { return }
                     self.imageView.image = image
                 }
             }
         }
     }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else {
               return
           }
          imageView.image = image
    }
  
}

