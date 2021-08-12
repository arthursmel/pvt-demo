//
//  TouchLatencyViewController.swift
//  DemoPvt
//
//  Created by Mel Arthurs on 12/05/2021.
//

import UIKit

public protocol TouchLatencyViewControllerDelegate {
    func onResults(_ results: [[String : Any]])
}

class TouchLatencyViewController: UIViewController {
    
    var results: [[String : Any]] = []
    var delegate: TouchLatencyViewControllerDelegate?
    var testCount = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let timestamp = unixTimestamp()
        
        if testCount > 0 {
            results.append(["" : timestamp])
            testCount -= 1
        } else {
            delegate!.onResults(results)
            dismiss(animated: true)
        }
    }
}
