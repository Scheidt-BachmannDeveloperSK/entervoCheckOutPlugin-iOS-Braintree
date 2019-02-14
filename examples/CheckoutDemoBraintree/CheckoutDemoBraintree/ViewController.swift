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
        if ( newStatus == .CLASSIFICATION_FINISHED) {
            if let res = info {
                NSLog( "\(res)")
            }
        }
        if ( newStatus == .FLOW_FINISHED) {
            if let res = info {
                NSLog( "\(res)")
                showReceipt(data: info)
            }
        }
    }
    
    @IBAction func startButtonClicked() {
        plugin.setRect(pluginView!.frame)
        plugin.start( identification: /*"360108376744330999"*//*"120921356966778255"*/"434127816644330811", type: .BARCODE)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        plugin.setRect(pluginView!.frame)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        plugin.setDelegate(self);               // this viewcontroller is the delegate for the plugin
        plugin.setLogLevel(level: .TRACE)
        let ver = plugin.version()
        NSLog( "Loaded entervoCheckoutPlugin version \(ver)")
    }
    
    func showReceipt( data: Any?) {
        var receiptText = "No transaction was concluded."
        if let receipt = data as? SBCheckOutTransaction {
            
            if ( receipt.success) {
                receiptText =
                    "transaction time: " + receipt.transaction_time + "\n" +
                    "transaction id: " + receipt.unique_pay_id + "\n" +
                    "Braintree transaction id: " + receipt.braintree_transaction_id +
                    "facility: " + receipt.facility_name + "\n" +
                    "ticket/licenseplate: " + receipt.epan + "\n" +
                    "parking duration: " + receipt.duration +
                    "total amount: \(receipt.amount) \(receipt.currency)\n" +
                    "including VAT of\(receipt.vat_rate) = \(receipt.vat_amount) \(receipt.currency)\n"
            }
        }
        let confirmation = UIAlertController(title: "*** YOUR RECEIPT ***", message: receiptText, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        confirmation.addAction(ok)
        self.present( confirmation, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

