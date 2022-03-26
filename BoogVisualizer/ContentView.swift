//
//  ContentView.swift
//  BoogVisualizer
//
//  Created by Ahmed D'Ala on 3/26/22.
//

import SwiftUI

let numberOfSamples: Int = 40

struct ContentView: View {
    @ObservedObject private var mic = MicrophoneMonitor(numberOfSamples: numberOfSamples)
    
    private func normalizeSoundLevel(level: Float) -> CGFloat {
        let level = max(0.2, CGFloat(level) + 50) / 2 // between 0.1 and 25
        
        return CGFloat(level * (250 / 25)) // bar: 250 max height
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
