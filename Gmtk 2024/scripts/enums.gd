extends Node

enum FoodType 
{
	Consumed = 0,
	Plant = 1,
	Meat = 2
}

enum evolution
{
	NANISM = 1,
	GIGANTISM = 2,
	DIET_OMNI = 3,
	DIET_CARNI = 4,
	DIET_HERBI = 5,
	HEALTH = 6,
	AGILITY = 7,
	FANG = 8,
	EFFICIENCY = 9,
	COLOR = 10,
	LIGHTNESS = 11,
	HEAVYNESS = 12
}

enum Size
{
	MICRO = 1,
	VERYSMALL = 2,
	SMALL = 3,
	MEDIUMSMALL = 4,
	MEDIUM = 5,
	MEDIUMLARGE = 6,
	LARGE = 7,
	VERYLARGE = 8,
	MEGA = 9,
	COLOSSAL = 10
}

enum Relationship
{
	NONE = 0, 
	PREY = 1, 
	PREDATOR = 2 
}

enum State
{
	Still = 1, 
	Up = 2, 
	Down = 3, 
	Left = 4, 
	Right = 5
} 

enum Diet
{ 
	vegetarian = 1, 
	carnivore = 2, 
	omni = 3
}

enum Direction
{ 
	Up = 1, 
	Down = 2, 
	Left = 3, 
	Right = 4 
}
