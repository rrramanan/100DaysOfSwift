//
//  ViewController.swift
//  Project28
//
//  Created by R R on 23/02/21.
//
import LocalAuthentication
import UIKit

class ViewController: UIViewController {

    @IBOutlet var secret: UITextView!
    //challenge
    var doneBarButton: UIBarButtonItem!
    var settingsBarButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Nothing to see here"
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
        
        //challenge
        doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done))
        settingsBarButton = UIBarButtonItem(title: "🔑", style: .plain, target: self, action: #selector(addPassword))
    }
    
    //challenge
    @objc func done(){
        saveSecretMessage()
    }
    
    //challenge
   @objc func addPassword(){
        let ac = UIAlertController(title: "Enter your password", message: nil, preferredStyle: .alert)
        ac.addTextField { textField in
            textField.isSecureTextEntry = true
        }
        ac.addAction(UIAlertAction(title: "Add", style: .default, handler: { _ in
            guard let text = ac.textFields?[0].text else {return}
            if text.isEmpty{return}
            KeychainWrapper.standard.set(text, forKey: "passphrase")
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .default))
        present(ac, animated: true)
    }
    
    //challenge
    func enterPassword(){
        let ac = UIAlertController(title: "Unlock", message: "Enter your password", preferredStyle: .alert)
        ac.addTextField { textField in
            textField.isSecureTextEntry = true
        }
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            guard let text = ac.textFields?[0].text else {return}
            if text.isEmpty{return}
            
            if let keychainValue = KeychainWrapper.standard.string(forKey: "passphrase"){
                if text == keychainValue{
                    self?.unlockSecretMessage()
                }else{
                    self?.wrongPassword()
                }
            }else{
                self?.noPassword()
            }
            
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .default))
        present(ac, animated: true)
    }
    
    //challenge
    func wrongPassword(){
        let ac = UIAlertController(title: "Wrong Password", message: "Try again", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Try again", style: .default,handler: { [weak self] _ in
            self?.enterPassword()
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .default))
        present(ac, animated: true)
    }
    
    //challenge
    func noPassword(){
        let ac = UIAlertController(title: "No Password found", message: "Add new password after unlocking via biometry", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

    @IBAction func authenticateTapped(_ sender: Any) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success,authenticationError in
                DispatchQueue.main.async {
                    if success{
                        self?.unlockSecretMessage()
                    }else{
                        let ac = UIAlertController(title: "Authentication Failed", message: "You could not be verified: please try again", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        ac.addAction(UIAlertAction(title: "Try password", style: .default, handler: { _ in
                            self?.enterPassword() //challenge
                        }))
                        self?.present(ac, animated: true)
                    }
                }
            }
            
        }else{
            let ac = UIAlertController(title: "Biometery unavailable", message: "Your device is not configured for biometric authentication", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
        
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue =
                notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        
        let keyboardScreenEnd = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEnd, to: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification{
            secret.contentInset = .zero
        }else{
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom:keyboardViewEndFrame.height - view.safeAreaInsets.bottom , right: 0)
            
        }
        
        secret.scrollIndicatorInsets = secret.contentInset
        
        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
        
    }
    
    func unlockSecretMessage(){
        secret.isHidden = false
        title = "Secret Stuff!"
        navigationItem.rightBarButtonItem = doneBarButton  //challenge
        navigationItem.leftBarButtonItem = settingsBarButton  //challenge
        secret.text = KeychainWrapper.standard.string(forKey: "SecretMessage") ?? ""
    }
    
    
   @objc func saveSecretMessage(){
        guard secret.isHidden == false else {return}
        
        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
        secret.resignFirstResponder()
        secret.isHidden = true
        navigationItem.rightBarButtonItem = nil  //challenge
        navigationItem.leftBarButtonItem = nil  //challenge
        title = "Nothing to see here"
    }
    
    
}

