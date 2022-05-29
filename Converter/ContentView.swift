//
//  ContentView.swift
//  Converter
//
//  Created by Jeff Norton on 5/13/22.
//

import SwiftUI

struct ContentView: View {
    @FocusState private var inputIsFocused: Bool
    
    @State private var input = 100.0
    
    let formatter: MeasurementFormatter

    init() {
        formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        formatter.unitStyle = .long
    }
    
    var result: String {
        let inputMeasurement = Measurement(value: input, unit: inputUnit)
        let outputMeasurement = inputMeasurement.converted(to: outputUnit)

        return formatter.string(from: outputMeasurement).capitalized
    }
    
    // 1) Manual conversion
//    @State private var inputUnit = "Meters"
//    @State private var outputUnit = "Kilometers"
//
//    let units = ["Feet", "Kilometers", "Meters", "Miles", "Yards"]
//
//    var result: String {
//        let inputToMetersMultiplier: Double
//        let metersToOutputMultiplier: Double
//
//        switch inputUnit {
//        case "Feet":
//            inputToMetersMultiplier = 0.3048
//        case "Kilometers":
//            inputToMetersMultiplier = 1000
//        case "Miles":
//            inputToMetersMultiplier = 1609.34
//        case "Yards":
//            inputToMetersMultiplier = 0.9144
//        default:
//            inputToMetersMultiplier = 1.0
//        }
//
//        switch outputUnit {
//        case "Feet":
//            metersToOutputMultiplier = 3.28084
//        case "Kilometers":
//            metersToOutputMultiplier = 0.001
//        case "Miles":
//            metersToOutputMultiplier = 0.000621371
//        case "Yards":
//            metersToOutputMultiplier = 1.09361
//        default:
//            metersToOutputMultiplier = 1.0
//        }
//
//        let inputInMeters = input * inputToMetersMultiplier
//        let output = inputInMeters * metersToOutputMultiplier
//
//        let outputString = output.formatted()
//
//        return "\(outputString) \(outputUnit.lowercased())"
//    }
    
    // 2) Length conversion using Apple's framework
//    @State private var inputUnit = UnitLength.meters
//    @State private var outputUnit = UnitLength.kilometers
//
//    let units: [UnitLength] = [.feet, .kilometers, .meters, .miles, .yards]
    
    // 3) Add support to convert many kinds of things
    let conversions = ["Distance", "Mass", "Temperature", "Time"]
    let unitTypes = [
        [UnitLength.meters, UnitLength.kilometers, UnitLength.feet, UnitLength.yards, UnitLength.miles],
        [UnitMass.grams, UnitMass.kilograms, UnitMass.ounces, UnitMass.pounds],
        [UnitTemperature.celsius, UnitTemperature.fahrenheit, UnitTemperature.kelvin],
        [UnitDuration.hours, UnitDuration.minutes, UnitDuration.seconds]
    ]
    @State private var inputUnit: Dimension = UnitLength.meters
    @State private var outputUnit: Dimension = UnitLength.yards
    
    @State var selectedUnits = 0
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount", value: $input, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($inputIsFocused)
                } header: {
                    Text("Amount to convert")
                }
                
                // 1) Manual conversion
//                Picker("Convert from", selection: $inputUnit) {
//                    ForEach(units, id: \.self) {
//                        Text($0)
//                    }
//                }
//
//                Picker("Convert to", selection: $outputUnit) {
//                    ForEach(units, id: \.self) {
//                        Text($0)
//                    }
//                }
                
                // 2) Length conversion using Apple's framework
//                Picker("Convert from", selection: $inputUnit) {
//                    ForEach(units, id: \.self) {
//                        Text(formatter.string(from: $0).capitalized)
//                    }
//                }
//
//                Picker("Convert to", selection: $outputUnit) {
//                    ForEach(units, id: \.self) {
//                        Text(formatter.string(from: $0).capitalized)
//                    }
//                }
                
                // 3) Add support to convert many kinds of things
                Picker("Conversion", selection: $selectedUnits) {
                    ForEach(0..<conversions.count) {
                        Text(conversions[$0])
                    }
                }
                
                Picker("Convert from", selection: $inputUnit) {
                    ForEach(unitTypes[selectedUnits], id: \.self) {
                        Text(formatter.string(from: $0).capitalized)
                    }
                }
                
                Picker("Convert to", selection: $outputUnit) {
                    ForEach(unitTypes[selectedUnits], id: \.self) {
                        Text(formatter.string(from: $0).capitalized)
                    }
                }
                
                Section {
                    Text(result)
                } header: {
                    Text("Result")
                }
            }
            .navigationTitle("Converter")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    
                    Button("Done") {
                        inputIsFocused = false
                    }
                }
            }
            .onChange(of: selectedUnits) { newSelection in
                let units = unitTypes[newSelection]
                inputUnit = units[0]
                outputUnit = units[1]
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
