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
	let xPos : CGFloat = 30
	var yPos : CGFloat = 10
	
	// Dictionary of text fields and their respective descriptions
	var inputs : [String : UITextField] = [:]
	var errors : [String : UILabel] = [:]
	
	// Label for displaying result of computation
	@IBOutlet weak var resultLabel: UILabel!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		// Set title and result label initial value
		self.title = formula.title
		self.resultLabel.text = ""
		
		let scrollView = UIScrollView()
		scrollView.frame = CGRect(x: 0, y: 87, width: self.view.bounds.maxX, height: 390)
		scrollView.contentSize = CGSize(width: Int(view.bounds.maxX), height: (formula.inputs.count * 110) + 200)
		view.addSubview(scrollView)
		
		let image = UIImageView()
		image.frame = CGRect(x: self.view.bounds.midX - 100, y: yPos, width: 200, height: 200)
		image.image = UIImage(named: formula.imageName);
		scrollView.addSubview(image)
		
		var inputFirstResponder = false
		yPos+=160
        // Loop through formula's inputs and render them in the view
		for input in formula.inputs {
			yPos += 100 //Total width of field and labels

			// Init new text field and label
			let inputField = UITextField()
			let descriptionLabel = UILabel(), helpLabel = UILabel()

			// Set positioning of text field and label
			inputField.frame = CGRect(x: xPos, y: yPos, width: 150, height: 40)
			descriptionLabel.frame = CGRect(x: xPos, y: yPos - 45, width: 200, height: 40)
			helpLabel.frame = CGRect(x: xPos, y: yPos + 40, width: 350, height: 40)

			// Set the text of the label equal to the input's description
			descriptionLabel.text = input.key
			helpLabel.text = "\(input.key) field is required."
			helpLabel.textColor = .red
			helpLabel.isHidden = true

			// Text field styling
			inputField.layer.cornerRadius = 5
			inputField.layer.borderWidth = 1
			let leftPadding = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 40))
			inputField.leftView = leftPadding
			inputField.leftViewMode = .always

			// Keyboard configuration
			let keyboardToolBar: UIToolbar = UIToolbar()
			keyboardToolBar.barStyle = .default
			keyboardToolBar.items = [
				//UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(FormulaViewController.cancel)),
				UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
				UIBarButtonItem(title: "Calculate", style: .plain, target: self, action: #selector(FormulaViewController.calculate))
			]
			keyboardToolBar.sizeToFit()
			inputField.inputAccessoryView = keyboardToolBar
			inputField.keyboardType = .decimalPad
			
			if (!inputFirstResponder) {
				inputField.becomeFirstResponder()
			}
			inputFirstResponder = true

			// Add fields to the view
			scrollView.addSubview(inputField)
			scrollView.addSubview(descriptionLabel)
			scrollView.addSubview(helpLabel)

			// Add the text field to the local input dictionary
			inputs[input.value] = inputField
			errors[input.value] = helpLabel
		}
    }
	
	@objc func cancel() {
		view.endEditing(true)
	}
	
	@objc func calculate() {
		// Init new dictionary
		var intDictionary : [String : Double] = [:]
		
		// Flag for setting if there is a field that is empty
		var fieldEmpty = false
		
		// Loop through inputs and grab respective values
		for input in inputs {
			// Check if value exists
			if let value = Double(input.value.text!) {
				intDictionary[input.key] = value
				input.value.layer.borderColor = UIColor.black.cgColor
				errors[input.key]?.isHidden = true
			} else {
				fieldEmpty = true
				input.value.layer.borderColor = UIColor.red.cgColor
				errors[input.key]?.isHidden = false
			}
		}
		
		// If there is a field empty, dont try and calculate
		if (fieldEmpty) {
			return
		}
		
		// Use the expression of the formula and the grabbed values to evaluate the expression
		if var result = formula.expression.numericalExpression.expressionValue(with: intDictionary, context: nil) as? Double {
			result.round()
			print(result)
			resultLabel.text = "\(String(format: "%.0f", result)) \(formula.output)"
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
