//
//  ViewController.swift
//  LoginSample
//
//  Created by Thomas on 2016. 2. 22..
//  Copyright © 2016년 Thomas. All rights reserved.
//

import UIKit
import XCGLogger

class ViewController: UIViewController {
    
    @IBOutlet weak var loginStatusView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doLogin() {
        LoginController.instance.login(self) { [weak self] (userInfo, error) -> Void in
            if let userInfo = userInfo {
                XCGLogger.defaultInstance().debug("login success. \(userInfo)")
                self?.loginStatusView.text = "\(LoginController.instance.name()) login success.\n\n\(userInfo))"
            } else {
                XCGLogger.defaultInstance().debug("login failed. \(error)")
                self?.loginStatusView.text = "\(LoginController.instance.name()) login failed.\n\n\(error))"
            }
        }
    }
    
    func login() {
        if LoginController.instance.isLogin() {
            LoginController.instance.logout({ [weak self] (_, _) -> Void in
                self?.doLogin()
                })
            
            return
        }
        
        doLogin()
    }
    
    @IBAction func loginViaKakao(sender: AnyObject) {
        LoginController.setup(.Kakao)
        login()
    }
    
    @IBAction func loginViaNaver(sender: AnyObject) {
        LoginController.setup(.Naver)
        login()
    }
    
    @IBAction func loginViaFacebook(sender: AnyObject) {
        LoginController.setup(.Facebook)
        login()
    }
    
    @IBAction func loginViaInstagram(sender: AnyObject) {
        LoginController.setup(.Instagram)
        login()
    }
    
    @IBAction func loginViaGoogle(sender: AnyObject) {
        LoginController.setup(.Google)
        login()
    }
    
}

