//
//  DataModel.swift
//  Hotel Manzana
//
//  Created by Владимир Ладыгин on 09.05.2022.
//

import Foundation

class DataModel: Codable {
    var archiveURL: URL? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first  else {
            return nil
        }
        return documentDirectory.appendingPathComponent("registrations").appendingPathExtension("json")
    }
    
    func loadRegisration() -> [Registration]? {
        guard let archiveURL = archiveURL else { return nil }
        
        guard let encodedRegistration = try? Data(contentsOf: archiveURL) else { return nil }
        
        let decoder = JSONDecoder()
        return try? decoder.decode([Registration].self, from: encodedRegistration)
        print("dates are load")
    }
    
    func saveRegistration(_ registrations: [Registration]) {
        guard let archiveURL = archiveURL else { return }
        print(archiveURL)
        
        let encoder = JSONEncoder()
        guard let encodedRegistration = try? encoder.encode(registrations) else { return }
        
        try? encodedRegistration.write(to: archiveURL, options: .noFileProtection)
print("saveDone")
        dump(registrations)
    }
}
