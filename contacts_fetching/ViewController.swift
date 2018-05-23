//
//  ViewController.swift
//  contacts_fetching
//
//  Created by Ruslan Suvorov on 5/22/18.
//  Copyright © 2018 Ruslan Suvorov. All rights reserved.
//

import UIKit
import Contacts

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        fetchAllContacts()
        fetchAContact(withName: "Elisa")
//        self.view.backgroundColor = .red
    }
    
    private func fetchAContact(withName name: String){
        let predicate: NSPredicate = CNContact.predicateForContacts(matchingName: name)
        let store = CNContactStore()
        
        store.requestAccess(for: .contacts) { (granted, error) in
            if let error = error {
                print("Failed to request access", error)
                return
            }
            
            if granted {
                print("Access granted status:", granted)
                let keysToFetch = [CNContactGivenNameKey, CNContactIdentifierKey]
                
                do {
                    let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch as [CNKeyDescriptor])
                    
                    for contact in contacts {
                        print(contact.givenName, contact.identifier)
                    }
                } catch let error {
                    print(error)
                }
            }
        }
    
    }
    
    private func fetchAllContacts() {
        print("Attempting to fetch contacts")
        
        let store = CNContactStore()
        
        store.requestAccess(for: .contacts) { (granted, err) in
            
            if let err = err {
                print("Failed to request access", err)
                return
            }
            
            if granted {
                print("Access granted", granted)
                
                let keysToFetch = [CNContactIdentifierKey, CNContactGivenNameKey, CNContactFamilyNameKey, CNContactSocialProfilesKey, CNContactPhoneNumbersKey, CNContactEmailAddressesKey, CNContactPostalAddressesKey]
                let request = CNContactFetchRequest(keysToFetch: keysToFetch as [CNKeyDescriptor])
                
                do {
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointerIfYouWantToStopEnumerating ) in
                        print(contact.givenName, contact.identifier)
                        for number in contact.phoneNumbers {
                            print(number.value.stringValue, number.label ?? "", number.identifier)
                        }
                        for email in contact.emailAddresses {
                            print(email)
                        }
                        for postalAddress in contact.postalAddresses {
                            print("Postal address:", postalAddress)
                        }
                        
                    })
                } catch let error {
                    print("Failed to enumerate contacts:", error)
                }
                
                
            } else {
                print("Access denied")
            }
        }
    }
    
}

