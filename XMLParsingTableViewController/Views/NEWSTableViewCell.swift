//
//  NEWSTableViewCell.swift
//  XMLParsingTableViewController
//
//  Created by hp ios on 2/14/18.
//  Copyright © 2018 andiosdev. All rights reserved.
//

import UIKit

enum CellState
{
    case expanded
    case collapsed
}

class NEWSTableViewCell: UITableViewCell {

   
    @IBOutlet weak var newsDescription: UILabel!
    {
        didSet
        {
            newsDescription.numberOfLines = 3
        }
    }
    @IBOutlet weak var newHeadLine: UILabel!
    @IBOutlet weak var newsPublicationDate: UILabel!
    
    var item :RSSItem!
    {
        didSet
        {
            newHeadLine.text = item.title
            newsDescription.text = item.description
            newsPublicationDate.text = item.pubDate
        }
    }
}
