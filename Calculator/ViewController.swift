//
//  ViewController.swift
//  Calculator
//
//  Created by Matthew Nielsen on 2/3/15.
//  Copyright (c) 2015 Matthew Nielsen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //
    // declare class attributes
    //
    
    // colors
    var lightGrayColor: UIColor!
    var midGrayColor: UIColor!
    var darkGrayColor: UIColor!
    
    // backend
    var model: Model!
    
    // values for drawing the UI
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var keypadHeight: CGFloat!
    var displayHeight: CGFloat!
    var dividerSize: CGFloat!
    
    // main UI components
    var display: UIView!
    var keypad: UIView!
    
    // display components
    var textField: UITextField!
    
    //
    // app is loaded
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup colors
        lightGrayColor = UIColor(red: 224 / 256.0, green: 224 / 256.0, blue: 224 / 256.0, alpha: 1)
        midGrayColor = UIColor(red: 192 / 256.0, green: 192 / 256.0, blue: 192 / 256.0, alpha: 1)
        darkGrayColor = UIColor(red: 38 / 256.0, green: 38 / 256.0, blue: 38 / 256.0, alpha: 1)
        
        // instantiate the model
        model = Model()
        
        // load values for drawing the UI
        screenWidth = UIScreen.mainScreen().bounds.size.width
        screenHeight = UIScreen.mainScreen().bounds.size.height
        keypadHeight = calculateKeypadHeight()
        displayHeight = calculateDisplayHeight()
        dividerSize = calculateDividerSize()
        
        // draw the UI
        drawDisplay()
        drawKeypad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //
    // event handlers
    //
    
    // any key in the keypad is pressed
    func keyPress(sender: UIButton) {
        sender.backgroundColor = lightGrayColor
    }
    
    // numeric key is released from press
    func keyRelease(sender: UIButton) {
        switch sender.tag {
        case 0:
            // 7
            model.inputNum("7")
        case 1:
            // 8
            model.inputNum("8")
        case 2:
            // 9
            model.inputNum("9")
        case 3:
            // divide
            model.inputOp("/")
        case 4:
            // 4
            model.inputNum("4")
        case 5:
            // 5
            model.inputNum("5")
        case 6:
            // 6
            model.inputNum("6")
        case 7:
            // multiply
            model.inputOp("x")
        case 8:
            // 1
            model.inputNum("1")
        case 9:
            // 2
            model.inputNum("2")
        case 10:
            // 3
            model.inputNum("3")
        case 11:
            // subtract
            model.inputOp("-")
        case 12:
            // 0
            model.inputNum("0")
        case 13:
            // decimal
            model.inputNum(".")
        case 14:
            // equals
            textField.text = "\(model.eval())"
            model = Model()
            return
        default:
            // plus
            model.inputOp("+")
        }
        redrawDisplay()
    }
    
    //
    // other functions
    //
    
    // set the size of the keypad based on screen size
    func calculateKeypadHeight() -> CGFloat {
        switch screenHeight {
        case 480.0:
            return 218
        case 568.0:
            return 320
        case 667.0:
            return 375
        case 736:
            return 414
        default:
            return 490
        }
    }
    
    // set the size of the money display based on screen size
    func calculateDisplayHeight() -> CGFloat {
        return screenHeight - keypadHeight
    }
    
    // calculate how thick dividing lines should be based on pixel density
    func calculateDividerSize() -> CGFloat {
        switch UIScreen.mainScreen().scale {
        case 1.0:
            return 1.0
        case 2.0:
            return 0.5
        default:
            return 1 / 3
        }
    }
    
    // subtle animation when a key is released
    func animateKeyRelease(sender: UIButton) {
        UIView.animateWithDuration(0.3,
            delay: 0,
            options: UIViewAnimationOptions.AllowUserInteraction,
            animations: {
                sender.backgroundColor = UIColor.whiteColor()
            }, completion: {
                finished in
            }
        )
    }
    
    //
    // UI drawing functions
    //
    
    // redraws the money display and the controls when a change is made
    func redrawDisplay() {
        textField.text = model.formatValues()
    }
    
    // draw the money display section of the UI
    func drawDisplay() {
        // instantiate the display UIView
        display = UIView(frame: CGRectMake(0, 0, screenWidth, displayHeight))
        display.backgroundColor = darkGrayColor
        
        
        // calculate values for drawing elements
        var margin: CGFloat = 6
        
        var numFontSize: CGFloat = displayHeight / 2
        var numHeight: CGFloat = numFontSize + 4
        
        
        textField = UITextField(frame: CGRectMake(margin, 20, screenWidth - margin * 2, numHeight))
        textField.text = "0"
        textField.font = UIFont(name: "HelveticaNeue-UltraLight", size: numFontSize)
        textField.textColor = UIColor.whiteColor()
        textField.textAlignment = .Right
        textField.userInteractionEnabled = false
        textField.adjustsFontSizeToFitWidth = true
        display.addSubview(textField)
        
        
        // add display UIView to the screen
        self.view.addSubview(display)
    }
    
    // draw the keypad section of the UI
    func drawKeypad() {
        // instantiate the keypad UIView
        keypad = UIView(frame: CGRectMake(0, displayHeight, screenWidth, keypadHeight))
        
        
        // calculate values for drawing elements
        var keyWidth: CGFloat = screenWidth / 4
        var keyHeight: CGFloat = keypadHeight / 4
        var numFontSize: CGFloat = keyHeight / 2.25
        var charFontSize: CGFloat = keyHeight / 3.25
        var keys = ["7", "8", "9", "/", "4", "5", "6", "x", "1", "2", "3", "-", "0", ".", "=", "+"]
        // tags:     0    1    2    3    4    5    6    7    8    9    10   11   12   13   14   15
        
        
        // draw numeric keys
        var count: CGFloat = 0
        var tag = 0
        for key in keys {
            var button = UIButton(frame: CGRectMake(count % 4 * keyWidth, CGFloat(Int(count / 4)) * keyHeight, keyWidth, keyHeight))
            button.setTitle(key, forState: UIControlState.Normal)
            button.titleLabel!.font = UIFont(name: "HelveticaNeue-Thin", size: numFontSize)
            button.backgroundColor = UIColor.whiteColor()
            button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            button.tag = tag
            
            button.addTarget(self, action: "keyPress:", forControlEvents: UIControlEvents.TouchDown)
            button.addTarget(self, action: "animateKeyRelease:", forControlEvents: UIControlEvents.TouchUpInside)
            button.addTarget(self, action: "animateKeyRelease:", forControlEvents: UIControlEvents.TouchDragOutside)
            button.addTarget(self, action: "keyRelease:", forControlEvents: UIControlEvents.TouchUpInside)
            
            keypad.addSubview(button)
            
            count++
            tag++
        }
        
        
        // add dividing lines to give keys distinct boundaries
        var x: CGFloat = 0
        for divider in 0...2 {
            var divider = UIView(frame: CGRectMake(0, keyHeight * (x + 1), screenWidth, dividerSize))
            divider.backgroundColor = UIColor.blackColor()
            keypad.addSubview(divider)
            
            x++
        }
        x = 0
        for divider in 0...2 {
            var divider = UIView(frame: CGRectMake(keyWidth * (x + 1), 0, dividerSize, keypadHeight))
            divider.backgroundColor = UIColor.blackColor()
            keypad.addSubview(divider)
            
            x++
        }
        
        
        // add keypad UIView to the screen
        self.view.addSubview(keypad)
    }
    
}

