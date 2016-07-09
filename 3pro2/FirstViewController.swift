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

class FirstViewController: UIViewController, MPMediaPickerControllerDelegate {

    var audioPlayer:AVAudioPlayer?
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var rate: UISlider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
         messageLabel.text = ""
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
                audioPlayer = try AVAudioPlayer(contentsOfURL: url)
            } catch  {
                messageLabel.text = "再生できないよ"
                audioPlayer = nil
                return
                
            }
            if let player = audioPlayer {
                
                player.enableRate = true
                player.rate = rate.value
                player.play()
                let title = item.title ?? ""
                messageLabel.text = title
                
            }
        } else {
            messageLabel.text = "再生できないよ"
            
            audioPlayer = nil
        }
        
    }
    
   
    func mediaPickerDidCancel(mediaPicker: MPMediaPickerController) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func rate(sender: AnyObject) {
        let slider = sender as! UISlider
        
        if let player = audioPlayer {
            player.rate = slider.value
        }

    }
    
    @IBAction func pushplay(sender: AnyObject) {
        if let player = audioPlayer {
        player.play()
        }
    }
    
    
    @IBAction func pushpause(sender: AnyObject) {
        if let player = audioPlayer {
        player.pause()
        }
    }
    
    @IBAction func pushstop(sender: AnyObject) {
        if let player = audioPlayer {
        player.stop()
        }
    }
    
}

