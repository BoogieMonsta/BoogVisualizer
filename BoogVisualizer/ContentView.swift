//
//  ContentView.swift
//  BoogVisualizer
//
//  Created by Ahmed D'Ala on 3/26/22.
//

import SwiftUI

let numberOfSamples: Int = 85

struct ContentView: View {
    
    @State private var sampleStartCursor: Double = 21
    @State private var sampleEndCursor: Double = 12
    
    @ObservedObject private var mic = MicrophoneMonitor(numberOfSamples: numberOfSamples)
    
    private func normalizeSoundLevel(level: Float) -> CGFloat {
        let level = max(0.2, CGFloat(level) + 50) / 2 // between 0.1 and 25
        
        return CGFloat(level * (150 / 25)) // bar: 150 max height
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            // Visualization
            VStack {
                HStack(spacing: 5) {
                    ForEach(mic.soundSamples, id: \.self) { level in
                        BarView(value: self.normalizeSoundLevel(level: level))
                    }
                }
            }.position(x: 330, y: 100)
            
            // REC button
            Button {
                print("REC button pressed")
            } label: {
                Circle()
                    .fill(Color.red)
                    .frame(width: 50, height: 50)
                    .position(x: 705, y: 100)
            }
            
            // Sample start slider
            Slider(value: $sampleStartCursor, in: 0...100)
                .frame(width: 597, height: 10)
                .position(x: 330, y: 240)
            Text("Sample Start")
                .colorInvert()
                .position(x: 95, y: 210)
            // cursor
            Rectangle()
                .fill(Color.blue)
                .frame(width: 3, height: 200)
                .position(x: (sampleStartCursor/100)*597+32, y: 95)
            
            // Sample end slider
            Slider(value: $sampleEndCursor, in: 0...100)
                .frame(width: 597, height: 10)
                .rotationEffect(Angle(degrees: 180))
                .position(x: 330, y: 305)
            Text("Sample End")
                .colorInvert()
                .position(x: 580, y: 275)
            //cursor
            Rectangle()
                .fill(Color.blue)
                .frame(width: 3, height: 250)
                .position(x: (sampleEndCursor/100)*597+149, y: 298)
                .rotationEffect(Angle(degrees: 180))
                
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            ContentView()
                .previewInterfaceOrientation(.landscapeLeft)
        } else {
            // Fallback on earlier versions
        }
            
    }
}

struct BarView: View {
    var value: CGFloat

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(.white)
                .frame(
                    width: CGFloat(2), height: value
                )
        }
    }
}
