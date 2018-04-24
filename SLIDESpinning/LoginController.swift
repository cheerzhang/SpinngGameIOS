//
//  LoginController.swift
//  SLIDESpinning
//
//  Created by 张乐 on 12/3/18.
//  Copyright © 2018 Wayne Lai. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {

    var handle: AuthStateDidChangeListenerHandle?
    
    @IBOutlet weak var mobiletx: UITextField!
    @IBOutlet weak var vidbtn: UIButton!
    @IBOutlet weak var vidtx: UITextField!
    @IBOutlet weak var loginbtn: UIButton!
    @IBOutlet weak var viewstorebtn: UIButton!
    @IBOutlet weak var welcomtx: UILabel!
    @IBOutlet weak var signoffbtn: UIButton!
    @IBOutlet weak var manageCbtn: UIButton!
    @IBOutlet weak var viewreportbtn: UIButton!
    
    var verificationID = ""
    
    @IBAction func getVID(_ sender: Any) {
        if (self.mobiletx.text != ""){
            PhoneAuthProvider.provider().verifyPhoneNumber("+65" + self.mobiletx.text!, uiDelegate: nil) { (verificationID, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                // Sign in using the verificationID and the code sent to the user
                self.verificationID = verificationID!
                self.loginbtn.isEnabled = true
            }
        }else{
            print("mobile error")
        }
    }
    
    @IBAction func loginfuc(_ sender: Any) {
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: self.verificationID,
            verificationCode: self.vidtx.text!)
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                // ...
                print("error when login with verificationID ",error)
                return
            }
            // User is signed in
            // ...
            print("login with phone succeeded.")
            self.vidtx.isHidden = true
            self.loginbtn.isHidden = true
            self.loginbtn.isEnabled = false
            self.viewstorebtn.isHidden = false
            self.viewstorebtn.isEnabled = true
            self.manageCbtn.isHidden = false
            self.manageCbtn.isEnabled = true
            self.viewreportbtn.isHidden = false
            self.viewreportbtn.isEnabled = true
        }
    }
    
    
    @IBAction func viewStorefunc(_ sender: Any) {
    }
    
    @IBAction func manageCfunc(_ sender: Any) {
    }
    
    @IBAction func viewreportfunc(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ReportView") as! ReportViewController
        present(vc, animated: true, completion: nil)
    }
    @IBAction func signofffunc(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print ("sign off succeed.",Auth.auth().currentUser?.phoneNumber ?? "<#default value#>")
            self.welcomtx.isHidden = true
            self.welcomtx.text = ""
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // init
        self.verificationID = ""
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if Auth.auth().currentUser != nil {
                let user = Auth.auth().currentUser
                self.loginbtn.isEnabled = false
                self.vidbtn.isEnabled = false
                self.mobiletx.isHidden = true
                self.vidtx.isHidden = true
                self.vidbtn.isHidden = true
                self.loginbtn.isHidden = true
                self.viewstorebtn.isHidden = false
                self.viewstorebtn.isEnabled = true
                self.welcomtx.isHidden = false
                self.welcomtx.text = "welcom , "+(user?.phoneNumber)!
                self.signoffbtn.isHidden = false
                self.signoffbtn.isEnabled = true
                self.manageCbtn.isHidden = false
                self.manageCbtn.isEnabled = true
                self.viewreportbtn.isHidden = false
                self.viewreportbtn.isEnabled = true
            }else{
                self.mobiletx.isHidden = false
                self.vidbtn.isHidden = false
                self.vidbtn.isEnabled = true
                self.loginbtn.isEnabled = false
                self.viewstorebtn.isEnabled = false
                self.vidtx.isHidden = false
                self.loginbtn.isHidden = false
                self.viewstorebtn.isHidden = true
                self.signoffbtn.isHidden = true
                self.signoffbtn.isEnabled = false
                self.manageCbtn.isHidden = true
                self.manageCbtn.isEnabled = false
                self.viewreportbtn.isHidden = true
                self.viewreportbtn.isEnabled = false
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

}
