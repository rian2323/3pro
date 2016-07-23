//
//  FirstViewController.swift
//  3pro2
//
//  Created by 波多野　瑛子 on 2016/06/22.
//  Copyright © 2016年 波多野　瑛子. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation
import CoreMotion

class FirstViewController: UIViewController, MPMediaPickerControllerDelegate {

    var audioPlayer:AVAudioPlayer?
    var audioFile:AVAudioFile!
    
    @IBOutlet weak var musicbtn: UIImageView!
    
    @IBOutlet weak var names: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var rate: UISlider!
    @IBOutlet weak var pitch: UISlider!
    
    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var totalTime: UILabel!
    
    
    // エンジンの生成
    let audioEngine = AVAudioEngine()
    // Playerノードの生成
    let player = AVAudioPlayerNode()
    let timePitch = AVAudioUnitTimePitch()
    let manager = CMMotionManager()
    let screensize: CGSize = UIScreen.mainScreen().bounds.size
    let mag: Double = 20.0
    var vx, vy: Double?
    var count: Int = 0
    
    override func viewDidLoad() {
        print("a");
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
         messageLabel.text = ""
        super.viewDidLoad()
        vx = 0.0
        vy = 0.0
        startmove()
        
    }
    
    func startmove() {
        manager.deviceMotionUpdateInterval = 0.1
        let handler: CMDeviceMotionHandler = {
            (motionData: CMDeviceMotion?, error: NSError?) -> Void in
            self.stopmove(motionData, error: error)
        }
        manager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: handler)
    }
    
    
    func stopmove(motionData: CMDeviceMotion?, error: NSError?) {
        var xMin, xMax, yMin, yMax: Int
        var separate: Int
        xMin = Int(musicbtn.frame.width / 2)
        xMax = Int(screensize.width) - xMin
        yMin = Int(musicbtn.frame.height / 2)
        yMax = Int(screensize.height) - yMin
        if let motion = motionData {
            let gravity = motion.gravity
            vx = vx! + gravity.x * mag
            vy = vy! - gravity.y * mag
            
            var x: Int = Int(Double(musicbtn.center.x) + vx!)
            var y: Int = Int(Double(musicbtn.center.y) + vy!)
            
            if (x < xMin) {
                x = xMin; vx = 0.0
                separate = 0
            } else if (x > xMax) {
                x = xMax; vx = 0.0
                separate = 1
            }
            if (y < yMin) {
                y = yMin; vy = 0.0
                separate = 2
            } else if (y > yMax) {
                y = yMax; vy = 0.0
                separate = 3
            }
            musicbtn.center = CGPoint(x: x,y: y)
        }
    }
    



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pick(sender: AnyObject) {
        let picker = MPMediaPickerController()
        picker.delegate = self
        picker.allowsPickingMultipleItems = false
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func mediaPicker(mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        
        defer {
            dismissViewControllerAnimated(true, completion: nil)
        }
        let items = mediaItemCollection.items
        if items.isEmpty {
            return
        }
        
        let item = items[0]
        if let url = item.assetURL {
            do {
                
                // オーディオファイルの取得
                let audioFile = try AVAudioFile(forReading: url)
                let sampleRate = audioFile.fileFormat.sampleRate
                
                let duration = Double(audioFile.length) / sampleRate
                
                totalTime.text = formatTimeString(duration)
                
                if count == 0{
                // エンジンにノードをアタッチ
                
                audioEngine.attachNode(player)
                audioEngine.attachNode(timePitch)
                }
                count = 1
                
                // Playerノードとメインミキサーを接続
                audioEngine.connect(player,
                                    to: timePitch,
                                    format: audioFile.processingFormat)
                audioEngine.connect(timePitch,
                                    to: audioEngine.mainMixerNode,
                                    format: audioFile.processingFormat)
                

                
                // プレイヤのスケジュール
                audioEngine.prepare()
                player.scheduleFile(audioFile, atTime: nil) {
                    
                    print("complete")
                    
                }
                
                // エンジンの開始
                try audioEngine.start()
                
                // オーディオの再生
                //rate.slider.setValue = 1
                //pitch.setValue(0, animated: true)
                player.play()
                
                let title = item.title ?? ""
                messageLabel.text = title
                
            } catch let error {
                print(error)
            }
        } else {
            print("File not found")
        }
    }
    
   
    func mediaPickerDidCancel(mediaPicker: MPMediaPickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func formatTimeString(d: Double) -> String {
        let s: Int = Int(d % 60)
        let m: Int = Int((d - Double(s)) / 60 % 60)
        let str = String(format: "%02d:%02d", m, s)
        return str
    }
    
    @IBAction func rate(sender: AnyObject) {
        let slider = sender as! UISlider
        timePitch.rate = slider.value
    }
    
    @IBAction func pitch(sender: AnyObject) {
        let slider = sender as! UISlider
        timePitch.pitch = slider.value
    }
    
    @IBAction func pushpause(sender: AnyObject) {
        player.pause()
    }
    
    @IBAction func pushstop(sender: AnyObject) {
        player.stop()
    }
    
}

