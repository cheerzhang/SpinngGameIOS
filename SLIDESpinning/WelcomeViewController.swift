//
//  WelcomeViewController.swift
//  SLIDESpinning
//
//  Created by 张乐 on 4/4/18.
//  Copyright © 2018 Wayne Lai. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {
    
    let pat = "[8-9][0-9]{7}"
    var handle: AuthStateDidChangeListenerHandle?

    @IBOutlet weak var mobiletx: UITextField!
    @IBOutlet weak var signbtn: UIButton!
    
    @IBAction func signinfunc(_ sender: Any) {
        //input validation
        if let range = self.mobiletx.text?.range(of:pat, options: .regularExpression) {
            let result = self.mobiletx.text?.substring(with:range)
            if (self.mobiletx.text?.count == 8){
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "OtpVc") as! OtpViewController
                PhoneAuthProvider.provider().verifyPhoneNumber("+65" + self.mobiletx.text!, uiDelegate: nil) { (verificationID, error) in
                        if let error = error {
                            print(error.localizedDescription)
                            return
                        }
                        // Sign in using the verificationID and the code sent to the user
                        vc.mobileno = self.mobiletx.text!
                        vc.verificationID = verificationID!
                        let navi = UINavigationController(rootViewController: vc)
                        self.present(navi, animated: true, completion: nil)
                }
            }
            else{
                showAlertInCorrect( title:"Invalid Number!", message:"Number invalid1 please enter a valid number.")
            }
        }else{
            //count trial times
            showAlertInCorrect( title:"Invalid Number!", message:"Number invalid1 please enter a valid number.")
        }
        
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mobiletx.underlined()
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if Auth.auth().currentUser != nil {
                let user = Auth.auth().currentUser
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "BaseVc") as! BaseViewController
                vc.mobileno = (user?.phoneNumber)!
                //let vc = storyboard.instantiateViewController(withIdentifier: "TestchildVc") as! TestchildViewController
                self.present(vc, animated: true, completion: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func showAlertInCorrect( title:String, message:String ) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (act) in
            print(">>>> click ok.")
            self.mobiletx.text = ""
        }
        alertVC.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    //  set login trailed times
    /*
    if (UserDefaults.standard.object(forKey: "trailtimes2") as? Int) != nil{
    print("existed")
    }else{
    UserDefaults.standard.set(0,forKey: "trailtimes2")
    }
     
     let times = UserDefaults.standard.object(forKey: "trailtimes2") as! Int
     let t2 = times+1
     UserDefaults.standard.set(t2,forKey: "trailtimes2")
     print("print key value",UserDefaults.standard.object(forKey: "trailtimes2"))
    */

}
