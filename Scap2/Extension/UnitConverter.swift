//
//  UnitConverter.swift
//  OtpChat
//
//  Created by Md. Mehedi Hasan on 2/3/23.
//

public class UnitConverter {
    
    //MARK: Time Unit Conversions
    
    public func convertSecondsToMinutes(_ seconds: Double) -> Double {
        return seconds / 60
    }
    
    public func convertMinutesToSeconds(_ minutes: Double) -> Double {
        return minutes * 60
    }
    
    public func convertHoursToMinutes(_ hours: Double) -> Double {
        return hours * 60
    }
    
    public func convertMinutesToHours(_ minutes: Double) -> Double {
        return minutes / 60
    }
    
    public func convertDaysToHours(_ days: Double) -> Double {
        return days * 24
    }
    
    public func convertHoursToDays(_ hours: Double) -> Double {
        return hours / 24
    }
    
    //MARK: Distance Unit Conversions
    
    public func convertMetersToKilometers(_ meters: Double) -> Double {
        return meters / 1000
    }
    
    public func convertKilometersToMeters(_ kilometers: Double) -> Double {
        return kilometers * 1000
    }
    
    public func convertMilesToKilometers(_ miles: Double) -> Double {
        return miles * 1.60934
    }
    
    public func convertKilometersToMiles(_ kilometers: Double) -> Double {
        return kilometers / 1.60934
    }
    
    public func convertFeetToMeters(_ feet: Double) -> Double {
        return feet / 3.28084
    }
    
    public func convertMetersToFeet(_ meters: Double) -> Double {
        return meters * 3.28084
    }
}
