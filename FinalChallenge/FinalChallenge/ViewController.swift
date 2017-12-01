//
//  ViewController.swift
//  FinalChallenge
//
//  Created by Evandro Henrique Couto de Paula on 14/09/16.
//  Copyright © 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth
import SocketIO
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginLbl: UILabel!
    
    let loginButton = FBSDKLoginButton()
    
    let services = Services()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        
        self.view.backgroundColor = Color().backgroundStandardColor
        self.loginLbl.font = FontLato().blackFont(size: 30.0)
        
        
//        if let user = FIRAuth.auth()?.currentUser  {
//            
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "tabController") as! UITabBarController
//            
//            self.present(vc, animated: true, completion: nil)
//            
//        } else {
//            let loginButton = FBSDKLoginButton ()
//            loginButton.delegate = self
//            loginButton.center = self.view.center
//            loginButton.readPermissions = ["public_profile","email"]
//            self.view.addSubview(loginButton)
//        }
        
        if FIRAuth.auth()?.currentUser != nil {
//            if let user = FIRAuth.auth()?.currentUser {
//                if !user.isEmailVerified {
//                    let alertVC = UIAlertController(title: "Erro", message: "Desculpe. Seu email ainda não foi verificado. Deseja que seja enviado outro email para \(self.emailField.text).", preferredStyle: .alert)
//                    let alertActionOkay = UIAlertAction(title: "OK", style: .default) {
//                        (_) in
//                        user.sendEmailVerification(completion: nil)
//                    }
//                    let alertActionCancel = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
//                    
//                    alertVC.addAction(alertActionOkay)
//                    alertVC.addAction(alertActionCancel)
//                    self.present(alertVC, animated: true, completion: nil)
//                }else {
//                    
//                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    let vc = storyboard.instantiateViewController(withIdentifier: "tabController") as! UITabBarController
//                    self.present(vc, animated: true, completion: nil)
//                    
//                }
//                
//            }
            
            
        } else {
            //let loginButton = FBSDKLoginButton ()
            loginButton.delegate = self
            loginButton.frame.size.width = (self.view.frame.width) * 0.8
            loginButton.frame.size.height = 44
            loginButton.readPermissions = ["public_profile","email"]
            self.view.addSubview(loginButton)
        }
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if FBSDKAccessToken.current() != nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "tabController") as! UITabBarController
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    override func viewDidLayoutSubviews() {

        let fbGap = (self.view.frame.height) * 0.4
        let point = CGPoint(x: self.view.frame.midX, y: ((self.view.frame.midY) + fbGap))
        loginButton.center = point
        let border = CALayer()
        let width = CGFloat(0.5)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: emailField.frame.size.height - width, width:  emailField.frame.size.width, height: emailField.frame.size.height)
        
        border.borderWidth = width
        emailField.layer.addSublayer(border)
        emailField.layer.masksToBounds = true
        
        
        let border2 = CALayer()
        let width2 = CGFloat(0.5)
        border2.borderColor = UIColor.darkGray.cgColor
        border2.frame = CGRect(x: 0, y: passwordField.frame.size.height - width, width:  passwordField.frame.size.width, height: passwordField.frame.size.height)
        
        border2.borderWidth = width2
    
        
        passwordField.layer.addSublayer(border2)
        passwordField.layer.masksToBounds = true
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapSignIn(_ sender: AnyObject) {
        let email = emailField.text
        let password = passwordField.text
        FIRAuth.auth()?.signIn(withEmail: email!, password: password!) { (user, error) in
            if let error = error {
                if let errCode = FIRAuthErrorCode(rawValue: error._code) {

                    switch errCode{
                        case .errorCodeOperationNotAllowed:
                            let alertController = UIAlertController(title: "Erro", message: "Email não cadastrado", preferredStyle: .alert)
                            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alertController.addAction(defaultAction)
                            self.present(alertController, animated: true, completion: nil)
                            print(error.localizedDescription)
                    case .errorCodeWrongPassword:
                        let alertController = UIAlertController(title: "Erro", message: "Senha incorreta", preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                        print(error.localizedDescription)
                    case .errorCodeUserDisabled:
                        let alertController = UIAlertController(title: "Erro", message: "Usuário foi desabilitado", preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                        print(error.localizedDescription)
                    default:
                        let alertController = UIAlertController(title: "Erro", message: "Usuário inválido", preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                        print(error.localizedDescription)
                }
                }
                print(error.localizedDescription)
                return
            }
            else{
                
                if !(user?.isEmailVerified)! {
                    let alertVC = UIAlertController(title: "Erro", message: "Desculpe. Seu email ainda não foi verificado. Deseja que seja enviado outro email para \(self.emailField.text!).", preferredStyle: .alert)
                    let alertActionOkay = UIAlertAction(title: "OK", style: .default) {
                        (_) in
                        user?.sendEmailVerification(completion: nil)
                    }
                    let alertActionCancel = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
                    
                    alertVC.addAction(alertActionOkay)
                    alertVC.addAction(alertActionCancel)
                    self.present(alertVC, animated: true, completion: nil)
                }else {
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "tabController") as! UITabBarController
                    self.present(vc, animated: true, completion: nil)
                    
                }

            }
            
        }
    }
    
    
    //btn back action
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}

extension ViewController: FBSDKLoginButtonDelegate {
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
        } else if result.isCancelled {
            print("User canceled permission")
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "tabController") as! UITabBarController
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            
            FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
                if error != nil {
                    print(error?.localizedDescription ?? "VIEW CONTROLLER: error in facebook login")
                } else {
                    let ref = FIRDatabase.database().reference(withPath: "private/users")

                    print("USER LOGGED IN FIREBASE")
                    print("VIEWCONTROLLER: credential \(credential)")
                    let newUser = ref.child((user?.uid)!)
                    
                    // 4
                    newUser.setValue(["nickname": user?.displayName ?? "Sem Nome",
                                      "provider": "Facebook",
                                      "mail": user?.email ?? "Sem Email",
                                      "location": "Não Localizado",
                                      "evaluation": NSNumber(value: 0.0)])
                    self.services.saveUserData(user!)


                }
            })
            
            self.present(vc, animated: true, completion: nil)

            if result.grantedPermissions.contains("email"){
                print("TOKEN: \(result.token)")
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User Logged out")
    }
}

