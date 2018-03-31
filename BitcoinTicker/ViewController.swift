//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by David Davidov on 12/03/17.
//  Copyright © 2017 David Davidov. All rights reserved.
//

import UIKit
import Alamofire 
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return currencyArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return currencyArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        finalURL = baseURL + currencyArray[row]
        currencySelected = currencySymbolArray[row]
        getBitcoinPrice(url: finalURL)
    }
    
    
    var baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencySymbolArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var currencySelected = ""
    var finalURL = ""

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }
    
    //MARK: - Networking
    /***************************************************************/
    
    func getBitcoinPrice(url: String)
    {
        Alamofire.request(url, method: .get).responseJSON
        {
            response in
            if response.result.isSuccess
            {
                print("Sucess!")
                let priceJSON : JSON = JSON(response.result.value!)

                self.updatePrice(json: priceJSON)
            }
            else
            {
                print("Error: \(String(describing: response.result.error))")
                self.bitcoinPriceLabel.text = "Connection Issues"
            }
        }

    }
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    func updatePrice(json : JSON) {
       
        let priceResult = json["ask"].int
        if priceResult != nil
        {
            bitcoinPriceLabel.text = "\(currencySelected)\(priceResult!.withCommas())"
        }
        else
        {
            bitcoinPriceLabel.text = "Price Unavailable"
        }
    }


}
extension Int {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}
