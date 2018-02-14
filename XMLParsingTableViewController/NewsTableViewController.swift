//
//  NewsTableViewController.swift
//  XMLParsingTableViewController
//
//  Created by hp ios on 2/14/18.
//  Copyright © 2018 andiosdev. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController {

    private var rssItems:[RSSItem]?
    private var CellState:[CellState]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 155.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        fetchData()
        
       
    }
    func fetchData()
    {
        let feedParser = FeedParser()
        feedParser.parseFeed(url: "https://developer.apple.com/news/rss/news.rss")
        {
            (rssItemsArray) in
            self.rssItems = rssItemsArray
            print(self.rssItems ?? "nothing")
            self.CellState = Array(repeating: .collapsed ,count: (self.rssItems?.count)!)
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
                self.tableView.reloadSections(IndexSet(integer: 0), with: .left)
            }
        }
        
    }

   
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let rssItems = rssItems else {
            return 0
        }
        return rssItems.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? NEWSTableViewCell
        if let item = rssItems?[indexPath.row]
        {
            cell?.item = item
            cell?.selectionStyle = .none
            
            if let cellState = CellState
            {
                cell?.newsDescription.numberOfLines = (cellState[indexPath.row] == .expanded) ? 0 : 3
            }
        }
        return cell!
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! NEWSTableViewCell
        tableView.beginUpdates()
        CellState?[indexPath.row] = (cell.newsDescription.numberOfLines == 0 ) ? .expanded : .collapsed
        cell.newsDescription.numberOfLines = (cell.newsDescription.numberOfLines==0) ? 3 : 0
        tableView.endUpdates()
        
    }

  

}
