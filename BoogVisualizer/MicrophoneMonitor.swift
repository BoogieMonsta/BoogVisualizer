//
//  MicrophoneMonitor.swift
//  BoogVisualizer
//
//  Created by Ahmed D'Ala on 3/26/22.
//

import Foundation
import AVFoundation

// inherits from ObservableObject
class MicrophoneMonitor: ObservableObject {
    
    private var audioRecorder: AVAudioRecorder
    private var timer: Timer?
    
    private var currentSample: Int
    private let numberOfSamples: Int
    
    // make soundSamples an Observable
    @Published public var soundSamples: [Float]
    
    init(numberOfSamples: Int) {
        
        // make sure numberOfSamples is always > 0 to avoid bugs
        self.numberOfSamples = numberOfSamples > 0 ? numberOfSamples : 1
        self.soundSamples = [Float](repeating: .zero, count: numberOfSamples)
        self.currentSample = 0
        
        let audioSession = AVAudioSession.sharedInstance()
        if audioSession.recordPermission != .granted {
            audioSession.requestRecordPermission { (isGranted) in
                if !isGranted {
                    fatalError("Please allow audio recording")
                }
            }
        }
        
        // settings to record microphone audio
        // TODO: change this url so we can save audio recordings
        let url = URL(fileURLWithPath: "/dev/null", isDirectory: true)
        let recorderSettings: [String:Any] = [
            AVFormatIDKey: NSNumber(value: kAudioFormatAppleLossless),
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue
        ]
        
        // necessary to play and record audio on user's phone
        do {
            audioRecorder = try AVAudioRecorder(url: url, settings: recorderSettings)
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [])
            
            startMonitoring()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    // called in init
    private func startMonitoring() {
        
        // metering was disabled by default, we enable it to track the sound level
        audioRecorder.isMeteringEnabled = true
        audioRecorder.record()
        
        // set time interval to lower value for higher def/more bars in the visualization
        timer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true, block: { (timer) in
            
            // refresh average and peak values for all channels of the recorder
            self.audioRecorder.updateMeters()
            
            // calculate average power per channel
            self.soundSamples[self.currentSample] = self.audioRecorder.averagePower(forChannel: 0)
            self.currentSample = (self.currentSample + 1) % self.numberOfSamples
        })
    }
    
    // clean up
    deinit {
        timer?.invalidate()
        audioRecorder.stop()
    }
}
