//
//  OtpViewController.swift
//  SLIDESpinning
//
//  Created by 张乐 on 4/4/18.
//  Copyright © 2018 Wayne Lai. All rights reserved.
//

import UIKit
import Firebase

class OtpViewController: UIViewController {

    var mobileno = ""
    var verificationID = ""
    var handle: AuthStateDidChangeListenerHandle?
    
    @IBOutlet weak var mobilelb: UILabel!
    @IBOutlet weak var firsttx: UITextField!
    @IBOutlet weak var secondtx: UITextField!
    @IBOutlet weak var thirdtx: UITextField!
    @IBOutlet weak var fourthtx: UITextField!
    @IBOutlet weak var fifthtx: UITextField!
    @IBOutlet weak var sixthtx: UITextField!
    
    @IBOutlet weak var backbtn: UIButton!
    @IBOutlet weak var resendbtn: UIButton!
    
    
    @IBAction func firstfunc(_ sender: Any) {
        self.secondtx.becomeFirstResponder()
    }
    @IBAction func secondfunc(_ sender: Any) {
        self.thirdtx.becomeFirstResponder()
    }
    @IBAction func thirdfunc(_ sender: Any) {
        self.fourthtx.becomeFirstResponder()
    }
    @IBAction func fourthfunc(_ sender: Any) {
        self.fifthtx.becomeFirstResponder()
    }
    @IBAction func fifthfunc(_ sender: Any) {
        self.sixthtx.becomeFirstResponder()
    }
    @IBAction func sixthfunc(_ sender: Any) {
        //login and jump to next page
        self.backbtn.isEnabled = false
        self.resendbtn.isEnabled = false
        let vid = self.firsttx.text! + self.secondtx.text! + self.thirdtx.text! + self.fourthtx.text! + self.fifthtx.text! + self.sixthtx.text!
        print("vid,",vid)
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: self.verificationID,
            verificationCode: vid )
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                // ...
                print("error when login with verificationID ",error)
                self.backbtn.isEnabled = true
                self.resendbtn.isEnabled = true
                return
            }
            // User is signed in
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DashboardVc") as! DashboardViewController
        vc.mobileno = self.mobileno
        self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func resendotpfunc(_ sender: Any) {
        PhoneAuthProvider.provider().verifyPhoneNumber("+65" + self.mobileno, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                print(error.localizedDescription)
                self.showAlertInCorrect( title:"OTP wrong", message:"Please enter again." )
                return
            }
            // Sign in using the verificationID and the code sent to the user
            self.verificationID = verificationID!
            self.firsttx.text = ""
            self.secondtx.text = ""
            self.thirdtx.text = ""
            self.fourthtx.text = ""
            self.fifthtx.text = ""
            self.sixthtx.text = ""
            self.firsttx.becomeFirstResponder()
            }
    }
    
    @IBAction func backfunc(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WelcomVc") as! WelcomeViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mobilelb.text = self.mobileno
        self.firsttx.becomeFirstResponder()
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if Auth.auth().currentUser != nil {
                let user = Auth.auth().currentUser
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "BaseVc") as! BaseViewController
                vc.mobileno = (user?.phoneNumber)!
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
        }
        alertVC.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alertVC, animated: true, completion: nil)
        }
    }

}
