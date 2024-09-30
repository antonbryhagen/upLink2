//
//  Settings.swift
//  upLink 2
//
//  Created by Anton Bryhagen on 2024-09-30.
//

import SwiftUI

struct Settings: View {
    @State private var deviceId: String = ""
    @State private var clientId: String = ""
    @State private var clientSecret: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("myUplink Credentials")) {
                        TextField("Device ID", text: $deviceId)
                        TextField("Client ID", text: $clientId)
                        TextField("Client Secret", text: $clientSecret)
                    }
                    Section {
                        Button(action: {
                            saveCreds()
                        }) {
                            Text("Save")
                        }
                    }
                }
            }
            .navigationTitle("Settings")
        }
        
    }
    
    func saveCreds(){
        
    }
}

#Preview {
    Settings()
}
