//
//  ViewController.swift
//  Project28-30 CL
//
//  Created by R R on 02/03/2021.
//

import UIKit

class ViewController: UICollectionViewController {
    
    var list = ["one","two","three","four","five","six","seven","eight","nine","1","2","3","4","5","6","7","8","9"]
    var listShuffled = [String]()
    var touchCount = 0
    var loadIndexPath = [IndexPath]()
    var itemCompare = [String]()
    var returnFlag = false
    var score = 0
    var gameTimer: Timer?
    var timeStart = 0
    var startButton: UIBarButtonItem!
    var restartButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        listShuffled = list.shuffled()
      
        startButton = UIBarButtonItem(title: "Play", style: .plain, target: self, action: #selector(startGame))
        
        navigationItem.rightBarButtonItem = startButton
        
        restartButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(restart))
        
        navigationItem.leftBarButtonItem = restartButton
        
        view.isUserInteractionEnabled = false
        
        title = "Project28-30 CL"
        
    }
    
    @objc func startGame(){
        
        let ac = UIAlertController(title: "👍", message: "Game beings now", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: {[weak self] _ in
            self?.view.isUserInteractionEnabled = true
            
            self?.gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self!, selector: #selector(self!.gameClock), userInfo: nil, repeats: true)
            
            self?.navigationItem.rightBarButtonItem = nil
            
        }))
        present(ac, animated: true)
        
    }
    
    @objc func restart(){
        gameOver()
    }
    
        
   @objc  func gameClock(){
        timeStart += 1
        
        if let footer = collectionView.supplementaryView(forElementKind: "UICollectionElementKindSectionFooter", at: [0,0]) as? CollectionFooter{
            footer.footerLabel.text = String("Score: \(score)  Time: \(timeString(time: TimeInterval(timeStart)))")
        }
    }

    
    func timeString(time: TimeInterval) -> String {
        let hour = Int(time) / 3600
        let minute = Int(time) / 60 % 60
        let second = Int(time) % 60
        return String(format: "%02i:%02i:%02i", hour, minute, second)
    }

    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CollectionCell else{
            fatalError("cell error")
       }
        cell.titleLabel.text = listShuffled[indexPath.item]
        cell.backImage.image = UIImage(named: "blue3")
        cell.titleLabel.isHidden = true
        cell.backImage.isHidden =  false
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        //print(kind)
        guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath) as? CollectionFooter else{
            fatalError("footer error")
        }
        footer.footerLabel.text = "Score:\(score)  Time: 00:00:00 "
        return footer
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        touchCount += 1

        if touchCount > 2{
            touchCount = 1

            loadIndexPath.removeAll(keepingCapacity: true)
            itemCompare.removeAll(keepingCapacity: true)
        }

        loadIndexPath.append(indexPath)
        itemCompare.append(listShuffled[indexPath.item])
        
        
        if let cell = collectionView.cellForItem(at: indexPath) as? CollectionCell{
            if cell.backImage.isHidden == false{
                UIView.transition(from:  cell.backImage, to:  cell.titleLabel, duration: 0.5, options: UIView.AnimationOptions.transitionFlipFromLeft, completion: { _ in
                    cell.backImage.isHidden = true
                    cell.titleLabel.isHidden = false
                    cell.isUserInteractionEnabled = false
                })
            }
        }
        
        
        if touchCount == 2{
            
            view.isUserInteractionEnabled = false
            
            if compare(){
                
                for index in loadIndexPath{
                    if let cell = collectionView.cellForItem(at: index) as? CollectionCell{
                        cell.backImage.isHidden = true
                        cell.titleLabel.isHidden = false
                        view.isUserInteractionEnabled = true
                        cell.backgroundColor = UIColor.black
                    }
                }
               
                score += 1
                
                if let footer = collectionView.supplementaryView(forElementKind: "UICollectionElementKindSectionFooter", at: [0,0]) as? CollectionFooter{
                    footer.footerLabel.text = String("Score: \(score)  Time: \(timeString(time: TimeInterval(timeStart)))")
                }
                
                if score == 9 {
                    print("Game Over")
                    gameOver()
                }
                
            }else{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {
                   
                    for index in self.loadIndexPath{
                        
                        if let cell = collectionView.cellForItem(at: index) as? CollectionCell{
                            cell.backgroundColor = UIColor.brown
                            
                            UIView.transition(from:  cell.titleLabel, to:  cell.backImage, duration: 0.5, options: UIView.AnimationOptions.transitionCurlDown, completion: {  _ in
                                
                                cell.backImage.isHidden = false
                                cell.titleLabel.isHidden = true
                                cell.backgroundColor = UIColor.darkGray
                                cell.isUserInteractionEnabled = true
                                
                                self.view.isUserInteractionEnabled = true
                                
                            })
                        }
                    }
                }
            }//else
        }
        
    }
    
    func gameOver(){
        
        touchCount = 0
        loadIndexPath.removeAll()
        itemCompare.removeAll()
        gameTimer?.invalidate()

        let ac = UIAlertController(title: "🎉", message: "Score:\(score) at \(timeString(time: TimeInterval(timeStart)))", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self]  _ in

            self?.score = 0
            self?.timeStart = 0
            
            if let footer = self?.collectionView.supplementaryView(forElementKind: "UICollectionElementKindSectionFooter", at: [0,0]) as? CollectionFooter{
                footer.footerLabel.text = String("Score: \(self!.score)  Time: \(self!.timeString(time: TimeInterval(self!.timeStart)))")
            }

            self?.view.isUserInteractionEnabled = false
            
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                
                self!.listShuffled.removeAll()
                self!.listShuffled.append(contentsOf: self!.list.shuffled())
                //print(self!.listShuffled)
                
                for (index,_) in self!.list.enumerated(){
                    
                    if let cell = self!.collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? CollectionCell{
                        
                        cell.backgroundColor = UIColor.darkGray
                        
                        UIView.transition(from:  cell.titleLabel, to:  cell.backImage, duration: 0.5, options: UIView.AnimationOptions.transitionCurlDown, completion: {  _ in
                            
                            cell.backImage.isHidden = false
                            cell.titleLabel.isHidden = true
                            cell.isUserInteractionEnabled = true
                            cell.titleLabel.text = self?.listShuffled[index]
                            
                            self?.navigationItem.rightBarButtonItem = self?.startButton
                           
                        })
                    }
                }
            }
            
        }))
        present(ac, animated: true)
        
    }
    
    
    
    func compare()-> Bool{
        
        let itemOne = itemCompare[0]
        let itemTwo = itemCompare[1]
        
        switch itemOne {
        case "one":
            if itemTwo == "1"{
                returnFlag = true
            }else{
                returnFlag = false
            }
            
        case "two":
            if itemTwo == "2"{
                returnFlag = true
            }else{
                returnFlag = false
            }
            
        case "three":
            if itemTwo == "3"{
                returnFlag = true
            }else{
                returnFlag = false
            }
            
        case "four":
            if itemTwo == "4"{
                returnFlag = true
            }else{
                returnFlag = false
            }
            
        case "five":
            if itemTwo == "5"{
                returnFlag = true
            }else{
                returnFlag = false
            }
            
        case "six":
            if itemTwo == "6"{
                returnFlag = true
            }else{
                returnFlag = false
            }
            
        case "seven":
            if itemTwo == "7"{
                returnFlag = true
            }else{
                returnFlag = false
            }
            
        case "eight":
            if itemTwo == "8"{
                returnFlag = true
            }else{
                returnFlag = false
            }
        
        case "nine":
            if itemTwo == "9"{
                returnFlag = true
            }else{
                returnFlag = false
            }
            
        case "1":
            if itemTwo == "one"{
                returnFlag = true
            }else{
                returnFlag = false
            }
            
        case "2":
            if itemTwo == "two"{
                returnFlag = true
            }else{
                returnFlag = false
            }
            
        case "3":
            if itemTwo == "three"{
                returnFlag = true
            }else{
                returnFlag = false
            }
            
        case "4":
            if itemTwo == "four"{
                returnFlag = true
            }else{
                returnFlag = false
            }
            
        case "5":
            if itemTwo == "five"{
                returnFlag = true
            }else{
                returnFlag = false
            }
            
        case "6":
            if itemTwo == "six"{
                returnFlag = true
            }else{
                returnFlag = false
            }
            
        case "7":
            if itemTwo == "seven"{
                returnFlag = true
            }else{
                returnFlag = false
            }
            
        case "8":
            if itemTwo == "eight"{
                returnFlag = true
            }else{
                returnFlag = false
            }
         
        case "9":
            if itemTwo == "nine"{
                returnFlag = true
            }else{
                returnFlag = false
            }
            
            
        default:
            returnFlag = false
        }
        
        
        return returnFlag
    }
    
}

