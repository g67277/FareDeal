//: Playground - noun: a place where people can play

import UIKit
import Foundation

var str = "Hello, playground"

//var str2 = "African Restaurant"
//var test = str2.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
//

let numbers = 1...25

for n in numbers {
    
    //set the flag to true initially
    var prime = true
    
    
    for var i = 2; i <= n - 1; i++ {
        
        //even division of a number thats not 1 or the number itself, not a prime number
        if n % i == 0 {
            prime = false
            break
        }
    }
    
    if prime == false {
        println("\(n) is not a prime number.")
        
    }  else {
        
        println("\(n) is a prime number.")
        
    }
    
    
}

var testing  = 1...20

for test in testing{
    var prime = true
    for var i = 2; i <= test - 1; i++ {
        if test % i == 0 {
            prime = false
            break
        }
    }
    
    if prime{
        println("prime")
    }
        
    
}



