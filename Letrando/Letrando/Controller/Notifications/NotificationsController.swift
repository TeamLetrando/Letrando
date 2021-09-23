//
//  NotificationsController.swift
//  Letrando
//
//  Created by Ronaldo Gomes on 20/11/20.
//

import UIKit
import UserNotifications

enum Message: String, CaseIterable {
    case text1 = "Sinto o cheiro de letrinhas... Vem procurar comigo!"
    case text2 = "Hora da sua sopa de letrinhas!"
    case text3 = "Tô ansioso para aprendermos juntos uma palavra nova!"
    case text4 = "Quem disse que aprender não pode ser  divertido?"
    case text5 = "Hey, estou com saudades de você. Vamos brincar?"
    case text6 = "Olá amigo, estou te esperando para brincar."
    case text7 = "Ai fico tão feliz quando você brica comigo! Vamos?"
    case text8 = "Está pronto para letrar comigo?"
}

class NotificationsController: UIViewController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func schenduleNotification() {
            
        let center = UNUserNotificationCenter.current()
              
        let content = UNMutableNotificationContent()
        content.title = "Aprender brincando"
        content.body = Message.allCases.randomElement()!.rawValue
        content.sound = .default
              
        let date = Date().addingTimeInterval(24 * 60 * 60) // -> 24 horas
        let dateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        //Add image
        guard let path = Bundle.main.path(forResource: "cao", ofType: "jpeg") else {return}
        let imageUrl = URL(fileURLWithPath: path)
        
        do {
            let attachment = try UNNotificationAttachment(identifier: "logo", url: imageUrl, options: nil)
            content.attachments = [attachment]
        } catch {
            print("The attachment could not be loaded")
        }
        
        // -------- Create the request ------------
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
              
        // -------- Register the request -----------
        center.add(request) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
}
