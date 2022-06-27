//
//  AdvViewController.swift
//  SplashAd
//
//  Created by EricSue on 16/05/2018.
//  Copyright © 2018 EricSue. All rights reserved.
//

import UIKit

class AdViewController: UIViewController {
    
    let adUrl = "adUrl"
    
    @IBOutlet weak var bigImg: UIImageView!
    
    @IBOutlet weak var timeButton: UIButton!
    
    
    //延迟5s
    private var time:TimeInterval = 5.0
    
    private var countdownTimer:Timer?
    
    override func viewWillAppear(_ animated: Bool) {
        //异步加载图片
        getAdImage()
//        let url = URL(string:"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1526472818832&di=7bae513a2258c9b23aace1fe63fdcea8&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F013c81583fa08ea8012060c864c3b7.jpg")
//        let data = try? Data(contentsOf: url!)
//        if data != nil {
//            let image = UIImage(data: data!)
//            bigImg.image = image
//        }
        let image = "pic.jpg"//UserDefaults.standard.value(forKey: adImageName) as! String? ?? " "
        let filePath = NSHomeDirectory().appending("/Documents/\(image)")
        let isExist = self.isFileExist(withFilePath: (filePath))
        if isExist {
            bigImg.image = UIImage(contentsOfFile: filePath)
        }
        else {
            bigImg.image = UIImage(named: "launch.jpg")
     
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bigImg.frame = self.view.frame
        
        timeButton.setTitleColor(UIColor.white, for: .normal)
        timeButton.layer.cornerRadius = 6
        
        //延迟参数
        DispatchQueue.main.asyncAfter(deadline:DispatchTime.now() + time){
            let storyboard = UIStoryboard(name:"Main",bundle:nil)
            let rootVC = storyboard.instantiateInitialViewController()
            UIApplication.shared.keyWindow?.rootViewController = rootVC
        }
        
        //倒计时
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        
    }
    
    @objc func updateTime(){
        time -= 1
        if time > 0 {
            timeButton.setTitle(String(format:"%.fs后跳过",time), for: .normal)
        }
        else {
            countdownTimer?.invalidate()
            countdownTimer = nil
        }
    }
    
    //点击直接跳转
    @IBAction func pushAction(_ sender: Any) {
        countdownTimer?.invalidate()
        countdownTimer = nil
        let storyboard = UIStoryboard(name:"Main",bundle:nil)
        let rootVC = storyboard.instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = rootVC
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //初始化广告页面
    func getAdImage() {
        // TODO 请求广告接口
        // 这里原本采用美团的广告接口，现在了一些固定的图片url代替
        var imageArray: [Any] = [ "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1526472818832&di=7bae513a2258c9b23aace1fe63fdcea8&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F013c81583fa08ea8012060c864c3b7.jpg"]
        
        
        let imageUrl: String = imageArray[0] as! String
        //        // 获取图片名
        //        let stringArr: [Any] = imageUrl.components(separatedBy: "/")
        let imageName: String = "pic.jpg"//(stringArr.last as! String?)!
        // 拼接沙盒路径
        let filePath: String = NSHomeDirectory().appending("/Documents/\(imageName)")
        let isExist: Bool = self.isFileExist(withFilePath: filePath)
        if !isExist {
            // 如果该图片不存在，则删除老图片，下载新图片
            self.downloadAdImage(withUrl: imageUrl, imageName: imageName)
        }
    }
    
    
    //判断文件是否存在
    func isFileExist(withFilePath filePath: String) -> Bool {
        let fileManager = FileManager.default
        
        var isDirectory:ObjCBool = false
        
        return fileManager.fileExists(atPath: filePath, isDirectory :  &isDirectory)
    }
    
    //下载图片
    func downloadAdImage(withUrl imageUrl: String, imageName: String) {
        DispatchQueue.global(qos: .default).async(execute: {() -> Void in
            
            let url =  URL(string: imageUrl)
            
            let data :Data? = try? Data(contentsOf: url!)
            
            let filePath: String = NSHomeDirectory().appending("/Documents/\(imageName)")
            let fileManager = FileManager.default
            fileManager.createFile(atPath: filePath, contents: data , attributes: nil)
            self.deletImage()
            UserDefaults.standard.set(imageName, forKey: self.adUrl)
            UserDefaults.standard.synchronize()
            
        })
    }
    
    //删除图片
    func deletImage()  {
        let imageName = UserDefaults.standard.value(forKey: self.adUrl) as? String
        if imageName != nil {
            let filePath = NSHomeDirectory().appending("/Documents/\(imageName!)")
            let fileManager:FileManager = FileManager.default
            try? fileManager.removeItem(atPath: filePath)
            
        }
    }
    
}
