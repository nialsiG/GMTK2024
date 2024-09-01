extends AbilityManager
class_name ThrowManager

var _storageSize = 0
var _storedFood : Array[StoredFood]

func CanPerform() -> bool:
	return _isActive && _storedFood.size() > 0

func GetFoodToThrow() -> StoredFood:
	if (_storedFood.size() > 0):
		var thrownFood = _storedFood[_storedFood.size() - 1]
		_storedFood.remove_at(_storedFood.size() - 1)
		if (_storedFood.size() == 0):
			_playerHud.UpdateDashCooldown(false)
		return thrownFood

	return null

func AddStorageSize(size : int):
	_storageSize += size

func Store(amount: int, foodType : enums.FoodType):
	if (_storageSize == 0):
		return

	var newStoredFood = StoredFood.new()
	newStoredFood.foodCost = amount / 2
	newStoredFood.type = foodType
	if (_storedFood.size() > 0):
		_storedFood.remove_at(0)
	
	_storedFood.append(newStoredFood)
	_playerHud.UpdateDashCooldown(true)
