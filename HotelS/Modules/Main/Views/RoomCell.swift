//
//  RoomTableViewCell.swift
//  HotelS
//
//  Created by dimas on 06.06.2022.
//

import UIKit

protocol RoomCellDelegate: AnyObject {
    func showCheckOutConfirmationAlertFor(room: Room)
}

class RoomCell: UITableViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var roomCellView: UIView!
    
    @IBOutlet weak var roomNumberLabel: UILabel!
    
    @IBOutlet weak var roomBillLabel: UILabel!
    
    //MARK: - Public properties
    weak var delegate: RoomCellDelegate?
    
    var room: Room?
    
    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    //MARK: - IBActions
    @IBAction func checkOutButtonTapped(_ sender: UIButton) {
        delegate?.showCheckOutConfirmationAlertFor(room: room!)
    }
    
}
