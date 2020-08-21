extends Resource

class_name MonsterGroup

export (Array, Resource) var monsters
export (int) var xp
export (int) var cheeze

# A group of monsters that will attack the player at once.
# It takes an array of (monster) Attacker resources.
# XP and gold are what the player will be awarded for winning.
