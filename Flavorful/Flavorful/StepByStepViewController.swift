//
//  StepByStepViewController.swift
//  Flavorful
//
//  Created by Slarve N. on 4/4/21.
//

import UIKit

class StepByStepViewController: UITableViewController {
    
    var recipe: Recipe!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
        tableView.rowHeight = 130
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return recipe.numbersArray?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return recipe.name
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "stepCell", for: indexPath) as? StepByStepCell
        else{return tableView.dequeueReusableCell(withIdentifier: "stepCell", for: indexPath)}

        // Configure the cell...
        cell.stepNumberLabel.text = "Step: \(recipe.numbersArray?[indexPath.row].description ?? "")"
        cell.instructionTextLabel.text = recipe.instructionsArray?[indexPath.row]

        return cell
    }


}
