//
//  DetailViewController.swift
//  Project19-21 CL
//
//  Created by R R on 05/02/21.
//

import UIKit

class DetailViewController: UIViewController,UITextViewDelegate {
  
    @IBOutlet var toolbar: UIToolbar!
    @IBOutlet var notesTV: UITextView!
    var rowID: Int?
    var getNotesBody: String?
    
    var doneBarButton: UIBarButtonItem! = nil
    var shareBarButton: UIBarButtonItem! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
        shareBarButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done))
        //navigationItem.rightBarButtonItems = [shareBarButton, doneBarButton]
        navigationItem.setRightBarButtonItems([shareBarButton], animated: true)
    
        notesTV.delegate = self
    
        guard let notes = getNotesBody else {return}
        notesTV.text = notes
        
        guard let rid = rowID else {return}
        print("rid \(rid)")
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        notesTV.endEditing(true)
    }
    
    @objc func done(){
        notesTV.endEditing(true)
    }
    
    @objc func share(){
        if notesTV.text.isEmpty{ return }
        guard let text = notesTV.text else { return }
        let share = UIActivityViewController(activityItems: [text], applicationActivities: [])
        present(share, animated: true)
    }
    
    
    @IBAction func trashAction(_ sender: Any) {
        let vc = ViewController.self
        notesTV.text = ""
        if let row = rowID  {
            vc.loadNotes.remove(at: row)
            save()
        }
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func composeAction(_ sender: Any) {
        if let row = rowID  {
            print("row  \(row)")
            saveNotes()
            save()
            rowID = nil
            notesTV.text = ""
        }else{
            notesTV.text = ""
        }
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        print("should e")
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("ended")
        saveNotes()
        save()
        navigationItem.setRightBarButtonItems([shareBarButton], animated: true)
    }
   
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        print("should b")
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("begin editing")
        navigationItem.setRightBarButtonItems([shareBarButton,doneBarButton], animated: true)
    }
    
    func save(){
        let vc = ViewController.self
        let jsonEncoder = JSONEncoder()
       
        if let savedData = try? jsonEncoder.encode(vc.loadNotes){
            print("save")
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "notesdata")
           // print("save \(vc.loadNotes)")
        }else{
            print("Failed !!")
        }
    }
    
    func saveNotes(){
        guard let r1 =   notesTV.position(from: notesTV.beginningOfDocument, offset:80) else {return}//80
        guard let range = notesTV.textRange(from: notesTV.beginningOfDocument, to: r1) else {return}
        guard let titleText = notesTV.text(in: range) else {return}

        let titleContent = titleText
     
        let notesArea = Notes(title: titleText, content: notesTV.text)
       // print("notesArea \(notesArea)")
        
        let vc = ViewController.self
       
        if let row = rowID  {
            print("save old row")
            vc.loadNotes[row].title = titleContent
            vc.loadNotes[row].content = notesTV.text
        }else{
            print("save new row")
            vc.loadNotes.append(notesArea)
          //  print("spot \(vc.loadNotes)")
        }
    }
    
    
    @objc func adjustForKeyboard(notification: Notification){
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, to: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification{
            notesTV.contentInset = .zero
        }else{
            notesTV.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom - 40, right: 0)
        }
        
        notesTV.scrollIndicatorInsets = notesTV.contentInset
        
        let selectedRange = notesTV.selectedRange
        notesTV.scrollRangeToVisible(selectedRange)

    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
