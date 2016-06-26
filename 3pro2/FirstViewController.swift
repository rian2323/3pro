//
//  FirstViewController.swift
//  3pro2
//
//  Created by 波多野　瑛子 on 2016/06/22.
//  Copyright © 2016年 波多野　瑛子. All rights reserved.
//

import UIKit
import MediaPlayer

class FirstViewController: UIViewController, MPMediaPickerControllerDelegate {

    var player = MPMusicPlayerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        player = MPMusicPlayerController.applicationMusicPlayer()
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
        
        // 選択した曲情報がmediaItemCollectionに入っているので、これをplayerにセット。
        player.setQueueWithItemCollection(mediaItemCollection)
        // 再生開始
        player.play()
        // ピッカーを閉じ、破棄する
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    //選択がキャンセルされた場合に呼ばれる
    func mediaPickerDidCancel(mediaPicker: MPMediaPickerController) {
        // ピッカーを閉じ、破棄する
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func pushplay(sender: AnyObject) {
        player.play()
    }
    
    
    @IBAction func pushpause(sender: AnyObject) {
        player.pause()
    }
    
    @IBAction func pushstop(sender: AnyObject) {
        player.stop()
    }
    
}

