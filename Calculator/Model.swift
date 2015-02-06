//
//  Model.swift
//  Calculator
//
//  Created by Matthew Nielsen on 2/3/15.
//  Copyright (c) 2015 Matthew Nielsen. All rights reserved.
//

import Foundation

class Model {
    
    //
    // declare class attributes
    //
    
    var num1: String
    var op: String
    var num2: String
    
    init() {
        num1 = ""
        op = ""
        num2 = ""
    }
    
    func strToFloat(str: String) -> Float {
        return NSString(string: str).floatValue
    }
    
    func num1Present() -> Bool {
        return num1 != ""
    }
    
    func opPresent() -> Bool {
        return op != ""
    }
    
    func num2Present() -> Bool {
        return num2 != ""
    }
    
    func inputNum(input: String) {
        if opPresent() {
            num2 += input
        } else {
            num1 += input
        }
    }
    
    func inputOp(input: String) {
        if num1Present() {
            op = input
        }
    }
    
    func eval() -> Float {
        switch op {
        case "+":
            return strToFloat(num1) + strToFloat(num2)
        case "-":
            return strToFloat(num1) - strToFloat(num2)
        case "x":
            return strToFloat(num1) * strToFloat(num2)
        default: // division
            return strToFloat(num1) / strToFloat(num2)
        }
    }
    
    func formatValues() -> String {
        if num2Present() {
            return num1 + " " + op + " " + num2
        } else if opPresent() {
            return num1 + " " + op
        } else {
            return num1
        }
    }
    
}
