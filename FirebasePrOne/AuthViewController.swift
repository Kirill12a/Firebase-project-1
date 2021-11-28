//
//  AuthViewController.swift
//  FirebasePrOne
//
//  Created by Kirill Drozdov on 28.11.2021.
//

import UIKit
import Firebase
class AuthViewController: UIViewController, UITextFieldDelegate {
    
    var signup: Bool = true{
        willSet{ // когда знач меняется
            if newValue{ // вкл рег
                tiitileLabel.text = "Регестрация"
                nameField.isHidden  = false
                enterButton.setTitle("Войти", for: .normal)

            }else{
                tiitileLabel.text = "Вход"
                nameField.isHidden = true
                enterButton.setTitle("Регестрация", for: .normal)
            }
        }
    }

    @IBOutlet weak var tiitileLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
    }
    @IBAction func switchLogin(_ sender: UIButton) {
        signup.toggle()
    }
    
    func showAlert(){
        let alert = UIAlertController(title: "Оишбка", message: "Заполни все поля", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}


extension AuthViewController{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let email = emailField.text!
        let name = nameField.text!
        let password = passwordField.text!
       
        if (signup){
            if (!email.isEmpty && !name.isEmpty && !password.isEmpty){
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    if error == nil{
                        if let result = result{
                            print(result.user.uid)
                            let ref = Database.database().reference().child("users")
                            ref.child(result.user.uid).updateChildValues(["name" : name,"email" : email])
                            self.dismiss(animated: true, completion: nil)

                        }
                    }
                }
            }else{
             showAlert()
            }
        }else{
            if (!email.isEmpty  && !password.isEmpty){
                Auth.auth().signIn(withEmail: email,password: password) { result, error in
                    if error == nil{
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }else{
                showAlert()
            }
        }
        
        return true
    }
}
