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
                            get: { viewModel.selectedDataPoints.contains(dataPoint.parameterName) },
                            set: { newValue in
                                if newValue {
                                    viewModel.selectedDataPoints.append(dataPoint.parameterName)
                                }else{
                                    if let index = viewModel.selectedDataPoints.firstIndex(of: dataPoint.parameterName) {
                                        viewModel.selectedDataPoints.remove(at: index)
                                    }
                                }
                            }
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
            .onDisappear {
                UserDefaults.standard.set(viewModel.selectedDataPoints, forKey: "selectedDataPoints")
            }
        }
    }
}

