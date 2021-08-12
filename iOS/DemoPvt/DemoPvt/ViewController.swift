//
//  ViewController.swift
//  DemoPvt
//
//  Created by Mel Arthurs on 01/04/2021.
//

import UIKit
import MessageUI

class ViewController: UIViewController,
                      MFMailComposeViewControllerDelegate,
                      MetalPvtResultDelegate,
                      UIKitPvtResultDelegate,
                      TouchLatencyViewControllerDelegate {

    private var results: [[String : Any]] = []
    
    private let testCount = 100
    private let email = "arthurme@tcd.ie"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func startMetalPvt(_ sender: UIButton) {
        let metalPvtViewController = MetalPvtViewController()
        metalPvtViewController.delegate = self
        metalPvtViewController.testCount = testCount
        present(metalPvtViewController, animated: true)
    }
    
    @IBAction func startUIKitPvt(_ sender: UIButton) {
        let uiKitPvtViewController = UIKitPvtViewController()
        uiKitPvtViewController.delegate = self
        uiKitPvtViewController.testCount = testCount
        present(uiKitPvtViewController, animated: true)
    }
    
    @IBAction func startWorkThread(_ sender: UIButton) {
        DispatchQueue.global(qos: .userInteractive).async {
            // computationally intensive function
            let _ = generatePrimes(to: Int.max)
        }
    }
    
    @IBAction func sendResultsEmail(_ sender: UIButton) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            
            mail.mailComposeDelegate = self
            mail.setToRecipients([email])
            mail.setSubject("Results.csv")
            mail.setMessageBody("Results.csv", isHTML: false)
            
            let data = Data(mapToCsv(map: results).utf8)
            mail.addAttachmentData(data, mimeType: "text/csv", fileName: "results.csv")

            present(mail, animated: true)
        } else {
            print("mail not set up")
            print(results)
        }
    }
    
    @IBAction func startResponseTest(_ sender: UIButton) {
        let touchLatencyViewController = TouchLatencyViewController()
        touchLatencyViewController.delegate = self
        touchLatencyViewController.testCount = testCount
        present(touchLatencyViewController, animated: true)
    }
    
    @IBAction func startWebViewPvt(_ sender: UIButton) {
        let webViewPvtViewController = WebViewPvtViewController()
        present(webViewPvtViewController, animated: true)
    }
    
    @IBAction func startWebViewTouchLatencyTest(_ sender: UIButton) {
        let viewController = TouchLatencyWebViewViewController()
        present(viewController, animated: true)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    func onResults(_ results: [[String : Any]]) {
        self.results = results
        print(results)
    }
    
    func onCancel() {
        print("onCancel")
    }

}

