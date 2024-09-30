//
//  ContentView.swift
//  RestFullApp
//
//  Created by Anton Bryhagen on 2024-09-20.
//

import SwiftUI


struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    @State var lastUpdate = Date()
    
    var body: some View {
        NavigationView {
            let sensorsToDisplay = ["Current outd temp (BT1)", "Supply line (BT61)", "Return line (BT62)"]
            
            ScrollView(.vertical, showsIndicators: true){
                Text("Last update: \(formattedDate)")
                ForEach(viewModel.dataPoints, id: \.self) { dataPoint in
                    if viewModel.selectedDataPoints.contains(dataPoint.parameterName){
                        SensorCard(sensorName: dataPoint.parameterName, sensorValue: String(dataPoint.value))
                    }
                }
                NavigationLink(destination: QuickViewSettings(viewModel: viewModel)){
                    Text("Add or remove senors")
                }
            }
            .onAppear{
                viewModel.getTokenAndProceed()
            }
            .navigationTitle("myUplink 2")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: QuickViewSettings(viewModel: viewModel)){
                        Image(systemName: "gearshape")
                    }
                }
            }
            .refreshable {
                viewModel.getTokenAndProceed()
                lastUpdate = Date()
            }
            
        }
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss" // hour:minute:second day/month (dd/MM) format
        return formatter.string(from: lastUpdate)
    }
}

#Preview {
    ContentView()
}
