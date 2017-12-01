//
//  TestimonyTableViewCell.swift
//  FinalChallenge
//
//  Created by Evandro Henrique Couto de Paula on 07/10/16.
//  Copyright © 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import UIKit
import Cosmos

class TestimonyTableViewCell: UITableViewCell {
    @IBOutlet weak var userTestemonyImage: UIImageView!
    @IBOutlet weak var testemonyUserName: UILabel!
    @IBOutlet weak var testemonyTitle: UILabel!
    @IBOutlet weak var testemonyMessage: UILabel!
    @IBOutlet weak var evaluationView: UIView!
    @IBOutlet weak var cosmosView: CosmosView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
