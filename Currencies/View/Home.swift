//
//  Home.swift
//  Currencies
//
//  Created by Manal El Ouardani on 1/8/2021.
//

import SwiftUI

struct Home: View {
    @StateObject var viewModel = FetchData()
    var body: some View{
        
        VStack{
            if viewModel.conversionData.isEmpty{
                ProgressView()
            }
            else{
                ScrollView{
                    LazyVStack(alignment: .leading, content:  {
                        ForEach(viewModel.conversionData){rate in
                            HStack(spacing: 20){
                              
                               
                                VStack( alignment: .leading, content: {
                                    Text(rate.currencyName)
                                        .font(.title)
                                        .fontWeight(.bold)
                                    Text("\(rate.currencyValue)")
                                        .fontWeight(.heavy)
                                   
                                    })
                                Spacer()
                                   
                                    NavigationLink(destination: Graph()) {
                                       
                                        VStack(content: {
                                            Button(action: {}, label: {
                                                                Image("ic_chart")
                                                                    .resizable()
                                                                    .frame(width: 30, height: 30, alignment: .leading)
                                                                    
                                                            })
                                            
                                       
                                        })
                                    }
                                
                                
                            }
                            .padding(.horizontal)
                    
                }
               
            })
                    .padding(.top)
                    
            
        }
    
    }
    
}
        .toolbar(content: {
            Menu(content: {
                ForEach(currencies,id: \.self){name in
                    Button(action: {viewModel.updateData(base: name)}, label: {
                        Text(name)
                    })
                    
                }
            }) {
                Text("Base = \(viewModel.base)")
                    .fontWeight(.heavy)
            }
        })
}
  
    
    
}
