//
//  ContentView.swift
//  BetterRest
//
//  Created by Aarav Sinha on 30/05/24.
//

import SwiftUI
import CoreML

struct ContentView: View {
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 0
    
    @State private var alertTitle = ""
    @State private var isShowing = false
    @State private var message = ""
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    
    @State private var wakeUp = defaultWakeTime
    
    var body: some View {
        NavigationStack{
            ZStack {
                LinearGradient(colors: [.teal, .mint], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                Form{
                    VStack{
                        Text("When do you want to wake up?")
                            .font(.headline)
                        DatePicker("Wake up Time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                    .padding()
                    
                    VStack {
                        Text("How much sleep do you need?")
                            .font(.headline)
                        Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                            .padding(.horizontal, 30)
                    }
                    .padding()
                    
                    VStack {
                        Text("How much coffee do you drink in a day?")
                            .font(.headline)
                        Stepper("^[\(coffeeAmount) cup](inflect: true)", value: $coffeeAmount, in: 0...20)
                            .padding(.horizontal, 40)
                    }
                    .padding()
                }
                .alert(alertTitle, isPresented: $isShowing){
                    Button("OK") {}
                } message: {
                    Text(message)
                }
                .navigationTitle("BetterRest")
                .toolbar {
                    Button("Calculate", action: calculateSleepTime)
                
                }
            }
        }
        
    }
    
    func calculateSleepTime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60 * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            alertTitle = "Your ideal bedtime is"
            message = sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            alertTitle = "Error"
            message = "Sorry, there was a problem calculating your bedtime."
        }
        
        isShowing = true
    }
}
    

#Preview {
    ContentView()
}
