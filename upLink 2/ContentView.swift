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
            let sensorsToDisplay = ["Current outd temp (BT1)", "Supply line (BT61)", "Return line (BT62)"]
            ScrollView(.vertical, showsIndicators: true){
                ForEach(viewModel.dataPoints, id: \.self) { dataPoint in
                    if sensorsToDisplay.contains(dataPoint.parameterName){
                        SensorCard(sensorName: dataPoint.parameterName, sensorValue: String(dataPoint.value))
                    }
                }
            }
            .onAppear{
                viewModel.getTokenAndProceed()
            }
            .navigationTitle("myUplink 2")
            .refreshable {
                viewModel.getTokenAndProceed()
            }
        }
    }
}

#Preview {
    ContentView()
}
