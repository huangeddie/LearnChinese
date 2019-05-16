//
//  ChunkTableViewCell.swift
//  LearnChinese
//
//  Created by Eddie Huang on 5/16/19.
//  Copyright © 2019 Eddie Huang. All rights reserved.
//

import UIKit

class ChunkTableViewCell: UITableViewCell {
    @IBOutlet weak var chunk: UILabel!
    @IBOutlet weak var pinyin: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
