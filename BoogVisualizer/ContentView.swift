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
    @State private var sampleEndCursor: Double = 10
    
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
            
            ZStack {
                // REC button
                Button {
                    print("REC button pressed")
                } label: {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 50, height: 50)
                        .position(x: 705, y: 80)
                }
                
                // STOP/SAVE button
                Button {
                    print("STOP button pressed")
                } label: {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.white)
                        .frame(width: 47, height: 47)
                        .position(x: 705, y: 185)
                }
                Circle()
                    .fill(Color.white)
                    .frame(width: 42, height: 42)
                    .position(x: 705, y: 185)
                Text("S")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .position(x: 705, y: 185)
                
                // PLAY button
                Button {
                    print("PLAY button pressed")
                } label: {
                    Triangle()
                        .fill(Color.green)
                        .frame(width: 55, height: 50)
                        .rotationEffect(Angle(degrees: 90))
                        .position(x: 705, y: 295)
                }
            }
            
            // Sample start slider
            Group {
                let sliderMaxValue: Double = 99
                Slider(value: $sampleStartCursor, in: 0...sliderMaxValue)
                    .frame(width: 597, height: 10)
                    .position(x: 330, y: 240)
                Text("TRIM START")
                    .colorInvert()
                    .position(x: 80, y: 210)
                // beginning muted
                Rectangle()
                    .fill(Color.black)
                    .frame(width: (sampleStartCursor/100)*597+32, height: 150)
                    .position(x: ((sampleStartCursor/100)*597+32)/2, y: 100)
                    .opacity(0.8)
                // cursor
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: 3, height: 200)
                    .position(x: (sampleStartCursor/100)*597+32, y: 95)
            }
            
           
            
            // Sample end slider
            Group {
                let sliderMinValue: Double = 99
                Slider(value: $sampleEndCursor, in: 0...sliderMinValue)
                    .frame(width: 597, height: 10)
                    .rotationEffect(Angle(degrees: 180))
                    .position(x: 330, y: 305)
                Text("TRIM END")
                    .colorInvert()
                    .position(x: 590, y: 335)
                // ending muted
                Rectangle()
                    .fill(Color.black)
                    .frame(width: (sampleEndCursor/100)*597, height: 165)
                    .position(x: ((sampleEndCursor/100)*597)/2+148, y: 265)
                    .rotationEffect(Angle(degrees: 180))
                    .opacity(0.8)
                //cursor
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: 3, height: 250)
                    .position(x: (sampleEndCursor/100)*597+149, y: 298)
                    .rotationEffect(Angle(degrees: 180))
            }
                
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            ContentView()
                .previewInterfaceOrientation(.landscapeLeft)
        } else {
            // TODO: Fallback on earlier versions
        }
            
    }
}

struct BarView: View {
    var value: CGFloat

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.white)
                .frame(
                    width: CGFloat(2), height: value
                )
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))

        return path
    }
}
