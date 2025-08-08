//
//  ContentView.swift
//  Currency
//
//  Created by Mukhammademin Eminov on 8/5/25.
//

import SwiftUI

struct Currencies {
        static let usd = Currency(flag: "🇺🇸", code: "USD", name: "US Dollar", rate: 12000.0)
        static let eur = Currency(flag: "🇪🇺", code: "EUR", name: "Euro", rate: 13000.0)
    static let som = Currency(flag: "🇺🇿", code: "UZS", name: "So'm", rate: 1.0)
}
let currencies = [Currencies.usd, Currencies.eur, Currencies.som]

struct Currency: Hashable {
        let flag: String
        let code: String
        let name: String
        let rate: Double
        
        init(flag: String, code: String, name: String, rate: Double) {
            self.flag = flag
            self.code = code
            self.name = name
            self.rate = rate
        }
    }
    
    struct CurrencyPair {
        let from: Currency
        let to: Currency
        
        init(from: Currency, to: Currency) {
            self.from = from
            self.to = to
        }
    }
struct ContentView: View {
    
    @State private var input = "" //for TextField
    @State private var from = Currencies.som
    @State private var to = Currencies.usd
    @State private var showResult = false

    var convertedAmount: Double? {
        guard let amount = Double(input) else { return nil }
        
        let rate = withAnimation() { from.rate / to.rate }
        return amount * rate
    }
    
    var formattedConvertedAmount: String {
        if input.isEmpty {
            return "Enter amount to convert"
        }
        else if convertedAmount == nil {
            return "Invalid number"
        } else {
            let format = convertedAmount! <= 0.01 ? "%.4f" : "%.2f"
            return String(format: format, convertedAmount!) + " \(to.code)"
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
                            .onChange(of: input) { _, newValue in
                                withAnimation(.spring()) {
                                    showResult = !newValue.isEmpty
                                }
                            }
                            
                        if !input.isEmpty {
                            Button {
                                withAnimation(.spring()) {
                                    input = ""
                                }
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                }
                        }

                        Spacer()
                        Text(from.code)
                            .foregroundColor(.gray)
                    }
                }
                
                Section(header: Text("Currencies")) {
                    
                    Picker("From", selection: $from) {
                        ForEach(currencies, id: \.self) { currency in
                             Text(currency.flag + " " + currency.code)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: from) { _, _ in
                        withAnimation(.spring()) { showResult = !input.isEmpty }
                    }
                    HStack {
                        Spacer()
                        Button {
                                let temp = from
                                from = to
                                to = temp
                        } label: {
                            Image(systemName: "arrow.up.arrow.down")
                                .foregroundColor(.blue)
                        }
                        Spacer()
                    }
                    
                    Picker("To", selection: $to) {
                        ForEach(currencies, id: \.self) { currency in
                            Text(currency.flag + " " + currency.code)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: from) { _, _ in
                        withAnimation(.spring()) { showResult = !input.isEmpty }
                    }
                }
                
                Section(header: Text("Converted amount")) {
                    
                        Text(formattedConvertedAmount)
                            .font(.system(size: 28, weight: .semibold, design: .rounded))
                            .foregroundColor(.green)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .transition(.scale.combined(with: .opacity))

                }
            }
            
            .navigationTitle("Currency converter")
        }
    }
}

#Preview {
    ContentView()
}
