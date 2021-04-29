//
//  ViewController.swift
//  Project21
//
//  Created by R R on 03/02/21.
//
import UserNotifications
import UIKit

class ViewController: UIViewController,UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
    }


    @objc func registerLocal(){
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert,.badge,.sound]) { granted,error in
            if granted{
                print("Yay!")
            }else{
                print("D'oh!")
            }
        }
    }
    
    @objc func scheduleLocal(flag: Bool){
        registerCategories()
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData":"fizzbuzz","flag":flag]
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
       // let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
       // let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false) <removed for challenge>
     
        print("flag: \(flag)")
        if flag{
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 86400, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }else{
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        
        
    }
    
    func registerCategories(){
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Tell me more", options: .foreground)
        let clear = UNNotificationAction(identifier: "clear", title: "clear", options: .destructive)
        // challenge 2
        let rml = UNNotificationAction(identifier: "rml", title: "Remind me later", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show,rml,clear], intentIdentifiers: [], options: [])
        
        center.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String{
            print("Custom data received \(customData)")
            print("aa : \(response.actionIdentifier)")
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                //user swiped to unlock
                print("default identifier")
                alertData(id: response.actionIdentifier)
                
            case "show":
                print("show more information")
                alertData(id: response.actionIdentifier)
                
            case UNNotificationDismissActionIdentifier:
                print("dismiss identifier ")
                alertData(id: response.actionIdentifier)
                
            case "clear":
                print("clear")
                alertData(id: response.actionIdentifier)
                
            case "rml":
                print("rml")
                alertData(id: response.actionIdentifier + "\n Will be notified in 86400 seconds")
                scheduleLocal(flag: true)
                
            default:
                break
            }
        }
        
        completionHandler()
    }
    
    //challenge 1
    func alertData(id actionID:String){
        let avc = UIAlertController(title: "Info", message: "Action Identifier: \(actionID)", preferredStyle: .alert)
        avc.addAction(UIAlertAction(title: "OK", style: .default))
        present(avc, animated: true)
        
    }
}

