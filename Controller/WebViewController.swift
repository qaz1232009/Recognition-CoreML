//
//  WebViewController.swift
//
//  Created by Collin on 2017/11/24.
//  Copyright © 2017年 AppCoda. All rights reserved.
//
import WebKit
import UIKit

class WebViewController: UIViewController {
    @IBOutlet var webView: WKWebView!
    
    var targetURL = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        if let url = URL(string:targetURL){
            let request = URLRequest(url:url)
            webView.load(request)
        }
        // Do any additional setup after loading the view.
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
