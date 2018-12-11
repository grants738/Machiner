//
//  FormulasTableViewController.swift
//  Machiner
//
//  Created by Grant Savage on 11/18/18.
//  Copyright © 2018 Grant Savage. All rights reserved.
//
// 	Handles the data retrieval, storage, and selction of formulas

import UIKit

class FormulasTableViewController: UITableViewController {
	// Pre-defined formulas
	var formulas:[Formula] = [
		Formula(
			id: 1,
			title: "RPM based on SFM",
			expression: "(sfm)/(3.14159265359*0.08333*td)",
			inputs: ["Surface Feet per Minute" : "sfm", "Tool Diameter" : "td"],
			output: "RPM",
			imageName: ""
		),
		Formula(
			id: 2,
			title: "Feed Rate",
			expression: "flutes * fpt * rpm",
			inputs: ["Number of flutes" : "flutes", "Feed per Tooth" : "fpt", "RPM" : "rpm"],
			output: "Inches per Minute",
			imageName: "ChipThinningDiagram"
		),
		Formula(id: 3, title: "Multiply", expression: "a * b", inputs: ["Height" : "a", "Width" : "b"], output: "", imageName: ""),
		Formula(id: 4, title: "Divide", expression: "a / b", inputs: ["A" : "a", "B" : "b"], output: "", imageName: "")
	]

	// Perform tableView configuration and formula retrieval from storage
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
		
		// Table configuration
		self.tableView.isEditing = true
		self.tableView.allowsSelectionDuringEditing = true
		
		// Get property encoded formulas from storage
		if let storedFormulas = UserDefaults.standard.object(forKey: "formulas") as? Data {
			// Decode formulas and set globally available formulas to decoded formulas
			if let decodedFormulas = try? PropertyListDecoder().decode(Array<Formula>.self, from: storedFormulas) {
				print("Stored formulas found")
				formulas = decodedFormulas
			} else {
				print("Error decoding formulas")
			}
		} else {
			print("No stored formulas")
		}
    }

    // MARK: - Table view data source

	// Return count of formulas
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return formulas.count
    }
	
	// Render each cell in the table
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "formulaCell", for: indexPath)

		let formula = formulas[indexPath.row]
		cell.textLabel?.text = formula.title

        return cell
    }
	
	// Handle re-sorting of formulas
	override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		let movedObject = formulas[sourceIndexPath.row]
		formulas.remove(at: sourceIndexPath.row)
		formulas.insert(movedObject, at: destinationIndexPath.row)
		
		UserDefaults.standard.set(try? PropertyListEncoder().encode(formulas), forKey: "formulas")
		
		print("Formula order saved")
	}
	
	// Editing mode configuration
	override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
		return .none
	}
	
	// Editing mode configuration
	override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
		return false
	}

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected formula to the new view controller.
		if (segue.identifier == "formulaSegue") {
			let indexPath = tableView.indexPathForSelectedRow
			let index = indexPath?.row
			let formulaViewController = segue.destination as! FormulaViewController
			formulaViewController.formula = formulas[index!]
		}
    }
}
