//
//  ViewController.swift
//  RetroCalc
//
//  Created by Chris Nowak on 5/23/16.
//  Copyright © 2016 Chris Nowak Tho, LLC. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Add = "+"
        case Empty = "Empty"
    }
    
    // IBOutlets
    
    @IBOutlet weak var outputLabel: UILabel!
    
    // Variables
    
    var buttonSound: AVAudioPlayer!
    
    var runningNumber = "0"
    var leftValueString = ""
    var rightValueString = ""
    var currentOperation: Operation = Operation.Empty
    var result = ""
    
    // View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = NSBundle.mainBundle().pathForResource("btn", ofType: "wav")
        let soundUrl = NSURL(fileURLWithPath: path!)
        do {
            try buttonSound = AVAudioPlayer.init(contentsOfURL: soundUrl)
            buttonSound.prepareToPlay()
        } catch let error as NSError {
            print(error.debugDescription)
        }
        
    }
    
    // IBActions
    
    @IBAction func numberButtonPressed(sender: UIButton) {
        playSound()
        
        if runningNumber == "0" {
            runningNumber = "\(sender.tag)"
        }
        else {
            runningNumber += "\(sender.tag)"
        }
        outputLabel.text = runningNumber
    }
    
    @IBAction func divideButtonPressed(sender: UIButton) {
        processOperation(Operation.Divide)
    }
    
    @IBAction func multiplyButtonPressed(sender: UIButton) {
        processOperation(Operation.Multiply)
    }
    
    @IBAction func subtractButtonPressed(sender: UIButton) {
        processOperation(Operation.Subtract)
    }
    
    @IBAction func addButtonPressed(sender: UIButton) {
        processOperation(Operation.Add)
    }
    
    @IBAction func equalButtonPressed(sender: UIButton) {
        processOperation(currentOperation)
    }
    
    // Helper Methods
    
    func processOperation(operation: Operation) {
        playSound()
        
        if currentOperation != Operation.Empty {
            if runningNumber != "" {
                rightValueString = runningNumber
                runningNumber = ""
                switch currentOperation {
                case .Multiply:
                    result = "\(Double(leftValueString)! * Double(rightValueString)!)"
                    break
                case .Divide:
                    result = "\(Double(leftValueString)! / Double(rightValueString)!)"
                    break
                case .Subtract:
                    result = "\(Double(leftValueString)! - Double(rightValueString)!)"
                    break
                case .Add:
                    result = "\(Double(leftValueString)! + Double(rightValueString)!)"
                    break
                default:
                    print("OPERATION ERROR")
                }
                leftValueString = result
                outputLabel.text = result
            }
            currentOperation = operation
        } else {
            leftValueString = runningNumber
            runningNumber = ""
            currentOperation = operation
        }
    }
    
    func playSound() {
        if buttonSound.playing {
            buttonSound.stop()
        }
        buttonSound.play()
    }

}

