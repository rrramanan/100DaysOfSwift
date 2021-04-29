//
//  ViewController.swift
//  Project2
//
//  Created by R R on 16/12/20.
//
import NotificationCenter
import UIKit

class ViewController: UIViewController,UNUserNotificationCenterDelegate {

    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var totalTen = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "🏆", style: .plain, target: self, action:#selector(barbuttonTapped))
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestions()
        
        
        //project 21 challenge
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "📣", style: .plain, target: self, action: #selector(setNotification))
        
       
    }


    func askQuestions(action: UIAlertAction! = nil){
       //challenge..
        if totalTen == 10 {
            title = "Flag: \(countries[correctAnswer].uppercased())    Score: \(score)"
            totalTen = 0
            gameOver()
            score = 0
        }else{
            
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
            
            button1.setImage(UIImage(named: countries[0]), for: .normal)
            button2.setImage(UIImage(named: countries[1]), for: .normal)
            button3.setImage(UIImage(named: countries[2]), for: .normal)

            //title = countries[correctAnswer].uppercased()
            //challenge ..
            title = "Flag: \(countries[correctAnswer].uppercased())    Score: \(score)"
        }
        
    }
    
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title = ""
        totalTen += 1
        print(totalTen)
        

//        if sender.tag == correctAnswer {
//            title = "Correct"
//            score += 1
//            askQuestions()
//
//        }else{
//            title = "Wrong"
//            score -= 1
//
//            //challenge..
//            let ac = UIAlertController(title: "", message: "\(title)! That's the flag of \(countries[sender.tag].uppercased())", preferredStyle: .alert)
//            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestions))
//            present(ac, animated: true, completion: nil)
//        }

       // UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: []) {
            

        //challenge 
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: []) {
            sender.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)


        } completion: {  [weak self]  _ in

            sender.transform = .identity

            if sender.tag == self?.correctAnswer {
                title = "Correct"
                self?.score += 1
                self?.askQuestions()

            }else{
                title = "Wrong"
                self?.score -= 1

                //challenge..
                let ac = UIAlertController(title: "", message: "\(title)! That's the flag of \( self?.countries[sender.tag].uppercased() ?? "NA")", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: self?.askQuestions))
                self?.present(ac, animated: true, completion: nil)
            }
        }

      
//        let ac = UIAlertController(title: title, message: "Your Score is \(score)", preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestions))
//        present(ac, animated: true, completion: nil)
        
        
    }
    
    //challenge..
    func gameOver()  {
            let ac = UIAlertController(title: "Game Over", message: "Your Final Score is \(score)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: askQuestions))
            present(ac, animated: true, completion: nil)
    }
    
  @objc func barbuttonTapped() {
        let alert = UIAlertController(title: "Score", message: "Your current score is \(score)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    @objc func setNotification(){
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert,.badge,.sound]) { granted, error in
            if granted{
                print("granted")
                self.registerCategories()
                center.removeAllPendingNotificationRequests()
                
                let content = UNMutableNotificationContent()
                content.title = "Fun With Flags"
                content.body = "Play Fun With Flags daily to set your best score against Sheldon Cooper"
                content.sound = .default
                content.categoryIdentifier = "playflag"
                content.userInfo = ["flag":"let's play"]
                
                /*
                 //daily
                 let date = Date(timeIntervalSinceNow: 3600)
                 let triggerDaily = Calendar.current.dateComponents([.hour,.minute,.second,], from: date)
                 let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
                 */

                /*
                 //weekly - in weekdays
                 let date = Date(timeIntervalSinceNow: 3600)
                 let triggerWeekly = Calendar.current.dateComponents([.weekday, .hour, .minute, .second,], from: date)
                 let trigger = UNCalendarNotificationTrigger(dateMatching: triggerWeekly, repeats: true)
                 */
                
                var dateComponents = DateComponents()
                dateComponents.hour = 10
                dateComponents.minute = 52
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                center.add(request)
                
            }else{
                print("not granted")
            }
            
            if error != nil{
                print(error.debugDescription)
            }
        }
        
    }
    
    func registerCategories(){
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let launch = UNNotificationAction(identifier: "play", title: "Let's Play 😎", options: .foreground)
        let clear = UNNotificationAction(identifier: "clear", title: "🧘‍♀️ Nah 🧘", options: .destructive)
        
        let category = UNNotificationCategory(identifier: "playflag", actions: [launch,clear], intentIdentifiers: [], options: [])
        center.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let data = userInfo["flag"] as? String{
            print("data received \(data)")
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                print("default")
                
            case "play":
                print("play")
                
                
            case "clear":
                print("clear")
                
                
            default:
                break
            }
          completionHandler()
        }
        
    }
}

