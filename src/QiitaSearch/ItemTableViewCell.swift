//
//  ItemTableViewCell.swift
//  QiitaSearch
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    
    private var url: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
