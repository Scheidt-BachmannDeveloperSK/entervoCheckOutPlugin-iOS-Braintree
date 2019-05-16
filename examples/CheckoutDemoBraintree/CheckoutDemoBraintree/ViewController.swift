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
    
    var hadError = false
    
    @IBOutlet var pluginView: UIView?
    func onConductPayment(sessionToken: String) {
    }
    
    func onMessage(level: SBCheckOut.LogLevel, message: String) {
        NSLog( "onMessage( message: \(message))")
    }
    
    func onError(code: SBCheckOut.ErrorCode, message: String) {
        NSLog( "onError( code: \(code), message: \(message))")
        hadError = true
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
                if ( shouldPresentReceipt(data: res)) {
                    showReceipt(data: info)
                }
            }
        }
    }
    
    @IBAction func startButtonClicked() {
        plugin.setRect(pluginView!.frame)
        hadError = false
        plugin.start( identification: "434127816644330811", type: .BARCODE)
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
 
    func shouldPresentReceipt( data: Any?) -> Bool {
        
        if ( self.hadError) {
            // an error occurred, so do not try to display a receipt
            return false
        }
        
        if let transaction = data as? SBCheckOutTransaction {
            
            if (    transaction.success &&
                    !transaction.braintree_transaction_id.isEmpty &&
                    !transaction.unique_pay_id.isEmpty) {
                // we have a successful and complete transaction confirmation, so show a receipt
                return true
            }
        }
        
        // we do not have a successful and complete transaction confirmation, so do not present a receipt
        return false
    }
    
}

