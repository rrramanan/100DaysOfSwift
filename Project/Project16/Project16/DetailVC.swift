//
//  DetailVC.swift
//  Project16
//
//  Created by R R on 20/01/21.
//

import UIKit
import WebKit

class DetailVC: UIViewController {

    var webView: WKWebView!
    var getcapitalString: String?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let str = getcapitalString else { return }
        
        webView.load(URLRequest(url:URL(string: "https://en.wikipedia.org/wiki/" + str)!))
        webView.allowsBackForwardNavigationGestures = true
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
