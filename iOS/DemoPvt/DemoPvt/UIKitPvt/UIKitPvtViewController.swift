//
//  UIKitPvtViewController.swift
//  DemoPvt
//
//  Created by Mel Arthurs on 16/05/2021.
//

import UIKit
import AudioToolbox

public typealias UIKitPvtResultMap = [String : Any]

public protocol UIKitPvtResultDelegate {
    func onResults(_ results: [UIKitPvtResultMap])
}

class UIKitPvtViewController: UIViewController {

    public var delegate: UIKitPvtResultDelegate?
    public var testCount: Int = 0
    
    private var intervalMax: Int64 = 3000
    private var intervalMin: Int64 = 2000
    private var postStimulusDelay = 1000
        
    private var remainingTestCount = 0
    
    private var startTimestamp: Int64 = 0
    private var reactionTimestamp: Int64 = 0
    private var interval: Int64 = 0
    
    private var results: [UIKitPvtResultMap] = []
    private var resultsDisplayed = false
    
    private let mainQueue = DispatchQueue.main
    private let globalQueue = DispatchQueue.global(qos: .userInteractive)
    
    private let soundId = SystemSoundID(1057)
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    
        setupView()
        
        remainingTestCount = testCount
        runInterval()
    }
        
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleInteraction()
    }
        
    func handleInteraction() {
        reactionTimestamp = unixTimestamp()

        if (testsComplete() && resultsDisplayed) {
            return
        }
        
        reactionTimestamp = unixTimestamp()
        let reactionDelay = reactionTimestamp - startTimestamp
        
        addResult(reactionDelay)

        if (testsComplete()) {
            delegate?.onResults(results)
        } else {
            runInterval()
        }
    }
        
    private func addResult(_ reactionDelay: Int64) {
        let testNumber = (testCount - remainingTestCount) - 1
        
        let result: UIKitPvtResultMap = [
            "testNumber": testNumber,
            "reactionTimestamp": reactionTimestamp,
            "interval": interval,
            "reactionDelay": reactionDelay
        ]
        results.append(result)
    }
        
    private func runInterval() {
        view.backgroundColor = UIColor.black
        
        remainingTestCount -= 1
        interval = getNextIntervalDelay()
        
        globalQueue.async { [self] in
            usleep(UInt32(interval) * 1000)
                        
            self.mainQueue.async { [self] in
                startTimestamp = unixTimestamp()
                
                view.backgroundColor = UIColor.red
            }
        }
    }
        
    private func testsComplete() -> Bool {
        remainingTestCount == 0
    }
    
    private func getNextIntervalDelay() -> Int64 {
        Int64.random(in: intervalMin...intervalMax)
    }
    
    func setupView() {
        view.backgroundColor = UIColor.black
    }
}
