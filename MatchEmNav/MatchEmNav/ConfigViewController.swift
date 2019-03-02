//
//  ConfigViewController.swift
//  RandomRectanglesNav
//
//  Created by Kaelyn Campbell on 11/8/18.
//  Copyright © 2018 Kaelyn Campbell. All rights reserved.
//


import UIKit

class ConfigViewController: UIViewController {
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var speedSlider: UISlider!
    
    @IBOutlet weak var colorSlider: UISlider!
    @IBOutlet weak var minStepper: UIStepper!
    @IBOutlet weak var maxStepper: UIStepper!
    @IBOutlet weak var darkModeSwitch: UISwitch!
    
    // Adjust the class/type names to fit your classes
    var MatchEmVC: MatchEmSceneController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get a reference to the MatchEmScene's View Controller
        let mvc = self.navigationController?.viewControllers[0] as? MatchEmSceneController
        MatchEmVC = mvc
    }
    
    var test = false
    @IBAction func changeBackground(_ sender: UISwitch) {
        if(sender.isOn == true) {
            test = true
            let newColor = UIColor(red: 0,
                                   green: 0,
                                   blue: 0,
                                   alpha: 1.0)
            MatchEmVC?.backgroundColor = newColor
            
            MatchEmVC?.changeBG()
            MatchEmVC?.switchOn = true
            self.view.backgroundColor = newColor
        }
        if(sender.isOn == false) {
            test = false
            let newColor = UIColor.white
            MatchEmVC?.backgroundColor = newColor
            
            MatchEmVC?.changeBG()
            self.view.backgroundColor = newColor
        }
    }
    var colorValue = CGFloat(0.0)
    var tempHue = CGFloat(0.0)
    @IBAction func changeBG(_ sender: UISlider) {
//        var colorValue = CGFloat(0.0)
        if test == false {
            colorValue = CGFloat(sender.value)
        } else {
            colorValue = CGFloat(sender.value - 0.75)
        }
        var color = UIColor(hue: colorValue, saturation: 0.5, brightness: 0.5, alpha: 1.0)
        self.view.backgroundColor = color
        MatchEmVC?.backgroundColor = color
        MatchEmVC?.colorSliderVal = sender.value
        MatchEmVC?.changeBG()
    }
    
    @IBOutlet weak var maxSizeLabel: UILabel!
    
    @IBAction func maxSizeHandler(_ sender: UIStepper) {
        MatchEmVC?.rectSizeMax = CGFloat(sender.value)
        MatchEmVC?.maxValStep = sender.value
        maxSizeLabel.text = Int(sender.value).description
    }
    
    @IBOutlet weak var minSizeLabel: UILabel!
    
    @IBAction func minSizeHandler(_ sender: UIStepper) {
        MatchEmVC?.rectSizeMin = CGFloat(sender.value)
        MatchEmVC?.minValStep = sender.value
        minSizeLabel.text = Int(sender.value).description
    }
    
    @IBAction func speedHandler(_ sender: UISlider) {
        let newSpeed = TimeInterval(sender.value)
        MatchEmVC?.newRectInterval = newSpeed
        
        // Set the label
        let speedText = String(format: "%3.1f",
                               arguments: [newSpeed])
        speedLabel.text = speedText

    }
    var tempArray = [Int]()
    private var scoreLabelMessage: String {
        var tempArray = MatchEmVC?.getGameScore()
        var score1 = 0
        var score2 = 0
        var score3 = 0
        if (tempArray?.count)! > 0 {
            score1 = tempArray![0]
        }
        if (tempArray?.count)! > 1 {
            score2 = tempArray![1]
        }
        if (tempArray?.count)! > 2 {
            score3 = tempArray![2]
        }
        return "Last Three Scores: \(score1), \(score2), \(score3)"
    }
    
    func updateScore() {
        self.scoreLabel.text = scoreLabelMessage
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        updateScore()
        //minSizeHandler(minStepper)
        //maxSizeHandler(maxStepper)
        // Get the speed
        let speed = MatchEmVC?.newRectInterval
        
        // Set the label
        let speedText = String(format: "%3.1f",
                               arguments: [speed!])
        speedLabel.text = speedText
        
        // Put the speed in the slider
        speedSlider.value = Float(speed!)
        
        if MatchEmVC?.switchOn == true {
            self.view.backgroundColor = MatchEmVC?.backgroundColor
            darkModeSwitch.isOn = true
        }
        
        if MatchEmVC?.colorHasChanged == true {
            self.view.backgroundColor = MatchEmVC?.backgroundColor
            colorSlider.value = (MatchEmVC?.colorSliderVal)!
        }
        
        minStepper.value = (MatchEmVC?.minValStep)!
        minSizeLabel.text = String(minStepper.value)
        maxStepper.value = (MatchEmVC?.maxValStep)!
        maxSizeLabel.text = String(maxStepper.value)
    }
    
    
}
