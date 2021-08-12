//
//  TouchResponseTimeTestViewController.swift
//  DemoPvt
//
//  Created by Mel Arthurs on 22/04/2021.
//

import UIKit
import MetalKit

public typealias MetalPvtResultMap = [String : Any]

public protocol MetalPvtResultDelegate {
    func onResults(_ results: [MetalPvtResultMap])
}

public class MetalPvtViewController:
    UIViewController,
    MTKViewDelegate {
    
    public var delegate: MetalPvtResultDelegate?
    public var testCount: Int = 0
    
    private var intervalMax: Int64 = 3000
    private var intervalMin: Int64 = 2000
    private var postStimulusDelay = 1000
    
    private var remainingTestCount = 0
    
    private var startTimestamp: Int64 = 0
    private var reactionTimestamp: Int64 = 0
    private var interval: Int64 = 0
    
    private var results: [MetalPvtResultMap] = []
    
    private let mainQueue = DispatchQueue.main
    private let globalQueue = DispatchQueue.global(qos: .userInteractive)
    
    private var device: MTLDevice!
    private var commandQueue: MTLCommandQueue!
    private var renderer: Renderer?
    private var drawStimulus: Bool = false
    
    private var mtkView: MTKView!

    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupMTK()
        
        remainingTestCount = testCount
        runInterval()
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleInteraction()
    }
    
    func handleInteraction() {
        reactionTimestamp = unixTimestamp()
        
        drawStimulus = false
        mtkView.draw()
        
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
        
        let result: MetalPvtResultMap = [
            "testNumber": testNumber,
            "reactionTimestamp": reactionTimestamp,
            "interval": interval,
            "reactionDelay": reactionDelay
        ]
        results.append(result)
    }
    
    private func runInterval() {
        drawStimulus = false
        mtkView.draw()
        
        remainingTestCount -= 1
        interval = self.getNextIntervalDelay()
        
        globalQueue.async { [self] in
            usleep(UInt32(interval) * 1000)
            
            self.mainQueue.async { [self] in
                startTimestamp = unixTimestamp()
                
                drawStimulus = true
                mtkView.draw()
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
        mtkView = MTKView()
        mtkView!.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mtkView!)
        
        NSLayoutConstraint.activate([
            mtkView!.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            mtkView!.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            mtkView!.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            mtkView!.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor)
        ])
    }
    
    func setupMTK() {
        device = MTLCreateSystemDefaultDevice()
        commandQueue = device.makeCommandQueue()
        
        mtkView.device = device
        mtkView.enableSetNeedsDisplay = true
        mtkView.clearColor = MTLClearColor(
            red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0
        )
        mtkView.delegate = self
        
        renderer = Renderer(device: mtkView.device!)
    }
    
    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
    
    public func draw(in view: MTKView) {
        guard let commandBuffer = commandQueue.makeCommandBuffer() else { return }
        guard let renderPassDescriptor = view.currentRenderPassDescriptor else { return }
        guard let renderCommandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else { return }
        
        renderer!.draw(renderCommandEncoder, drawStimulus: drawStimulus)
        
        renderCommandEncoder.endEncoding()
        
        if let drawable = view.currentDrawable {
            commandBuffer.present(drawable)
        }

        commandBuffer.commit()
    }
    
}

