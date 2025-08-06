//
//  ContentView.swift
//  Currency
//
//  Created by Mukhammademin Eminov on 8/5/25.
//

import SwiftUI

struct ContentView: View {
    @State private var input = "" //for TextField
    let usdRate = 12000.0
    let eurRate = 13000.0
    
    
    @State private var selectedCurrency = "USD -> UZS"
    let currencies = ["UZS → USD", "UZS → EUR", "USD → UZS", "EUR → UZS"]
    
    var convertedAmount: Double {
        guard let amount = Double(input) else { return 0 }
        
        switch selectedCurrency {
        case "UZS → USD": return amount / usdRate
        case "UZS → EUR": return amount / eurRate
        case "USD → UZS": return amount * usdRate
        case "EUR → UZS": return amount * eurRate
        default : return 0
        }
    }
    var outputCurrencySymbol: String {
        switch selectedCurrency {
        case "UZS → USD", "USD → UZS":
            return "USD"
        case "UZS → EUR", "EUR → UZS":
            return "EUR"
        default:
            return ""
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Enter amount")) {
                    HStack {
                        TextField("e.g 1000", text: $input)
                            .keyboardType(.decimalPad)
                            .submitLabel(.done)
                        Spacer()
                        Text(selectedCurrency.prefix(3))
                            .foregroundColor(.gray)
                    }
                }
                
                Section(header: Text("Currency")) {
                    
                    Picker("Select currency", selection: $selectedCurrency) {
                        ForEach(currencies, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Section(header: Text("Converted amount")) {
                    if input.isEmpty {
                        Text("Enter amount to convert")
                    } else {
                        Text("\(convertedAmount, specifier: convertedAmount <= 0.01 ? "%.4f" : "%.2f") \(outputCurrencySymbol)")
                    }
                }
            }
            
            .navigationTitle("Currency converter")
        }
        
    }

}

#Preview {
    ContentView()
}
