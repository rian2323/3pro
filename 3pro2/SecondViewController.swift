//
//  SecondViewController.swift
//  3pro2
//
//  Created by 波多野　瑛子 on 2016/06/22.
//  Copyright © 2016年 波多野　瑛子. All rights reserved.
//

import UIKit
import AVFoundation

class SecondViewController: UIViewController {

    
    
    let fileManager = NSFileManager()
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    let fileName = "3pro2nd.caf"
    
    @IBOutlet weak var recordbtn: UIButton!
       
    @IBOutlet weak var playbtn: UIButton!
    
    @IBOutlet weak var stopbtn: UIButton!
    
    @IBOutlet weak var ladybtn: UIButton!
    
    @IBOutlet weak var manbtn: UIButton!
    
    
    // エンジンの生成
    let audioEngine = AVAudioEngine()
    // Playerノードの生成
    let player = AVAudioPlayerNode()
    let timePitch = AVAudioUnitTimePitch()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
      self.setupAudioRecorder()
    }

    
    @IBAction func pushrecordbtn(sender: AnyObject) {
        audioRecorder?.record()
    }
    
    
    @IBAction func pushplaybtn(sender: AnyObject) {
        self.play()
    }
    
    
    @IBAction func pushstopbtn(sender: AnyObject) {
        audioRecorder?.stop()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    func setupAudioRecorder() {
        // 再生と録音機能をアクティブ
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try! session.setActive(true)
        let recordSetting : [String : AnyObject] = [
            AVEncoderAudioQualityKey : AVAudioQuality.Min.rawValue,
            AVEncoderBitRateKey : 16,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey: 44100.0
        ]
        do {
            try audioRecorder = AVAudioRecorder(URL: self.documentFilePath(), settings: recordSetting)
        } catch {
            print("error")
        }
    }
    
    
    func play() {
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: self.documentFilePath())
        } catch {
            print("error")
        }
        audioPlayer?.play()
        
    }
    // 録音するファイルのパスを取得(録音時、再生時に参照)
    func documentFilePath()-> NSURL {
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask) as [NSURL]
        let dirURL = urls[0]
        return dirURL.URLByAppendingPathComponent(fileName)
    }



}

