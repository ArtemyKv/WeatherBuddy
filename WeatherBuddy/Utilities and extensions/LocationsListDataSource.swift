//
//  LocationsTableViewDiffableDataSource.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 18.10.2022.
//

import Foundation
import UIKit

class LocationsListDataSource: UITableViewDiffableDataSource<LocationsListViewModel.Section, LocationsListCellViewModel> {
    
    var reorderingHandler: ((_ sourceIndex: Int, _ destinationIndex: Int) -> (Void))?
    var deletionHandler: ((_ index: Int) -> (Void))?
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 0 ? false : true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        self.reorderingHandler?(sourceIndexPath.row, destinationIndexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.deletionHandler?(indexPath.row)
        }
    }
    
}
