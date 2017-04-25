//
//  EntradaCell.swift
//  Reddit
//
//  Created by Augusto Valdez Barrios on 24/4/17.
//  Copyright © 2017 isy. All rights reserved.
//

import UIKit

class EntradaCell: UITableViewCell {
    
    @IBOutlet weak var thumbnail: UIImageView!
    
    @IBOutlet weak var titulo: UILabel!
    
    @IBOutlet weak var fecha: UILabel!
    
    @IBOutlet weak var autor: UILabel!
    
    @IBOutlet weak var comentarios: UILabel!
    
    @IBOutlet weak var subreddit: UILabel!
    
    @IBOutlet weak var entradaNro: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
