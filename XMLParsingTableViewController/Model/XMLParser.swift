//
//  XMLParser.swift
//  XMLParsingTableViewController
//
//  Created by hp ios on 2/14/18.
//  Copyright © 2018 andiosdev. All rights reserved.
//

import Foundation

struct RSSItem {
    var title:String
    var description:String
    var pubDate:String
}

class FeedParser:NSObject,XMLParserDelegate
{
    private var rssItems:[RSSItem]=[]
    private var currentElement = ""
    private var currentTitle:String = ""
    {
        didSet
        {
            currentTitle = currentTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentDescription:String = ""
    {  didSet
        {
            currentDescription = currentDescription.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentPubDate:String = ""
    {   didSet
        {
            currentPubDate = currentPubDate.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var parserCompletionHandler : (([RSSItem])->Void)?
    
    func parseFeed(url:String, completionHandler: (([RSSItem])->Void)?)
    {
        self.parserCompletionHandler = completionHandler
        let request = URLRequest(url: URL(string:url)!)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request)
                {    (data, response, error) in
                    guard let data = data else {
                        if let error = error
                        {
                            print(error.localizedDescription)
                        }
                        return
                    }
                    print(data)
                    // parse our xml data
                    let parser = XMLParser(data: data)
                    parser.delegate = self
                    parser.parse()
                    
                    
                }
        task.resume()
        
        
    }
    // MARK: - xml parser delegate
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        currentElement = elementName
        if currentElement == "item"
        {
            currentTitle=""
            currentDescription=""
            currentPubDate=""
            
        }
  }
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        switch currentElement {
        case "title":
            currentTitle+=string
        case "description":
            currentDescription+=string
        case "pubDate":
            currentPubDate+=string
        default:
            break
        }
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item"
        {
            let rssItem = RSSItem(title: currentTitle,
                                  description: currentDescription,
                                  pubDate: currentPubDate)
            print(rssItem)
            self.rssItems.append(rssItem)
        }
    }
    func parserDidEndDocument(_ parser: XMLParser)
    {
        parserCompletionHandler?(rssItems)
    }
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error)
    {
        print(parseError.localizedDescription)
        
    }
    
}
