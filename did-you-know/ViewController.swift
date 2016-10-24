//
//  ViewController.swift
//  did-you-know
//
//  Created by Alvaro De La Cruz on 10/24/16.
//  Copyright © 2016 Alvaro De La Cruz. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var factLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var anotherFactButton: UIButton!
    @IBOutlet weak var languageButton: UIButton!
    @IBOutlet weak var languageContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestFact()
    }
    
    fileprivate func requestFact(){
        setFactLoading(true)
        
        guard let urlRequest = try? Router.findAll(Fact()).asURLRequest() else {
            print("Couldn't make the url request ma' nigga")
            return
        }
        
        Alamofire.request(urlRequest as URLRequestConvertible)
            .responseJSON{ response in
                self.setFactLoading(false)
                
                let json = JSON(response.result.value ?? [])
                let fact = Fact(json: json)
                
                self.setFact(fact)
                self.changeThemeColor()
        }
    }
    
    fileprivate func setFact(_ fact: Fact){
        factLabel.text = fact.value
        languageButton.setTitle("Facts in \(fact.getLanguage())", for: UIControlState())
        languageContainerView.isHidden = false
    }
    
    fileprivate func setFactLoading(_ isLoading: Bool){
        activityIndicator.isHidden = !isLoading
        factLabel.isHidden = isLoading
        if isLoading {
            activityIndicator.startAnimating()
        }else{
            activityIndicator.stopAnimating()
        }
    }
    
    fileprivate func changeThemeColor(){
        if let color = Color().getRandomColor() {
            UIView.animate(withDuration: 0.180, delay: 0.0, options: [], animations: {
                self.view.backgroundColor = UIColor(netHex: color.getHexCode()!)
                self.anotherFactButton.setTitleColor(UIColor(netHex:color.getHexCode()!), for: UIControlState())
                }, completion: nil)
        }
    }
    
    @IBAction func requestFactAPI() {
        requestFact()
    }
    
}

