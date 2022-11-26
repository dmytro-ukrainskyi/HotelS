//
//  RoomsTableViewController.swift
//  HotelS
//
//  Created by dimas on 06.06.2022.
//

import UIKit

class RoomsTableViewController: UITableViewController {
    
    //MARK: - Public properties
    let roomsManager = RoomsManager()
            
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        loadRooms()
    }

}

