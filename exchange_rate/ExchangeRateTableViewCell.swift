//
//  ExchangeRateTableViewCell.swift
//  exchange_rate
//
//  Created by Manal El Ouardani on 19/7/2021.
//

import UIKit



class ExchangeRateTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var pickerViewButton: UIButton!
    let screenWidth = UIScreen.main.bounds.width - 10
    let screenHeight = UIScreen.main.bounds.height / 2
    var selectedRow = 0
    

    
    var currencies = [
        "USD",
        "EUR"
    ]
    @IBAction func popUpPi(_ sender: Any) {
    
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height:screenHeight))
        pickerView.dataSource = self
        pickerView.delegate = self
        
        pickerView.selectRow(selectedRow, inComponent: 0, animated: false)
        //pickerView.selectRow(selectedRowTextColor, inComponent: 1, animated: false)
        
        vc.view.addSubview(pickerView)
        pickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        pickerView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        
        let alert = UIAlertController(title: "Select Background Colour", message: "", preferredStyle: .actionSheet)
        
        alert.popoverPresentationController?.sourceView = pickerViewButton
        alert.popoverPresentationController?.sourceRect = pickerViewButton.bounds
        
        alert.setValue(vc, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
        }))
        
        alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { (UIAlertAction) in
            self.selectedRow = pickerView.selectedRow(inComponent: 0)
            //self.selectedRowTextColor = pickerView.selectedRow(inComponent: 1)
            _ = Array(self.currencies)[self.selectedRow]
            //let selectedTextColor = Array(self.backGroundColours)[self.selectedRowTextColor]
  
      
      
        
            //self.pickerViewButton.setTitleColor(selectedTextColor.value, for: .normal)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 30))
        label.text = Array(currencies)[row]
        label.sizeToFit()
        return label
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1 //return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        currencies.count
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat
    {
        return 60
    }
    
    
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
