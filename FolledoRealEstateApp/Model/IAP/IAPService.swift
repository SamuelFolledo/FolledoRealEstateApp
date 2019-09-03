//
//  IAPService.swift
//  FolledoRealEstateApp
//
//  Created by Samuel Folledo on 11/17/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import Foundation
import StoreKit //RE ep.139 2mins need to purchase products

class IAPService: NSObject { //RE ep.139 3mins
    
    private override init() { } //RE ep.139 3mins we dont want this class to be initialized more than once
    static let shared = IAPService() //RE ep.139 3mins this creates a singleton of our class which is shared
    
    var products: [SKProduct] = [] //RE ep.139 4mins array that will hold all our purchases
    let paymentQueue = SKPaymentQueue.default() //RE ep.139 4mins
    
    func getProducts() { //RE ep.139 5mins
        let productsValue: Set = [IAPProduct.coins.rawValue, IAPProduct.agentSubscription.rawValue] //RE ep.139 5mins Set is required for IA purchase. Access the string value of our IAPProducts
//        print(productsValue)
        let request = SKProductsRequest(productIdentifiers: productsValue) //RE ep.139 6mins
        request.delegate = self //RE ep.139 6mins
        request.start() //RE ep.139 6mins start the request
        paymentQueue.add(self) //RE ep.140 7mins
    }
    
    
    func purchase(product: IAPProduct) { //RE ep.141 8mins
        guard let productPurchase = products.filter({ $0.productIdentifier == product.rawValue }).first else { return } //RE ep.141 9mins checks if the product we got is matching something in our products array //filter = Returns an array containing, in order, the elements of the sequence that satisfy the given predicate. //.productIdentifier = The string that identifies the product to the Apple App Store.
        let payment = SKPayment(product: productPurchase) //RE ep.141 10mins
        paymentQueue.add(payment) //RE ep.141 10mins
    }
    
    func restorePurchase() { //RE ep.141 11mins
        paymentQueue.restoreCompletedTransactions() //RE ep.141 11mins restores our completed purchases
    }
    
    
}//EOF

extension IAPService: SKProductsRequestDelegate { //RE ep.140 0mins
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) { //RE ep.140 1mins
        print("responses \(response.products)") //RE ep.140 1mins
        
        for product in response.products { //RE ep.140 1mins
            print("Product = \(product.productIdentifier)") //RE ep.140 2mins
            
            self.products = response.products //RE ep.141 0mins set our products to our products array
        }
    }
}

extension IAPService: SKPaymentTransactionObserver { //RE ep.141 1mins
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) { //RE ep.141 1mins update transaction which allows us to receive an array of transactions
        for transaction in transactions { //RE ep.141 1mins
            print("Transaction = \(transaction.transactionState.status(), transaction.payment.productIdentifier)") //RE ep.141 2mins //RE ep.141 7mins status method is called to return its current state
            
            switch transaction.transactionState { //RE ep.141 2mins
            case .purchasing: break //RE ep.141 2mins if we are purchasing then do nothing
            case .purchased: //RE ep.141 3mins if purchased then we tell our queue to finish the transaction. Needed for cleaning queue and so we can buy coins again.
                queue.finishTransaction(transaction) //RE ep.141 4mins
                
                FUser.currentUser()?.purchse(productId: transaction.payment.productIdentifier) //RE ep.144 6mins
                
            default: queue.finishTransaction(transaction) //RE ep.141 4mins
            }
        }
    }
}

extension SKPaymentTransactionState { //RE ep.141 4mins
    func status() -> String { //RE ep.141 5mins to make a more readable text for our transactions status
        switch self { //RE ep.141 5mins
        case .deferred: //RE ep.141 5mins
            return "deffered" //RE ep.141 5mins
        case .failed: //RE ep.141 5mins
            return "failed" //RE ep.141 5mins
        case .purchasing: //RE ep.141 5mins
            return "purchasing..." //RE ep.141 6mins
        case .purchased: //RE ep.141 6mins
            return "purchased!" //RE ep.141 6mins
        case .restored: //RE ep.141 6mins
            return "stored" //RE ep.141 6mins
            
        }
    }
    
}
