//
//  ViewController.swift
//  CRProjSwift
//
//  Created by 曾超然 on 16/6/16.
//  Copyright © 2016年 Chriz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var display: UILabel!

    private var userIsInTheMiddleOfTyping = false
    
    @IBAction private func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
    }
    
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction private func performOperation(sender: UIButton) {
        
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
        }
        
        userIsInTheMiddleOfTyping = false
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
            displayValue = brain.result

        }
    }
    
    
    @IBAction func clean() {
        userIsInTheMiddleOfTyping = false
        brain.cleanCalculator()
        displayValue = 0
        
    }
    
    @IBAction func history() {
        display.text = brain.description
        
    }
    var savedProgram : CalculatorBrain.PropertyList?
    
    @IBAction func saveOperation(sender: UIButton) {
        savedProgram = brain.program
    }
    
    @IBAction func restoreOperation(sender: UIButton) {
        brain.program = savedProgram!
        displayValue = brain.result
        userIsInTheMiddleOfTyping = false
    }
    
    
}

