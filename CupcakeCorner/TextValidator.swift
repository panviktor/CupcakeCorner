//
//  TextValidator.swift
//  CupcakeCorner
//
//  Created by Виктор on 18.06.2020.
//  Copyright © 2020 SwiftViktor. All rights reserved.
//

import Foundation

//MARK: - TextField Validator
class ValidationError: Error {
    var message: String
    
    init(_ message: String) {
        self.message = message
    }
}

protocol ValidatorConvertible {
    func validated(_ value: String) throws ->  Bool
}

enum ValidatorType {
    case name, streetAddress, city, zip
}

enum ValidatorFactory {
    static func validatorFor(type: ValidatorType) -> ValidatorConvertible {
        switch type {
        case .name:
            return UserNameValidator()
        case .streetAddress:
            return StreetNameValidator()
        case .city:
            return CityNameValidator()
        case .zip:
            return ZipCodeValidator()
        }
    }
}

struct UserNameValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> Bool {
        guard value.utf16.count >= 3 else {
            throw ValidationError("Username must contain more than three characters" )
        }
        guard value.utf16.count < 18 else {
            throw ValidationError("Username shoudn't conain more than 18 characters" )
        }
        
        do {
            if try NSRegularExpression(pattern: "^[a-z]{1,18}$",  options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.utf16.count)) == nil {
                throw ValidationError("Invalid username, username should not contain whitespaces, numbers or special characters")
            }
        } catch {
            throw ValidationError("Invalid username, username should not contain whitespaces, or special characters")
        }
        return true
    }
}

struct StreetNameValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> Bool {
        guard value.utf16.count >= 3 else {
            throw ValidationError("Street name must contain more than three characters" )
        }
        guard value.utf16.count < 50 else {
            throw ValidationError("Street name shoudn't conain more than 18 characters" )
        }
        
        do {
            if try NSRegularExpression(pattern: "^[a-z0-9#&'-/\\s]{1,50}$",  options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.utf16.count)) == nil {
                throw ValidationError("Invalid Street name, street name should not special characters")
            }
        } catch {
            throw ValidationError("Invalid street name, street name should not contain special characters")
        }
        return true
    }
}

struct CityNameValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> Bool {
        guard value.utf16.count >= 3 else {
            throw ValidationError("The city name must contain more than three characters" )
        }
        guard value.utf16.count < 30 else {
            throw ValidationError("The city name contain more than 30 characters" )
        }
        
        do {
            if try NSRegularExpression(pattern: "^[a-z0-9'-/\\s]{1,30}$",  options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.utf16.count)) == nil {
                throw ValidationError("Invalid username, username should not contain special characters")
            }
        } catch {
            throw ValidationError("Invalid username, username should not contain characters")
        }
        return true
    }
}

struct ZipCodeValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> Bool {
        guard value.utf16.count >= 4 else {
            throw ValidationError("ZIP Code must contain more than 4 characters" )
        }
        guard value.utf16.count < 6 else {
            throw ValidationError("ZIP Code shoudn't conain more than 6 characters" )
        }
        return true
    }
}


//extension Order {
//    func validatedText(validationType: ValidatorType, text: String) throws -> Bool {
//        let validator = ValidatorFactory.validatorFor(type: validationType)
//        return try validator.validated(text)
//    }
//    
//    var hasValidAddress: Bool {
//        do {
//            let validatedName = try validatedText(validationType: ValidatorType.name, text: name)
//            let validatedStreetAddress = try validatedText(validationType: ValidatorType.streetAddress, text: streetAddress)
//            let validatedCity = try validatedText(validationType: ValidatorType.city, text: city)
//            let validatedZIP = try validatedText(validationType: ValidatorType.zip, text: zip)
//            return validatedName && validatedStreetAddress && validatedCity && validatedZIP
//        } catch(let error) {
//            print((error as! ValidationError).message)
//        }
//        return false
//    }
//}

extension NewOrderStruct {
    func validatedText(validationType: ValidatorType, text: String) throws -> Bool {
        let validator = ValidatorFactory.validatorFor(type: validationType)
        return try validator.validated(text)
    }
    
    var hasValidAddress: Bool {
        do {
            let validatedName = try validatedText(validationType: ValidatorType.name, text: name)
            let validatedStreetAddress = try validatedText(validationType: ValidatorType.streetAddress, text: streetAddress)
            let validatedCity = try validatedText(validationType: ValidatorType.city, text: city)
            let validatedZIP = try validatedText(validationType: ValidatorType.zip, text: zip)
            return validatedName && validatedStreetAddress && validatedCity && validatedZIP
        } catch(let error) {
            print((error as! ValidationError).message)
        }
        return false
    }
}
