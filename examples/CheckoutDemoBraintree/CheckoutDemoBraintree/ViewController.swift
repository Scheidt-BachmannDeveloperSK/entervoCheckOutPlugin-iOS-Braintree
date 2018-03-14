//
//  ViewController.swift
//  DemoBraintree
//
//  Created by Developer on 28.02.18.
//  Copyright © 2018 Scheidt & Bachmann. All rights reserved.
//

import UIKit
import entervoCheckoutPluginBraintree
import Braintree
import BraintreeDropIn

class ViewController: UIViewController, SBCheckOutDelegate {
    
    @IBOutlet var pluginView: UIView?
    func onConductPayment(sessionToken: String) {
    }
    
    func onMessage(level: SBCheckOut.LogLevel, message: String) {
        NSLog( "onMessage( message: \(message))")
    }
    
    func onError(message: String) {
        NSLog( "onError( message: \(message))")
    }
    
    func onStatus(newStatus: SBCheckOut.Status, info: Any?) {
        NSLog( "onStatus( newStatus: \(newStatus))")
        if ( newStatus == .FLOW_FINISHED) {
            if let res = info {
                NSLog( "\(res)")
            }
        }
    }
    
    @IBAction func startButtonClicked() {
        plugin.start( identification: /*"360108376744330999"*//*"120921356966778255"*/"434127816644330811", type: .BARCODE)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        plugin.setRect(pluginView!.frame)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        plugin.setDelegate(self);               // this viewcontroller is the delegate for the plugin
        plugin.setLogLevel(level: .TRACE)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

