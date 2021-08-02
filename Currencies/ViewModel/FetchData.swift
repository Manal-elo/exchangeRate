//
//  FetchData.swift
//  Currencies
//
//  Created by Manal El Ouardani on 1/8/2021.
//

import SwiftUI

class FetchData: ObservableObject {
    
    @Published var conversionData : [Currency] = []
    @Published var base = "USD"
    
    init() {
        fetch()
    }
    
    func fetch(){
        
        let url = "http://api.exchangeratesapi.io/v1/latest?access_key=a0e21e6fe3201a626cf403e2d2ee3052"
        let session = URLSession(configuration: .default)
        session.dataTask(with: URL(string: url)!) { (data, _, _) in
            
            guard let JSONData = data else{return}
            
            do{
                let conversion = try JSONDecoder().decode(Conversion.self, from: JSONData)
                
                DispatchQueue.main.async {
                    self.conversionData = conversion.rates.compactMap({(key,value) -> Currency? in
                        return Currency(currencyName: key, currencyValue: value)
                    })
                }
               
                
            }catch{
                print(error.localizedDescription)
               
            }
            
        }
        .resume()
        
        
    }
    func updateData(base: String) {
        self.base = base
        self.conversionData.removeAll()
        fetch()
    }
    
   
    
}


