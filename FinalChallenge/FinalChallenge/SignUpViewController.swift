//
//  Sign-InViewController.swift
//  FinalChallenge
//
//  Created by Lucas Coiado Mota on 9/15/16.
//  Copyright © 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmpasswordField: UITextField!
    @IBOutlet weak var switchControl: UISwitch!
    @IBOutlet weak var signUpButton: UIButton!
    
    let services = Services()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = Color().backgroundStandardColor
        self.signUpButton.isEnabled = false
        self.switchControl.isOn = false

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func switchValueChange(_ sender: Any) {
        if switchControl.isOn {
            self.signUpButton.isEnabled = true
        }else {
            self.signUpButton.isEnabled = false
        }
    }
    
    


    

    
    @IBAction func createAccount(_ sender: AnyObject) {
        let username = usernameField.text
        let email = emailField.text
        let password = passwordField.text
        let confirmpassword = confirmpasswordField.text
        
        if username != "" && password != "" && confirmpassword != ""  {
            
            if password == confirmpassword {
                if (password?.characters.count)! >= 6 {
                    
                    self.services.singUp(username!, mail: email!, password: password!, completion: { (bool, error) in
                        if bool {
                            let alert = UIAlertController(title: NSLocalizedString("Email de confirmação enviado", comment: "email of confimation was sent"), message: NSLocalizedString("Email enviado para \(email!). Valide o email para acessar a aplicação", comment: "mail sent to"), preferredStyle: UIAlertControllerStyle.alert)
                            //let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let vc = storyboard.instantiateViewController(withIdentifier: "selectionOption") as! SelectOptionViewController
                                self.present(vc, animated: true, completion: nil)
                                
                            })
                            alert.addAction(okAction)
                            self.present(alert, animated: true, completion: nil)
                            
                        } else {
                            
                            if let errorType = FIRAuthErrorCode(rawValue: (error?._code)!) {
                                switch errorType{
                                case FIRAuthErrorCode.errorCodeEmailAlreadyInUse:
                                    let alert = UIAlertController(title: NSLocalizedString("Email já cadastrado", comment: "email already in use"), message: NSLocalizedString("O email digitado já foi cadastrado", comment: "The typed email is already in use"), preferredStyle: UIAlertControllerStyle.alert)
                                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                    alert.addAction(okAction)
                                    self.present(alert, animated: true, completion: nil)
                                case FIRAuthErrorCode.errorCodeInvalidEmail:
                                    let alert = UIAlertController(title: NSLocalizedString("Email inválido", comment: "invalid Email"), message: NSLocalizedString("O email digitado é inválido", comment: "fail during the message sent"), preferredStyle: UIAlertControllerStyle.alert)
                                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                    alert.addAction(okAction)
                                    self.present(alert, animated: true, completion: nil)
                                    
                                    //TODO: handle other errors
                                    
                                default:
                                    let alert = UIAlertController(title: NSLocalizedString("Erro", comment: "Error"), message: NSLocalizedString("Aconteceu um erro inesperado", comment: "unespected error"), preferredStyle: UIAlertControllerStyle.alert)
                                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                    alert.addAction(okAction)
                                    self.present(alert, animated: true, completion: nil)
                                }
                            }
                            
                            
                            
                            let alert = UIAlertController(title: NSLocalizedString("Email de confirmação não enviado", comment: "email of confimation was not sent"), message: NSLocalizedString("Falha no envio da mensagem", comment: "fail during the message sent"), preferredStyle: UIAlertControllerStyle.alert)
                            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alert.addAction(okAction)
                            self.present(alert, animated: true, completion: nil)
                            
                            
                        }
                    })
                    
                } else {
                    
                    let alert = UIAlertController(title: NSLocalizedString("Senha muito curta", comment: "password is too short"), message: NSLocalizedString("A senha deve possuir no mínimo 6 caracteres", comment: "The password must be 6 characters long or more"), preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                    
                }
            

                
                
                

                
            } else {
                
                let alert = UIAlertController(title: NSLocalizedString("As senhas não conferem", comment: "Defferent password"), message: NSLocalizedString("As senhas digitadas são diferentes", comment: "the typed password are different"), preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
            
        }else {
            print ("SIGNUPCONTROLLER: ONE OR ALL OF THE FIELDS IS/ARE EMPTY")
            let alert = UIAlertController(title: NSLocalizedString("Campo vazio", comment: "Empty Field"), message: NSLocalizedString("Todos os campos devem ser preenchidos", comment: "All the fields must be fill"), preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)

        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.usernameField.resignFirstResponder()
        self.emailField.resignFirstResponder()
        //self.phoneField.resignFirstResponder()
        self.passwordField.resignFirstResponder()
        self.confirmpasswordField.resignFirstResponder()
        self.view.endEditing(true)

    }
    
 

    

}
