import Foundation

// Character and Creature Models

struct MoominCharacter {
    var name: String
    var health: Int
    var friendship: Int
    var level: Int

    mutating func levelUp() {
        level += 1
        health += 10
        friendship += 5
        print("\n🌟 \(name) leveled up to level \(level)! Health and friendship increased.\n")
    }

    var isHealthy: Bool {
        health > 0
    }

    func stats() {
        print("\n👤 \(name)'s Stats → Health: \(health), Friendship: \(friendship), Level: \(level)")
    }
}

enum CreatureType: String {
    case Friendly, Curious, Mysterious
}

struct Creature {
    var name: String
    var mood: Int // 1 to 3, 3 is grumpiest
    var patience: Int
    var type: CreatureType

    static func randomEncounter(isDaytime: Bool) -> Creature {
        let creatures = [
            Creature(name: "The Groke", mood: 3, patience: 20, type: .Mysterious),
            Creature(name: "Hattifattener", mood: 2, patience: 15, type: .Curious),
            Creature(name: "Stinky", mood: 2, patience: 10, type: .Friendly),
            Creature(name: "Too-Ticky", mood: 1, patience: 5, type: .Friendly)
        ]
         // Select a random creature
        var selected = creatures.randomElement()!

        // Adjust mood depending on time of day
        if isDaytime {
            selected.mood = max(1, selected.mood - 1)
        } else {
            selected.mood = min(3, selected.mood + 1)
        }

        return selected
    }

    var isCalm: Bool {
        patience <= 0
    }
}

// Items

struct Item {
    let name: String
    let restoreAmount: Int
    func use(on character: inout MoominCharacter) {
        character.health += restoreAmount
        print("🧃 Used \(name)! Restored \(restoreAmount) health.")
    }
}

// Journal
var journal: [String] = []

// Game Functions

func handleEncounter(with character: inout MoominCharacter) {
    var creature = Creature.randomEncounter(isDaytime: day)
    journal.append("📖 Encountered \(creature.name) (Mood: \(creature.mood), Patience: \(creature.patience))")

    print("\n🌲 You encounter \(creature.name), a \(creature.type.rawValue) creature.")
    print("They seem to be in a mood level of \(creature.mood).")
    print("Patience: \(creature.patience)")

    while creature.patience > 0 && character.isHealthy {
        character.stats()
        print("\nWhat would you like to do?")
        print("1 - Talk to \(creature.name)")
        print("2 - Run away")

        guard let choice = readLine(), let option = Int(choice) else {
            print("❓ Invalid input. Try again.")
            continue
        }

        switch option {
        case 1:
            talkToCreature(character: &character, creature: &creature)
        case 2:
            let success = runAway(character: &character, from: creature)
            if success { return }
        default:
            print("❓ Please choose 1 or 2.")
        }
    }

    if creature.isCalm {
        print("\n🎉 \(creature.name) has calmed down. You handled it well!")
        character.levelUp()
    } else if !character.isHealthy {
        print("\n💀 Oh no! \(character.name) is too tired to continue...")
    }
}

func talkToCreature(character: inout MoominCharacter, creature: inout Creature) {
    print("🗣️ You speak to \(creature.name) with warmth.")
    creature.patience -= character.friendship

    if creature.isCalm {
        journal.append("✅ Calmed down \(creature.name) by talking.")
    } else {
        let damage = creature.mood * 3
        character.health -= damage
        print("😡 \(creature.name) wasn't ready to calm down. They spook you! You lose \(damage) health.")
        journal.append("⚠️ \(creature.name) frightened you. Lost \(damage) health.")
    }
}

func runAway(character: inout MoominCharacter, from creature: Creature) -> Bool {
    if Bool.random() {
        print("🏃‍♂️ You managed to escape from \(creature.name)!")
        journal.append("🏃 Escaped from \(creature.name).")
        return true
    } else {
        let spookDamage = 5
        character.health -= spookDamage
        print("👻 Failed to escape! \(creature.name) spooks you. You lose \(spookDamage) health.")
        journal.append("😨 Tried to escape \(creature.name) but got spooked. Lost \(spookDamage) health.")
        return false
    }
}

// Main Game Loop

var moomin = MoominCharacter(name: "Krzysztof T", health: 30, friendship: 8, level: 1)
let cocoa = Item(name: "Hot Cocoa", restoreAmount: 10)

print("🌼 Welcome to Moominvalley, \(moomin.name)!")
print("Your journey begins...\n")

var turns = 0
var day = true

while moomin.isHealthy {
    print("🕰️ It's now \(day ? "Day" : "Night") in Moominvalley.")
    handleEncounter(with: &moomin)

    // Day/Night toggle
    turns += 1
    if turns % 2 == 0 {
        day.toggle()
    }

    if moomin.health < 20 {
        print("\n🍫 Would you like to drink Hot Cocoa to restore health? (y/n)")
        if let input = readLine(), input.lowercased() == "y" {
            cocoa.use(on: &moomin)
        }
    }

    print("\n🌟 Continue exploring Moominvalley? (y/n)")
    if let again = readLine(), again.lowercased() != "y" {
        break
    }
}

print("\n📜 Moominvalley Journal:")
for entry in journal {
    print(entry)
}

print("\n🌈 Thank you for playing, brave \(moomin.name)!")
