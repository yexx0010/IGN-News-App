//
//  MovieVController.swift
//  yexx_project
//
//  Created by Yulou Ye on 2015-04-06.
//  Copyright (c) 2015 Yulou Ye. All rights reserved.
//

import UIKit

class MovieVController: UITableViewController, NSXMLParserDelegate {
    
    
    
    var dataStore = NSMutableData()      // to store the complete rss feed
    var parser = NSXMLParser()
    
    var currentElement = ""         // contains the element currently parsed by NSXMLParser
    var processingItem : Bool?
    var itemsArray: [String] = []   // to store the parsed items from the feed
    
    var currentTitle = ""
    var processingTitle : Bool?
    var titlesArray: [String] = []
    
    var currentLink = ""
    var processingLink : Bool?
    var linksArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        processingItem = false
        processingTitle = false
        processingLink = false
        let urlPath: String = "http://feeds.ign.com/ign/movies-articles"
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        var url: NSURL = NSURL(string: urlPath)!
        var request: NSURLRequest = NSURLRequest(URL: url)
        var connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: true)!
        
        connection.start()
        
        
    } // viewDidLoad
    
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!){
        self.dataStore.appendData(data)
    }
    
    func connection(connection: NSURLConnection!, didFailWithError error: NSError!) {
        NSLog("Connection failed.\(error.localizedDescription)")
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!)
    {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        var results = NSString(data: dataStore, encoding: NSUTF8StringEncoding)
        
        // start the parser
        parser = NSXMLParser(data: dataStore)
        parser.delegate = self      // don't forget to set the delegate for the parser
        parser.parse()
        
    } // connectionDidFinishLoading
    
    
    
    
    
    func parser(parser: NSXMLParser!,didStartElement elementName: String!, namespaceURI: String!, qualifiedName : String!, attributes attributeDict: NSDictionary!) {
        
        if elementName == "item" {
            processingItem = true
        }
        
        if elementName == "title" {
            processingTitle = true
        }
        
        if elementName == "link" {
            processingLink = true
        }
        
    } // didStartElement
    
    
    func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
        
        if elementName == "item"{
            itemsArray.append(currentElement)
            currentElement = ""
            processingItem = false
        }
        
        if elementName == "title"{
            titlesArray.append(currentTitle)
            currentTitle = ""
            processingTitle = false
        }
        
        if elementName == "link"{
            linksArray.append(currentLink)
            currentLink = ""
            processingLink = false
        }
        
    } //didEndElement
    
    
    func parser(parser: NSXMLParser!, foundCharacters string: String!) {
        if (processingItem!){ // we know this bool variable is never nil!
            currentElement += string
        }
        
        if (processingTitle!){
            currentTitle += string
        }
        
        if (processingLink!){
            currentLink += string
        }
        
        
    } // foundCharacters
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let indexPath = tableView.indexPathForCell(sender as UITableViewCell)!
        let vc = segue.destinationViewController as ShowMovieVController
        vc.index = indexPath.row // pass the quesion number, so we can get the right answer
        vc.linksArray = linksArray
    }
    
    
    
    func parser(parser: NSXMLParser!, parseErrorOccurred parseError: NSError!) {
        NSLog("failure error: %@", parseError)
    }
    
    func parserDidEndDocument(parser: NSXMLParser!) {
        tableView.reloadData()    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return titlesArray.count - 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = titlesArray[indexPath.row + 2]
        
        return cell
    }
}