//
//  SensorCard.swift
//  upLink 2
//
//  Created by Anton Bryhagen on 2024-09-29.
//

import SwiftUI

struct SensorCard: View {
    
    var sensorName: String
    var sensorValue: String
    
    var body: some View {
        GroupBox(label: 
            Label(sensorName, systemImage: "thermometer.medium")
        ) {
            HStack (alignment: .top) {
                Text(sensorValue)
                    .font(.system(size: 28))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                Text("°C")
                Spacer()
            }
            .padding([.leading], 25)
            
        }
    }
}

#Preview {
    SensorCard(sensorName: "Current outd temp (BT1)", sensorValue: "22.5")
}
