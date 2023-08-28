//
//  Payment.swift
//  Roomies
//
//  Created by Emilija Chona on 8/28/23.
//

import Foundation

var paymentsList = [Payment]()

class Payment
{
    var year: Int!
    var month: String!
    var sum: Int!
    
    func findPayment(year: Int, month: String) -> Payment? {
        for payment in paymentsList {
            if payment.year == year && payment.month == month {
                return payment
            }
        }
        return nil
    }
}
