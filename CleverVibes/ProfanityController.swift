//
//  ProfanityController.swift
//  CleverVibes
//
//  Created by Josh Safran on 5/3/17.
//  Copyright © 2017 Josh Safran. All rights reserved.
//

import Foundation

class ProfanityController{
    static let profanityList = [
        "anal",
        "anus",
        "arse",
        "ass",
        "ballsack",
        "balls",
        "bastard",
        "bitch",
        "biatch",
        "bloody",
        "blowjob",
        "blow job",
        "bollock",
        "bollok",
        "boner",
        "boob",
        "bugger",
        "bum",
        "butt",
        "buttplug",
        "clit",
        "clitoris",
        "cock",
        "coon",
        "crap",
        "cunt",
        "damn",
        "dick",
        "dildo",
        "dyke",
        "fag",
        "feck",
        "fellate",
        "fellatio",
        "felching",
        "fuck",
        "f u c k",
        "fudgepacker",
        "fudge packer",
        "flange",
        "Goddamn",
        "God damn",
        "hell",
        "homo",
        "jerk",
        "jizz",
        "knobend",
        "knob end",
        "labia",
        "lmao",
        "lmfao",
        "muff",
        "nigger",
        "nigga",
        "omg",
        "penis",
        "piss",
        "poop",
        "prick",
        "pube",
        "pussy",
        "queer",
        "scrotum",
        "sex",
        "shit",
        "s hit",
        "sh1t",
        "slut",
        "smegma",
        "spunk",
        "tit",
        "tosser",
        "turd",
        "twat",
        "vagina",
        "wank",
        "whore",
        "wtf"]

    static func doesStringContainProfanity(str:String)->Bool{
        for profanity in profanityList{
            if(str.contains(profanity)){
                return true;
            }
        }
        return false;
    }
}
