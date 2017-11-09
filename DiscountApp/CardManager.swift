//
//  CardManager.swift
//  DiscountApp
//
//  Created by andriibilan on 10/31/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import UIKit
import CoreData
class CardManager: NSObject {
    
    
    
    func createCard( name: String? , descript: String? , date: Date? ,frontImage: String? , backImage: String? , barCode: String?, filter: String){
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Card", in: context)
        let newCard = NSManagedObject(entity: entity!, insertInto: context)
            newCard.setValue(name, forKey: "cardName")
            newCard.setValue(descript, forKey: "cardDescription")
            newCard.setValue(date, forKey: "cardDate")
            newCard.setValue(frontImage, forKey: "cardFrontImage")
            newCard.setValue(backImage, forKey: "cardBackImage")
            newCard.setValue(barCode, forKey: "cardBarCode")
            newCard.setValue(filter, forKey: "cardFilter")
        saveData()
    }
    
    
    func editCard(card: Card, name: String? , descript: String? , date: Date?, frontImage: String? , backImage: String?, barCode: String?, filter: String){
        card.cardName = name
        card.cardDescription = descript
        card.cardDate = date
        card.cardFrontImage = frontImage
        card.cardBackImage = backImage
        card.cardBarCode = barCode
       card.cardFilter = filter
         saveData()
    }
    
    func chooseSegmentOfFilter( segment: UISegmentedControl) -> String {
      let  index = segment.selectedSegmentIndex
        switch index {
        case 0:
            return "Shop"
        case 1:
            return "Food"
        case 2:
            return "Cafe"
        case 3:
            return "Pharmacy"
        case 4:
            return "Other"
        default:
            return "Other"
        }
    }
    
    func showSegment(value: String) -> Int {
        switch value {
        case "Shop":
           return  0
        case "Food":
            return  1
        case "Cafe":
            return  2
        case "Pharmacy":
            return  3
        default:
            return 4
        }
        
        
    }
    func addToUrl (_ photo: UIImage )  -> String {
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let uuidStringforURL = UUID().uuidString + ".jpg"
        let imgPath = URL(fileURLWithPath: documentDirectoryPath.appendingPathComponent(uuidStringforURL))// Change extension if you want to save as PNG
        let imageString = String(describing: imgPath)
        print(imageString)
        do{
            try UIImageJPEGRepresentation(photo, 1.0)?.write(to: imgPath, options: .atomic)
        }catch let error{
            print(error.localizedDescription)
        }
        return uuidStringforURL
        
    }
    func loadImageFromPath(path: String) -> UIImage? {
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let imageURL = URL(fileURLWithPath: documentDirectoryPath.appendingPathComponent(path))
        do {
            let imageData = try Data(contentsOf: imageURL)
            return UIImage(data: imageData)
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    func getContext() ->NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
        
    }
    
//    func storeObj(){
//        let context = getContext()
//        let entity = NSEntityDescription.entity(forEntityName: "Card", in: context)
//
//        let  manageObj = NSManagedObject(entity: entity!, insertInto: context)
//
//
//    }
    
    func saveData(){
        do {
            try getContext().save()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchData(filter: String?) -> [Card]{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName :"Card")
        if filter != nil && filter != ""  {
            fetchRequest.predicate = NSPredicate(format: "cardFilter == %@", filter!)
            var cardArray:[Card] = []
            do{
                cardArray = (try getContext().fetch(fetchRequest) as? [Card])!
            }
            catch {
                print("Error fetch")
            }
            return cardArray
        } else {
            do {
                var cardArray: [Card] = []
                cardArray = try getContext().fetch(Card.fetchRequest()) as! [Card]
                return cardArray
            } catch {
                let cardArray: [Card] = []
                return cardArray
            }
            
        }
        
        
    }
 
    
   
    
    
}







