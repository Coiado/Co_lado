//
//  ForgotPasswordViewController.swift
//  FinalChallenge
//
//  Created by Evandro Henrique Couto de Paula on 24/11/16.
//  Copyright © 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import UIKit
import Firebase

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = Color().backgroundStandardColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func forgetPasswordAction(_ sender: Any) {
        self.recoverPassword()
    }
    
    func recoverPassword() {
        if !((self.emailTxtField.text?.isEmpty)!) {
            FIRAuth.auth()?.sendPasswordReset(withEmail: emailTxtField.text!, completion: { (error) in
                if error == nil {
                    
                    let alert = UIAlertController(title: NSLocalizedString("Mensagem Enviada", comment: "Message Send"), message: NSLocalizedString("Email para recuperação de senha enviado", comment: "recover password email sent"), preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default, handler: nil)
                    
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                    
                } else {
                    
                    let alert = UIAlertController(title: NSLocalizedString("Erro", comment: "Error"), message: NSLocalizedString("Aconteceu um erro durante o envio da mensagem tente novamente", comment: "error during message sent, try again"), preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default, handler: nil)
                    
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }else {
            
            let alert = UIAlertController(title: NSLocalizedString("Campo vazio", comment: "Empty field"), message: NSLocalizedString("O campo de email não pode estar vazio", comment: "recover password email sent"), preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default, handler: nil)
            
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.emailTxtField.resignFirstResponder()
    }

}
