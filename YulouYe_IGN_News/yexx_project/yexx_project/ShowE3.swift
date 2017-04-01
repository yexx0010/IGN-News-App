//
//  ShowE3.swift
//  yexx_project
//
//  Created by Yulou Ye on 2015-04-06.
//  Copyright (c) 2015 Yulou Ye. All rights reserved.
//

import UIKit

class ShowE3: UIViewController {
    

    @IBOutlet weak var webView: UIWebView!
    
    var index = 0
    var linksArray : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = linksArray[index + 2]
        
        let requestURL = NSURL(string:url)
        let request = NSURLRequest(URL: requestURL!)
        webView.scalesPageToFit = true
        webView.loadRequest(request)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
}
