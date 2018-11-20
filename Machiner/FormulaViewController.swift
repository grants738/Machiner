//
//  FormulaViewController.swift
//  Machiner
//
//  Created by Grant Savage on 11/18/18.
//  Copyright © 2018 Grant Savage. All rights reserved.
//
// 	Handles the rendering and calculation handling of a selected formula

import UIKit

class FormulaViewController: UIViewController {
	// Selected formula
	var formula: Formula!
	
	// Global position values for rendering text fields
	let xPos : CGFloat = 50
	var yPos : CGFloat = 80
	
	// Dictionary of text fields and their respective descriptions
	var inputs : [String : UITextField] = [:]
	
	// Label for displaying result of computation
	@IBOutlet weak var resultLabel: UILabel!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		// Set title and result label initial value
		self.title = formula.title
		self.resultLabel.text = ""
		
        // Loop through formula's inputs and render them in the view
		for input in formula.inputs {
			yPos += 90
			
			// Init new text field and label
			let tf = UITextField()
			let label = UILabel()
			
			// Set positioning of text field and label
			tf.frame = CGRect(x: xPos, y: yPos, width: 200, height: 40)
			label.frame = CGRect(x: xPos, y: yPos - 45, width: 200, height: 40)
			
			// Set the text of the label equal to the input's description
			label.text = input.key
			
			// Text field styling
			tf.layer.cornerRadius = 5
			tf.layer.borderWidth = 1
			
			// Keyboard configuration
			tf.keyboardType = .decimalPad
			
			// Add fields to the view
			self.view.addSubview(tf)
			self.view.addSubview(label)
			
			// Add the text field to the local input dictionary
			inputs[input.value] = tf
		}
		
    }
	
	// Handle the calculation button event
	@IBAction func calculate(_ sender: Any) {
		// Init new dictionary
		var intDictionary : [String : Double] = [:]
		
		// Flag for setting if there is a field that is empty
		var fieldEmpty = false
		
		// Loop through inputs and grab respective values
		for input in inputs {
			// Check if value exists
			if let value = Double(input.value.text!) {
				intDictionary[input.key] = value
			} else {
				fieldEmpty = true
				input.value.layer.borderColor = UIColor.red.cgColor
			}
		}
		
		// If there is a field empty, dont try and calculate
		if (fieldEmpty) {
			return
		}

		// Use the expression of the formula and the grabbed values to evaluate the expression
		if let result = formula.expression.numericalExpression.expressionValue(with: intDictionary, context: nil) as? Double {
			resultLabel.text = String(result)
			view.endEditing(true)
		} else {
		  	print("Calculation Failed")
		}
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
