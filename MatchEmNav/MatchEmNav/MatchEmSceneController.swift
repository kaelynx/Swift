
//  Created by Kaelyn Campbell on 11/8/18.
//  Copyright © 2018 Kaelyn Campbell. All rights reserved.
//

import UIKit

class MatchEmSceneController: UIViewController {
    
    var backgroundColor = UIColor.white

    @IBOutlet weak var gameLabel: UILabel!
    @IBOutlet weak var matchLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    private var gamePaused = false
    private var gameInProgress = false
    
    private var game = Game()
    private var buttonDict = [UIButton: PieceID]()
    private var prevButton: UIButton?
    private var count = 0
    
    private var gameTimer: Timer?
    private var gameDuration: TimeInterval = 1.0
    private var seconds = 15.0
    private lazy var timeRemaining = seconds
    
    private var newRectTimer: Timer?
    var newRectInterval: TimeInterval = 1.2
    
    var rectSizeMin:CGFloat =  50.0
    var rectSizeMax:CGFloat = 150.0
    
    private var buttonCount = 0 {
        didSet {
            if
                gameLabel != nil{
                gameLabel.text = gameLabelMessage
            }
        }
    }
    private var gameLabelMessage: String {
        return "Pairs: \(buttonCount)"
    }
    
    private var matchCount = 0 {
        didSet {
            if matchLabel != nil {
                matchLabel.text = matchLabelMessage
            }
        }
    }
    
    private var matchLabelMessage: String {
        return "Matches: \(matchCount)"
    }
    
    private func createButton() {
        // Create a button
        let randSize     = randomSize()
        let randLocation = randomLocation(size: randSize)
        let randFrame    = CGRect(origin: randLocation, size: randSize)
        let button = UIButton(frame: randFrame)
        
        let randLocation2 = randomLocation(size: randSize)
        let randFrame2 = CGRect(origin: randLocation2, size: randSize)
        // Do some setup
        button.backgroundColor = getRandomColor()
        button.setTitle("", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 50)
        button.showsTouchWhenHighlighted = true
        button.isMultipleTouchEnabled = true
        button.addTarget(self,
                         action: #selector(handlePress(sender:forEvent:)), for: .touchUpInside)
        
        let button2 = UIButton(frame: randFrame2)
        button2.backgroundColor = button.backgroundColor
        button2.setTitle("", for: .normal)
        button2.setTitleColor(.black, for: .normal)
        button2.titleLabel?.font = .systemFont(ofSize: 50)
        button2.showsTouchWhenHighlighted = true
        button2.isMultipleTouchEnabled = true
        button2.addTarget(self,
                          action: #selector(handlePress(sender:forEvent:)), for: .touchUpInside)
        
        // Count the button pairs
        buttonCount += 1
        
        // Get game piece for the button
        let pieceId = game.createPiece()
        buttonDict[button] = pieceId
        let pieceId2 = game.createPiece()
        buttonDict[button2] = pieceId2
        
        // Make the buttons visible
        self.view.addSubview(button)
        self.view.addSubview(button2)
        // Make labels visible over buttons
        self.view.bringSubview(toFront: gameLabel)
        self.view.bringSubview(toFront: matchLabel)
        self.view.bringSubview(toFront: timeLabel)
        
    }
    
    func removeButton(_ theButton: UIButton) {
        // Optional chaining
        theButton.removeFromSuperview()
    }
    
    func startNewGame() {
        gameInProgress = true
        gamePaused = false
        timeRemaining = seconds
        resumeGameRunning()
    }
    
    var temp = [Int]()
    var lastScore = 0
    
    func stopGameRunning() {
        pauseGameRunning()
        game.updateScore(score: matchCount)
        lastScore = game.getLastScore()
        temp.insert(lastScore, at:0)
        for (button, _) in buttonDict {
            button.removeFromSuperview()
        }
        gameInProgress = false
    }
    
    func getLastScore() -> Int {
        return game.getLastScore()
    }
    
    func getGameScore() -> [Int] {
        return game.getScores()
    }
    
    // MARK: - ==== Timer Stuff ====
    private func resumeGameRunning () {
        // Timer to produce the buttons
        newRectTimer = Timer.scheduledTimer(withTimeInterval: newRectInterval, repeats: true)
        { _ in self.createButton() }
        
        // Timer for game
        gameTimer = Timer.scheduledTimer(withTimeInterval: gameDuration, repeats: true)
        { _ in self.updateTimer() }
    }
    
    //used to be stop
    private func pauseGameRunning() {
        // Stop the timer
        if let timer = newRectTimer { timer.invalidate() }
        
        // Remove the reference to the timer object
        self.newRectTimer = nil
        
        // Stop the timer
        if let timer = gameTimer { timer.invalidate() }
        
        // Remove the reference to the timer object
        self.gameTimer = nil
        
    }
    
    @objc func updateTimer(){
        if(seconds > 0.0) {
            seconds -= 1.0
            timeLabel?.text = "Time: \(seconds)"
        }
        if(seconds == 0.0) {
            stopGameRunning()
        }
    }
    
    func resetGame() {
        seconds = 15.0
        buttonCount = 0
        matchCount = 0
        updateTimer()
    }
    
    @objc private func handlePress(sender: UIButton, forEvent event: UIEvent) {
        let pieceId = buttonDict[sender]
        if count != 0 && gameTimer != nil {
            let prevPieceId = buttonDict[prevButton!]
            if game.isSamePair(pieceID: pieceId!, pieceID: prevPieceId!) && prevButton != sender {
                // the buttons are a match
                sender.setTitle("🐵", for: .normal)
                removeButton(sender)
                removeButton(prevButton!)
                matchCount += 1
            } else {
                // no match
                game.deselect(pieceID: prevPieceId!)
                prevButton!.setTitle("", for: .normal)
            }
            // reset button click counter
            count = 0
        } else {
            if gameTimer != nil {
                count = 1
                prevButton = sender
                sender.setTitle("🐵", for: .normal)
                game.select(pieceID: pieceId!)
            }
        }
    }
    
    @IBAction func handleTaps(_ sender: UITapGestureRecognizer) {
        if !gameInProgress {
            resetGame()
            startNewGame()
            return
        }
        // We have a game running
        if gamePaused {
            resumeGameRunning()
            gamePaused = false
            
        } else {
            pauseGameRunning()
            gamePaused = true
        }
    }
    
    // MARK: - ==== View Controller ====
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isMultipleTouchEnabled = true
        self.view.backgroundColor = backgroundColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        if gameInProgress && !gamePaused {
            resumeGameRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        pauseGameRunning()
    }
    
    // MARK: - ==== Random Value Funcs ====
    private func randomFloatZeroThroughOne() -> CGFloat {
        // arc4random returns UInt32
        let randomFloat = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        
        return randomFloat
    }
    
    private func randomSize() -> CGSize {
        // Rect size
        let randWidth  = randomFloatZeroThroughOne() * (rectSizeMax - rectSizeMin) + rectSizeMin
        let randHeight = randomFloatZeroThroughOne() * (rectSizeMax - rectSizeMin) + rectSizeMin
        let randSize = CGSize(width: randWidth, height: randHeight)
        
        return randSize
    }
    
    private func randomLocation(size rectSize: CGSize) -> CGPoint {
        // Screen dimensions
        let screenWidth = view.frame.size.width
        let screenHeight = view.frame.size.height
        
        let rectX = randomFloatZeroThroughOne() * (screenWidth  - rectSize.width)
        let rectY = randomFloatZeroThroughOne() * (screenHeight - rectSize.height)
        let location = CGPoint(x: rectX, y: rectY)
        
        return location
    }
    
    private func getRandomColor() -> UIColor {
        let randRed   = randomFloatZeroThroughOne()
        let randGreen = randomFloatZeroThroughOne()
        let randBlue  = randomFloatZeroThroughOne()
        
        let alpha:CGFloat = 1.0
        
        return UIColor(red: randRed, green: randGreen, blue: randBlue, alpha: alpha)
    }
    var colorHasChanged = false
    var colorSliderVal = Float(0.0)
    func changeBG() {
        colorHasChanged = true
        self.view.backgroundColor = backgroundColor
    }
    var switchOn = false
    var minValStep = 50.0
    var maxValStep = 150.0

}
