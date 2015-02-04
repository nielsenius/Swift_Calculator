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
        if sender.tag == 12 || sender.tag == 13 {
            // C and Del keys
            sender.backgroundColor = midGrayColor
        } else {
            // all other keys
            sender.backgroundColor = lightGrayColor
        }
    }
    
    // numeric key is released from press
    func keyRelease(sender: UIButton) {
        switch sender.tag {
        case 0:
            // some shit
        default:
            //
        }
        
        
        model.appendNumToBill(String(sender.tag))
        animateButtonRelease(sender)
        redrawDisplay()
    }
    
    //
    // other functions
    //
    
    // set the size of the keypad based on screen size
    func calculateKeypadHeight() -> CGFloat {
        switch screenHeight {
        case 480.0:
            return 272
        case 568.0:
            return 400
        case 667.0:
            return 470
        case 736:
            return 518
        default:
            return 612
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
    func animateButtonRelease(sender: UIButton) {
        UIView.animateWithDuration(0.3,
            delay: 0,
            options: UIViewAnimationOptions.AllowUserInteraction,
            animations: {
                if sender.tag == 12 || sender.tag == 13 {
                    // C and Del keys
                    sender.backgroundColor = self.lightGrayColor
                } else {
                    // all other keys
                    sender.backgroundColor = UIColor.whiteColor()
                }
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
        // just need to update one textfield
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
        
        
        textField = UITextField(frame: CGRectMake(margin + labelWidth, thirdSpace, screenWidth - labelWidth - margin * 2, numHeight))
        textField.text = ""
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
        keypad = UIView(frame: CGRectMake(0, displayHeight + controlsHeight, screenWidth, keypadHeight))
        
        
        // calculate values for drawing elements
        var keyWidth: CGFloat = screenWidth / 4
        var keyHeight: CGFloat = keypadHeight / 4
        var numFontSize: CGFloat = keyHeight / 2.25
        var charFontSize: CGFloat = keyHeight / 3.25
        var keys = ["7", "8", "9", "4", "5", "6", "1", "2", "3"]
        
        
        // draw numeric keys
        var count: CGFloat = 0
        for key in keys {
            var button = UIButton(frame: CGRectMake(count % 3 * keyWidth, CGFloat(Int(count / 3)) * keyHeight, keyWidth, keyHeight))
            button.setTitle(key, forState: UIControlState.Normal)
            button.titleLabel!.font = UIFont(name: "HelveticaNeue-Thin", size: numFontSize)
            button.backgroundColor = UIColor.whiteColor()
            button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            button.tag = key.toInt()!
            
            button.addTarget(self, action: "anyButtonPress:", forControlEvents: UIControlEvents.TouchDown)
            button.addTarget(self, action: "animateButtonRelease:", forControlEvents: UIControlEvents.TouchUpInside)
            button.addTarget(self, action: "animateButtonRelease:", forControlEvents: UIControlEvents.TouchDragOutside)
            button.addTarget(self, action: "numButtonRelease:", forControlEvents: UIControlEvents.TouchUpInside)
            
            keypad.addSubview(button)
            
            count++
        }
        
        
        // draw the zero key
        var zero = UIButton(frame: CGRectMake(0, keypadHeight - keyHeight, keyWidth * 2, keyHeight))
        zero.setTitle("0", forState: UIControlState.Normal)
        zero.titleLabel!.font = UIFont(name: "HelveticaNeue-Thin", size: numFontSize)
        zero.titleEdgeInsets = UIEdgeInsetsMake(0.0, -keyWidth, 0.0, 0.0)
        zero.backgroundColor = UIColor.whiteColor()
        zero.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        zero.tag = 0
        
        zero.addTarget(self, action: "anyButtonPress:", forControlEvents: UIControlEvents.TouchDown)
        zero.addTarget(self, action: "animateButtonRelease:", forControlEvents: UIControlEvents.TouchUpInside)
        zero.addTarget(self, action: "animateButtonRelease:", forControlEvents: UIControlEvents.TouchDragOutside)
        zero.addTarget(self, action: "numButtonRelease:", forControlEvents: UIControlEvents.TouchUpInside)
        
        keypad.addSubview(zero)
        
        
        // draw the decimal key
        var decimal = UIButton(frame: CGRectMake(keyWidth * 2, keypadHeight - keyHeight, keyWidth, keyHeight))
        decimal.setTitle(".", forState: UIControlState.Normal)
        decimal.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: charFontSize)
        decimal.backgroundColor = UIColor.whiteColor()
        decimal.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        decimal.tag = 11
        
        decimal.addTarget(self, action: "anyButtonPress:", forControlEvents: UIControlEvents.TouchDown)
        decimal.addTarget(self, action: "animateButtonRelease:", forControlEvents: UIControlEvents.TouchUpInside)
        decimal.addTarget(self, action: "animateButtonRelease:", forControlEvents: UIControlEvents.TouchDragOutside)
        decimal.addTarget(self, action: "decimalButtonRelease:", forControlEvents: UIControlEvents.TouchUpInside)
        
        keypad.addSubview(decimal)
        
        
        // draw the C key
        var clear = UIButton(frame: CGRectMake(keyWidth * 3, 0, keyWidth, keyHeight * 2))
        clear.setTitle("C", forState: UIControlState.Normal)
        clear.titleLabel!.font = UIFont(name: "HelveticaNeue-Thin", size: charFontSize)
        clear.backgroundColor = lightGrayColor
        clear.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        clear.tag = 12
        
        clear.addTarget(self, action: "anyButtonPress:", forControlEvents: UIControlEvents.TouchDown)
        clear.addTarget(self, action: "animateButtonRelease:", forControlEvents: UIControlEvents.TouchUpInside)
        clear.addTarget(self, action: "animateButtonRelease:", forControlEvents: UIControlEvents.TouchDragOutside)
        clear.addTarget(self, action: "clearButtonRelease:", forControlEvents: UIControlEvents.TouchUpInside)
        
        keypad.addSubview(clear)
        
        
        // draw the Del key
        var delete = UIButton(frame: CGRectMake(keyWidth * 3, keyHeight * 2, keyWidth, keyHeight * 2))
        delete.setTitle("Del", forState: UIControlState.Normal)
        delete.titleLabel!.font = UIFont(name: "HelveticaNeue-Thin", size: charFontSize)
        delete.backgroundColor = lightGrayColor
        delete.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        delete.tag = 13
        
        delete.addTarget(self, action: "anyButtonPress:", forControlEvents: UIControlEvents.TouchDown)
        delete.addTarget(self, action: "animateButtonRelease:", forControlEvents: UIControlEvents.TouchUpInside)
        delete.addTarget(self, action: "animateButtonRelease:", forControlEvents: UIControlEvents.TouchDragOutside)
        delete.addTarget(self, action: "deleteButtonRelease:", forControlEvents: UIControlEvents.TouchUpInside)
        
        keypad.addSubview(delete)
        
        
        // add dividing lines to give keys distinct boundaries
        var dividers: [[CGFloat]] = [[0, 0, screenWidth, dividerSize], [0, keyHeight, screenWidth - keyWidth, dividerSize], [0, keyHeight * 2, screenWidth, dividerSize], [0, keyHeight * 3, screenWidth - keyWidth, dividerSize], [keyWidth, 0, dividerSize, keyHeight * 3], [keyWidth * 2, 0, dividerSize, keypadHeight], [keyWidth * 3, 0, dividerSize, keypadHeight]]
        for coords in dividers {
            var divider = UIView(frame: CGRectMake(coords[0], coords[1], coords[2], coords[3]))
            divider.backgroundColor = UIColor.blackColor()
            keypad.addSubview(divider)
        }
        
        
        // add keypad UIView to the screen
        self.view.addSubview(keypad)
    }
    
}

