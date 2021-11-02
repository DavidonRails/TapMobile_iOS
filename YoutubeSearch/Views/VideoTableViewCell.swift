//
//  VideoTableViewCell.swift
//  YoutubeSearch
//
//  Created by Admin on 2021/11/2.
//

import UIKit
import WebKit

class VideoTableViewCell: UITableViewCell {

    @IBOutlet weak var webView: WKWebView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
