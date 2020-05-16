//
//  RecordViewCountroller.swift
//  PitchPerfect_v1
//
//  Created by Haitham Alsharif on 5/8/20.
//  Copyright © 2020 Haitham Alsharif. All rights reserved.
//

import UIKit
import AVFoundation

class RecordViewCountroller: UIViewController, AVAudioRecorderDelegate{

    var audioRecorder: AVAudioRecorder!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButtonOutlet: UIButton!
    @IBOutlet weak var stopRecordingButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButtonOutlet.isEnabled = false
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewwillAppear is up")
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        
        setUpUI(true,false,"Recording in Progress")
        
        // AVFoundation audio recorder code below
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        print(filePath)
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
  
    
    @IBAction func stopRecording(_ sender: Any) {
        
        setUpUI(false, true, "Tab to record")
        
        // AVFoundation audio recorder code below
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("Recording was not successful")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    // function to be reused for whenever recording state changes in the UI
    func setUpUI(_ stopRecordingButtonOutletEnabled:Bool,_ recordButtonEnabeled:Bool,_ recordingLabelText:String){
        stopRecordingButtonOutlet.isEnabled = stopRecordingButtonOutletEnabled
        recordButtonOutlet.isEnabled = recordButtonEnabeled
        recordingLabel.text = recordingLabelText
    }
    
}

