//
//  QuickViewSettings.swift
//  upLink 2
//
//  Created by Anton Bryhagen on 2024-09-30.
//

import SwiftUI

struct QuickViewSettings: View {
    @State private var selectedSensor = false
    @StateObject var viewModel: ViewModel
    @State var sensorsList: [String: Bool] = [:]
    
    var body: some View {
        NavigationView{
            VStack {
                List{
                    ForEach(viewModel.dataPoints, id: \.self) { dataPoint in
                        Toggle(dataPoint.parameterName, isOn: Binding(
                            get: { sensorsList[dataPoint.parameterName] ?? false },
                            set: { newValue in sensorsList[dataPoint.parameterName] = newValue }
                        ))
                    }
                }
            }
            .navigationTitle("Select sensors")
            .onAppear{
                viewModel.getTokenAndProceed()
                for dataPoint in viewModel.dataPoints {
                    sensorsList[dataPoint.parameterName] = false
                }
            }
            .onDisappear{
                //save selected sensors
                var sensorsToDisplay: [String] = []
                for (sensorName, isSelected) in sensorsList {
                    if(isSelected){
                        sensorsToDisplay.append(sensorName)
                    }
                }
                viewModel.selectedDataPoints = sensorsToDisplay
            }
        }
    }
}

