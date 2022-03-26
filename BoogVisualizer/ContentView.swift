//
//  ContentView.swift
//  BoogVisualizer
//
//  Created by Ahmed D'Ala on 3/26/22.
//

import SwiftUI

let numberOfSamples: Int = 40

struct ContentView: View {
    
    @State private var sampleStartCursor: Double = 21
    @State private var sampleEndCursor: Double = -73
    
    @ObservedObject private var mic = MicrophoneMonitor(numberOfSamples: numberOfSamples)
    
    private func normalizeSoundLevel(level: Float) -> CGFloat {
        let level = max(0.2, CGFloat(level) + 50) / 2 // between 0.1 and 25
        
        return CGFloat(level * (200 / 25)) // bar: 200 max height
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                HStack(spacing: 5) {
                    ForEach(mic.soundSamples, id: \.self) { level in
                        BarView(value: self.normalizeSoundLevel(level: level))
                    }
                }

            }
            Button {
                print("REC button pressed")
            } label: {
                Circle()
                    .fill(Color.red)
                    .frame(width: 100, height: 100)
                    .position(x: 195, y: 650)
            }
            Slider(value: $sampleStartCursor, in: 0...100)
                .frame(width: 300, height: 10)
                .position(x: 195, y: 80)
            Text("Sample Start")
                .colorInvert()
                .position(x: 95, y: 50)
            Slider(value: $sampleEndCursor, in: -100...0)
                .frame(width: 300, height: 10)
                .rotationEffect(Angle(degrees: 180))
                .position(x: 195, y: 180)
            Text("Sample End")
                .colorInvert()
                .position(x: 295, y: 150)
            Rectangle()
                .fill(Color.blue)
                .frame(width: 3, height: 250)
                .position(x: (sampleStartCursor/100)*280+55, y: 382)
            Rectangle()
                .fill(Color.blue)
                .frame(width: 3, height: 250)
                .position(x: (sampleEndCursor/100)*280+335, y: 381)
                .rotationEffect(Angle(degrees: 180))
                
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            
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
