//
//  ContentView.swift
//  RestFullApp
//
//  Created by Anton Bryhagen on 2024-09-20.
//

import SwiftUI


struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            //if(viewModel.dataPoints.isEmpty){
            if(1 != 1){
                Text("Error fetching data from myUplink API")
            }else {
                VStack {
                    Button(action: {
                        viewModel.getTokenAndProceed()
                    }){
                        Text("Refresh Data")
                    }
                    
                    
                    List {
                        ForEach(viewModel.dataPoints, id: \.self) { dataPoint in
                            if (dataPoint.parameterId == "Error"){
                                Text(dataPoint.parameterName)
                            }else{
                                let sensorsToDisplay = ["Current outd temp (BT1)", "Supply line (BT61)", "Return line (BT62)"]
                                if sensorsToDisplay.contains(dataPoint.parameterName){
                                    HStack {
                                        
                                        Text(dataPoint.parameterName)
                                            .bold()
                                        Text(dataPoint.strVal)
                                        //Text("Updated: \(dataPoint.timestamp)")
                                        
                                    }
                                }
                                
                            }
                            
                        }
                        .padding(3)
                    }
                    .navigationTitle("Data Points")
                    .onAppear{
                        viewModel.getTokenAndProceed()
                    }
                }
            }
            
        }
    }
}

#Preview {
    ContentView()
}
