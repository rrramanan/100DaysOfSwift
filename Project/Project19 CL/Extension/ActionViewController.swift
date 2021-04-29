//
//  ActionViewController.swift
//  Extension
//
//  Created by R R on 28/01/21.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    
    @IBOutlet var script: UITextView!
    @IBOutlet var tableView: UITableView!
    
    var pageTitle = ""
    var pageURL = ""
    
    var addScriptDict = [String:Any]()
    var scriptKey = [String]()
    var scriptValue = [Any]()
    var scriptCounter = 0
    var urlSource: URL!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
       
        //challenge
        let LB1 = UIBarButtonItem(title: "Load", style: .plain, target: self, action: #selector(loadScript))
        let LB2 = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addScript))
        let LB3 = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clean))
        navigationItem.leftBarButtonItems = [LB1,LB2,LB3]
        
        
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem{
            if let itemProvider = inputItem.attachments?.first{
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String, options: nil) { [weak self] (dict, error) in
                    guard let itemDictionary = dict as? NSDictionary else {return}
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else {return}
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    
                    //challenge 2
                    if let urlString = self?.pageURL{
                        self!.urlSource = URL(string: urlString)!
                        print(self!.urlSource.host!)
                    }
                    
                    DispatchQueue.main.async {
                        self?.title = self?.pageTitle
                        if let loadScript = UserDefaults.standard.value(forKey: self!.urlSource.host!){
                            self!.script.text = loadScript as? String
                        }else{
                            print("no defaults")
                        }
                    }
                }
            }
        }
        
        
        tableView.delegate = self
        tableView.dataSource = self
    
        
        
    }

    @IBAction func done() {
        
        if script.text.isEmpty{
            let defaults = UserDefaults.standard
            defaults.set("alert(document.title) : visited this page already", forKey: urlSource.host!)
        }else{
            let defaults = UserDefaults.standard
            defaults.set(script.text, forKey: urlSource.host!)
        }
        
       let item = NSExtensionItem()
       let argument: NSDictionary = ["customJavaScript": script.text as Any]
       let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
       let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
       item.attachments = [customJavaScript]
       extensionContext?.completeRequest(returningItems: [item])
    }
    
    @objc func adjustForKeyboard(notification: Notification){
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, to: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification{
            script.contentInset = .zero
        }else{
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        script.scrollIndicatorInsets = script.contentInset
        
        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
        
    }
    
    //challenge 1
    @objc func loadScript(){
        
        let avc = UIAlertController(title: "Load", message: "Load the script", preferredStyle: .actionSheet)
        avc.addAction(UIAlertAction(title: "Web Title", style: .default, handler: { [weak self] action in
            
            let item = NSExtensionItem()
            let argument: NSDictionary = ["customJavaScript": "alert(document.title)"]
            let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
            let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
            item.attachments = [customJavaScript]
            self?.extensionContext?.completeRequest(returningItems: [item])
        }))
        avc.addAction(UIAlertAction(title: "Time/Date", style: .default, handler: { [weak self] action in
            let item = NSExtensionItem()
            let argument: NSDictionary = ["customJavaScript": "alert(new Date())"]
            let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
            let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
            item.attachments = [customJavaScript]
            self?.extensionContext?.completeRequest(returningItems: [item])

        }))
        avc.addAction(UIAlertAction(title: "Lucky Number", style: .default, handler: { [weak self] action in
            let item = NSExtensionItem()
            let argument: NSDictionary = ["customJavaScript": "alert(Math.floor((Math.random() * 10) + 1))"]
            let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
            let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
            item.attachments = [customJavaScript]
            self?.extensionContext?.completeRequest(returningItems: [item])

        }))
        avc.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        present(avc, animated: true)
        
    }
    
    //challenge 3
    @objc func addScript(){
        
        if script.text.isEmpty{
            return
        }
        
        let av = UIAlertController(title: "Title", message: "Add script title", preferredStyle: .alert)
        av.addTextField()
        av.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] action in
            
            guard let txf = av.textFields?[0].text else {return}

            self?.addScriptDict.removeAll()
            self?.scriptCounter += 1
            let string = String(self!.scriptCounter)
            if self!.script.text.isEmpty{
                self?.addScriptDict[string] = "alert(document.title)"
            }else{
                self?.addScriptDict[string] = self?.script.text
            }
            for (_,value) in self!.addScriptDict{
                self?.scriptKey.append("Script: \(txf)")
                self?.scriptValue.append(value)
            }
            let index = IndexPath(row: self!.scriptKey.count - 1, section: 0)
            self?.tableView.insertRows(at: [index], with: .automatic)
            
        }))
        av.addAction(UIAlertAction(title: "Nah", style: .destructive))
        present(av, animated: true)
    }
    
    @objc func clean(){
        script.text = ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scriptKey.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = scriptKey[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        script.text = ""
        script.text = (scriptValue[indexPath.row] as? String)
    }
    
}
