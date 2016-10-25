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

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var factLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var anotherFactButton: UIButton!
    @IBOutlet weak var languageButton: UIButton!
    @IBOutlet weak var languageContainerView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    let languages = Fact().getLanguagesList()
    
    var selectedLanguage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        requestFact()
    }
    
    fileprivate func requestFact(){
        setFactLoading(true)
        
        var parameters = Parameters()
        if let language = selectedLanguage {
            parameters = ["lang": Fact().getLanguageCode(lang: language)]
        }
        
        guard let urlRequest = try? Router.findAll(FactService(), parameters).asURLRequest() else {
            print("Error making the url")
            return
        }
        
        Alamofire.request(urlRequest as URLRequestConvertible)
            .responseJSON{ response in
                let json = JSON(response.result.value ?? [])
                let fact = Fact(json: json)
                
                self.setFact(fact)
                
                self.changeThemeColor()
                self.setFactLoading(false)
        }
    }
    
    fileprivate func setFact(_ fact: Fact){
        factLabel.text = fact.value
        languageButton.setTitle("Facts in \(fact.getLanguage())", for: .normal)
        languageContainerView.isHidden = false
    }
    
    fileprivate func setFactLoading(_ isLoading: Bool){
        self.activityIndicator.isHidden = !isLoading
        self.factLabel.isHidden = isLoading
        if isLoading {
            self.activityIndicator.startAnimating()
        }else{
            self.activityIndicator.stopAnimating()
        }
    }
    
    fileprivate func changeThemeColor(){
        if let color = Color().getRandomColor() {
            UIView.animate(withDuration: 0.180, delay: 0.0, options: [], animations: {
                self.view.backgroundColor = UIColor(netHex: color.getHexCode()!)
                self.anotherFactButton.setTitleColor(UIColor(netHex:color.getHexCode()!), for: UIControlState())
            })
        }
    }
    
    fileprivate func animateIn(){
        self.view.addSubview(tableView)
        tableView.center = self.view.center
        
        tableView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        tableView.alpha = 0
        
        UIView.animate(withDuration: 0.4){
            self.visualEffectView.isHidden = false
            self.tableView.alpha = 1
            self.tableView.transform = CGAffineTransform.identity
        }
    }
    
    fileprivate func animateOut(){
        UIView.animate(withDuration: 0.3, animations: {
            self.tableView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.tableView.alpha = 0
            
            self.visualEffectView.isHidden = true
        }) { (success: Bool) in
            self.tableView.removeFromSuperview()
        }
    }
    
    
    // MARK: - Actions
    @IBAction func requestFactAPI() {
        requestFact()
    }
    
    @IBAction func changeLanguage() {
        animateIn()
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "languageCell", for: indexPath)
        cell.textLabel?.text = languages[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedLanguage = languages[indexPath.row]
        animateOut()
    }
    
}

