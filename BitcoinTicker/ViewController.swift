//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencySymbolArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    

    var finalURL = ""
    var currencyRow : Int = 0

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegate and datasource for UIPicker
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
       
    }

    
    //TODO: Place your 3 UIPickerView delegate methods here
    
    //Picker: Number of columns
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //Picker: Number of rows
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    //Picker: Titles
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    //When Row is Selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(currencyArray[row])
        
        currencyRow = row
        
        finalURL = baseURL + currencyArray[row]
        print(finalURL)
        getBitcoinPrice(url: finalURL)
    }
    

    
    
    
  
    //MARK: - Networking
    /***************************************************************/
    
    func getBitcoinPrice(url: String) {
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {
                    
                    print("Sucess! Got the Bitcoin price")
                    let priceJSON : JSON = JSON(response.result.value)
                    
                    print(priceJSON)

                    self.updateBitcoinPrice(json: priceJSON)
                    
                } else {
                    print("Error: \(response.result.error)")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
        }
        
    }
    

    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    func updateBitcoinPrice(json : JSON) {
        
        if let bitcoinPrice = json["open"]["hour"].double{
            print(bitcoinPrice)
            bitcoinPriceLabel.text = currencySymbolArray[currencyRow] + String(bitcoinPrice)
        }
        else {
            bitcoinPriceLabel.text = "Unavailable"
        }
    }
    




}

