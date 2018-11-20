//
//  Formula.swift
//  Machiner
//
//  Created by Grant Savage on 11/18/18.
//  Copyright © 2018 Grant Savage. All rights reserved.
//
// File for formula data structures

import Foundation

// Formula struct that conforms to Codable for storage
public struct Formula:Codable {
	var id: Int
	var title: String
	var expression: String
	var inputs: [String : String]
}

public extension String {
	var numericalExpression: NSExpression {
		return NSExpression(format: self)
	}
}
