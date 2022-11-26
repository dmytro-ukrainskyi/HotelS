//
//  OrderCellTableViewCell.swift
//  HotelS
//
//  Created by dimas on 24.05.2022.
//

import UIKit

class OrderCell: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var orderCellView: UIView?
    
    @IBOutlet weak var orderNameLabel: UILabel?
    
    @IBOutlet weak var roomIdLabel: UILabel?
    
    @IBOutlet weak var dateOrderedLabel: UILabel?
    
    @IBOutlet weak var datePickedLabel: UILabel?
    
    @IBOutlet weak var orderStatusLabel: UILabel?
    
    @IBOutlet weak var orderCostLabel: UILabel?
    
    @IBOutlet weak var orderCommentLabel: UILabel?
    
    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        //TODO: Configure the view for the selected state
    }
    
}
