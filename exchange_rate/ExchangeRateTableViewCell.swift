//
//  ExchangeRateTableViewCell.swift
//  exchange_rate
//
//  Created by Manal El Ouardani on 19/7/2021.
//

import UIKit



class ExchangeRateTableViewController: UITableViewController {
    
    var exchangeRates = [String]()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showSpinner()
        let apiEndPoint = "http://api.exchangeratesapi.io/v1/latest?access_key=a0e21e6fe3201a626cf403e2d2ee3052"
        guard let url = URL(string: apiEndPoint) else {return }
        let task = URLSession.shared.dataTask(with: url){ (data: Data?,response: URLResponse?,error: Error?) in
            
            guard error == nil else {return}
            if let httpResponse = response as? HTTPURLResponse{
                guard httpResponse.statusCode == 200 else {return}
                
                print ("Everything is okay")
            }
            guard let data = data else {return}
            do {
                guard let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else {return}
                print(dict.description)
                guard let rates = dict["rates"] as? [String: Double], let date = dict["date"] as? String else{return}
                let currencies = rates.keys.sorted()
                for currency in currencies{
                    if let rate = rates[currency]{
                        
                        self.exchangeRates.append("\(rate)  \(currency)")
                    }
                }
                OperationQueue.main.addOperation ({
                    self.navigationController?.navigationBar.topItem?.title = "updated on \(date)"
                    
                    
                    self.tableView.reloadData()
                })
                
            }catch{
                print("Some error")
            }
        
        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "GraphViewController") as? GraphViewController{
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exchangeRates.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rates", for: indexPath)
        
       
        cell.textLabel?.text = exchangeRates[indexPath.row]
 
        return cell
    }

}
