//
//  PostDetailTableViewCell.swift
//  FinalChallenge
//
//  Created by Evandro Henrique Couto de Paula on 23/09/16.
//  Copyright © 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import UIKit

class PostDetailTableViewCell: UITableViewCell {
    
    //Outlets
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var postTitleLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var publicationTimeLbl: UILabel!
    @IBOutlet weak var requestMsgLbl: UILabel!
    var postID: String = ""
    var userEmail: String = ""
    var userUID: String = ""
    
    @IBOutlet weak var buttonOption: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
