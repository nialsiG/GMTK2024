extends Node
class_name EvolutionTree

const enums = preload("res://scripts/enums.gd")

var _evolutionBranches : Array[EvolutionChoice]
var _speedChain : Array[EvolutionChoice]
var _sizeChain : Array[EvolutionChoice]

func Apply(player : Player):
	for evol in _evolutionBranches:
		evol.Apply(player)
	pass

func GetAvailableEvolutions() -> Array[EvolutionChoice]:
	var availablesEvols : Array[EvolutionChoice] = []
	for branch in _evolutionBranches:
		availablesEvols.append_array(branch.GetAvailableEvolutions())

	AppendChainAvailableEvolution(availablesEvols, _speedChain)
	AppendChainAvailableEvolution(availablesEvols, _sizeChain)
	
	for evol in availablesEvols:
		print(evol.Name)
	return availablesEvols

func Initialize(startSize : enums.Size, startDiet : enums.Diet, startingAbility : enums.Ability):
	InitializeSizeBranch(startSize)
	_evolutionBranches.append(InitializeDietBranch(startDiet))
	InitializeSpeedChain()
	_evolutionBranches.append_array(InitializeAbilityBranches(startingAbility))
	_evolutionBranches.append(InitializeColorBranch())

func InitializeDietBranch(startDiet : enums.Diet) -> EvolutionChoice:

	var omniEvolution = OmniDietEvolutionChoice.new()
	var carniEvolution = CarniDietEvolutionChoice.new()
	var veggieEvolution = VeggieDietEvolutionChoice.new()
	
	omniEvolution.AlternativeEvolutions.append_array([veggieEvolution, carniEvolution])
	carniEvolution.AlternativeEvolutions.append_array([omniEvolution, carniEvolution])
	veggieEvolution.AlternativeEvolutions.append_array([veggieEvolution, omniEvolution])
	
	var startEvolution : EvolutionChoice = omniEvolution
	if startDiet == enums.Diet.vegetarian:
		startEvolution = veggieEvolution
	elif startDiet == enums.Diet.carnivore:
		startEvolution = carniEvolution
	startEvolution.Activate()
	return startEvolution

func AppendChainAvailableEvolution(evols : Array[EvolutionChoice], chain : Array[EvolutionChoice]):
	for evol in chain:
		if evol._isActivated:
			evols.append_array(evol.GetAvailableEvolutions())
			return


func InitializeColorBranch() -> EvolutionChoice:
	return CoatEvolutionChoice.new()

func InitializeSizeBranch(startSize : enums.Size) -> EvolutionChoice:
	var startEvolution : EvolutionChoice
	var mediumGig = GigantismEvolutionChoice.new(enums.Size.MEDIUM)
	if (startSize == enums.Size.MEDIUM):
		startEvolution = mediumGig
	var mediumLargeGig = GigantismEvolutionChoice.new(enums.Size.MEDIUMLARGE)
	if (startSize == enums.Size.MEDIUMLARGE):
		startEvolution = mediumLargeGig
	var largeGig = GigantismEvolutionChoice.new(enums.Size.LARGE)
	if (startSize == enums.Size.LARGE):
		startEvolution = largeGig
	var veryLargeGig = GigantismEvolutionChoice.new(enums.Size.VERYLARGE)
	if (startSize == enums.Size.VERYLARGE):
		startEvolution = veryLargeGig
	var megaGig = GigantismEvolutionChoice.new(enums.Size.MEGA)
	if (startSize == enums.Size.MEGA):
		startEvolution = megaGig
	var colossalGig = GigantismEvolutionChoice.new(enums.Size.COLOSSAL)
	if (startSize == enums.Size.COLOSSAL):
		startEvolution = colossalGig
		
	var megaNan = NanismEvolutionChoice.new(enums.Size.MEGA)
	var veryLargeNan = NanismEvolutionChoice.new(enums.Size.VERYLARGE)
	var largeNan = NanismEvolutionChoice.new(enums.Size.LARGE)
	var mediumLargeNan = NanismEvolutionChoice.new(enums.Size.MEDIUMLARGE)
	var mediumNan = NanismEvolutionChoice.new(enums.Size.MEDIUM)
	var mediumSmallNan = NanismEvolutionChoice.new(enums.Size.MEDIUMSMALL)
	var smallNan = NanismEvolutionChoice.new(enums.Size.SMALL)
	var verySmallNan = NanismEvolutionChoice.new(enums.Size.VERYSMALL)
	var microNan = NanismEvolutionChoice.new(enums.Size.MICRO)	
	if (startSize == enums.Size.MICRO):
		startEvolution = microNan
	var verySmallGig = GigantismEvolutionChoice.new(enums.Size.VERYSMALL)
	if (startSize == enums.Size.VERYSMALL):
		startEvolution = verySmallGig
	var smallGig = GigantismEvolutionChoice.new(enums.Size.SMALL)
	if (startSize == enums.Size.SMALL):
		startEvolution = smallGig
	var mediumSmallGig = GigantismEvolutionChoice.new(enums.Size.MEDIUMSMALL)

	_sizeChain.append_array([microNan, verySmallNan, smallNan, mediumSmallNan, mediumNan, mediumLargeNan, megaNan,
	 colossalGig, megaGig, veryLargeGig, largeGig, mediumLargeGig, mediumGig, mediumSmallGig, smallGig, verySmallGig])

	microNan.AlternativeEvolutions.append(verySmallGig)
	microNan.SourceEvolutions.append_array([verySmallGig, verySmallNan])
	verySmallNan.AlternativeEvolutions.append_array([smallGig, microNan])
	verySmallNan.SourceEvolutions.append_array([smallGig, smallNan, microNan])
	smallNan.AlternativeEvolutions.append_array([mediumSmallGig, verySmallNan])
	smallNan.SourceEvolutions.append_array([verySmallGig, verySmallNan, mediumSmallGig, mediumSmallNan])
	mediumSmallNan.AlternativeEvolutions.append_array([mediumGig, smallNan])
	mediumSmallNan.SourceEvolutions.append_array([smallGig, smallNan, mediumGig, mediumNan])
	mediumNan.AlternativeEvolutions.append_array([mediumLargeGig, mediumSmallNan])
	mediumNan.SourceEvolutions.append_array([mediumSmallGig, mediumSmallNan, mediumLargeGig, mediumLargeNan])
	mediumLargeNan.AlternativeEvolutions.append_array([largeGig, mediumNan])
	mediumLargeNan.SourceEvolutions.append_array([mediumGig, mediumNan, largeGig, largeNan])
	largeNan.AlternativeEvolutions.append_array([veryLargeGig, mediumLargeNan])
	largeNan.SourceEvolutions.append_array([mediumLargeGig, mediumLargeNan, veryLargeGig, veryLargeNan])
	veryLargeNan.AlternativeEvolutions.append_array([megaGig, largeNan])
	veryLargeNan.SourceEvolutions.append_array([largeGig, largeNan, megaGig, megaNan])
	megaNan.AlternativeEvolutions.append_array([colossalGig, veryLargeNan])
	megaNan.SourceEvolutions.append_array([colossalGig, veryLargeNan, veryLargeGig])
	colossalGig.AlternativeEvolutions.append_array([megaNan])
	colossalGig.SourceEvolutions.append_array([megaNan, megaGig])
	megaGig.AlternativeEvolutions.append_array([colossalGig, veryLargeNan])
	megaGig.SourceEvolutions.append_array([colossalGig, veryLargeNan, veryLargeGig])
	veryLargeGig.AlternativeEvolutions.append_array([megaGig, largeNan])
	veryLargeGig.SourceEvolutions.append_array([largeGig, largeNan, megaGig, megaNan])
	largeGig.AlternativeEvolutions.append_array([veryLargeGig, mediumLargeNan])
	largeGig.SourceEvolutions.append_array([mediumLargeGig, mediumLargeNan, veryLargeGig, veryLargeNan])
	mediumLargeGig.AlternativeEvolutions.append_array([largeGig, mediumNan])
	mediumLargeGig.SourceEvolutions.append_array([mediumGig, mediumNan, largeGig, largeNan])
	mediumGig.AlternativeEvolutions.append_array([mediumLargeGig, mediumSmallNan])
	mediumGig.SourceEvolutions.append_array([mediumSmallGig, mediumSmallNan, mediumLargeGig, mediumLargeNan])
	mediumSmallGig.AlternativeEvolutions.append_array([mediumGig, smallNan])
	mediumSmallGig.SourceEvolutions.append_array([smallGig, smallNan, mediumGig, mediumNan])
	smallGig.AlternativeEvolutions.append_array([mediumSmallGig, verySmallNan])
	smallGig.SourceEvolutions.append_array([verySmallGig, verySmallNan, mediumSmallGig, mediumSmallNan])
	verySmallGig.AlternativeEvolutions.append_array([smallGig, microNan])
	verySmallGig.SourceEvolutions.append_array([smallGig, smallNan, microNan])
	
	startEvolution.Activate()
	return startEvolution

func InitializeSpeedChain() -> EvolutionChoice:
	# S2 -> S1 -> N -> F1 -> F2	
	const s2Speed = 300
	const s2Acc = 500
	const s2Fric = 3000
	const s1Speed = 400
	const s1Acc = 1000
	const s1Fric = 2250
	const nSpeed = 500
	const nAcc = 1500
	const nFric = 1500
	const f1Speed = 600
	const f1Acc = 800
	const f1Fric = 1000
	const f2Speed = 700
	const f2Acc = 800
	const f2Fric = 500
	
	var fastNSpeed = FasterEvolutionChoice.new(nSpeed, nAcc, nFric)
	var fastF1Speed = FasterEvolutionChoice.new(f1Speed, f1Acc, f1Fric)
	var fastF2Speed = FasterEvolutionChoice.new(f2Speed, f2Acc, f2Fric)
	var slowF1Speed = SlowerEvolutionChoice.new(f1Speed, f1Acc, f1Fric)
	var slowNSpeed = SlowerEvolutionChoice.new(nSpeed, nAcc, nFric)
	var slowS1Speed = SlowerEvolutionChoice.new (s1Speed, s1Acc, s1Fric)
	var slowS2Speed = SlowerEvolutionChoice.new (s2Speed, s2Acc, s2Fric)
	var fastS1Speed = FasterEvolutionChoice.new(s1Speed, s1Acc, s1Fric)
	
	_speedChain.append_array([fastNSpeed, fastF1Speed, fastF2Speed, slowF1Speed, slowNSpeed, slowS1Speed, slowS2Speed, fastF1Speed])
	
	fastNSpeed.AlternativeEvolutions.append_array([fastF1Speed, slowS1Speed])
	fastNSpeed.SourceEvolutions.append_array([fastF1Speed, slowF1Speed, slowS1Speed, fastS1Speed])
	fastF1Speed.AlternativeEvolutions.append_array([fastF2Speed, slowNSpeed])
	fastF1Speed.SourceEvolutions.append_array([fastNSpeed, slowNSpeed, fastF2Speed])
	fastF2Speed.AlternativeEvolutions.append_array([slowF1Speed])
	fastF2Speed.SourceEvolutions.append_array([fastF1Speed, slowF1Speed])
	slowF1Speed.AlternativeEvolutions.append_array([slowNSpeed, fastF2Speed])
	slowF1Speed.SourceEvolutions.append_array([fastNSpeed, slowNSpeed, fastF2Speed])
	slowNSpeed.AlternativeEvolutions.append_array([fastF1Speed, slowS1Speed])
	slowNSpeed.SourceEvolutions.append_array([fastF1Speed, slowF1Speed, slowS1Speed, fastS1Speed])
	slowS1Speed.AlternativeEvolutions.append_array([slowS2Speed, fastNSpeed])
	slowS1Speed.SourceEvolutions.append_array([fastNSpeed, slowNSpeed, slowS2Speed])
	slowS2Speed.AlternativeEvolutions.append_array([fastS1Speed])
	slowS2Speed.SourceEvolutions.append_array([slowS1Speed, fastS1Speed])
	fastS1Speed.AlternativeEvolutions.append_array([fastNSpeed, slowS2Speed])
	fastS1Speed.SourceEvolutions.append_array([fastNSpeed, slowNSpeed, slowS2Speed])
		
	fastNSpeed.Activate()
	return fastNSpeed

func InitializeAbilityBranches(startAbility : enums.Ability) -> Array[EvolutionChoice]:
	var abilitiesStarter : Array[EvolutionChoice] = []

	var dashBranch = InitializeDashBranch()
	abilitiesStarter.append(dashBranch)

	var digBranch = InitializeDigBranch()
	abilitiesStarter.append(digBranch)

	dashBranch.AlternativeEvolutions.append(digBranch)
	digBranch.AlternativeEvolutions.append(dashBranch)

	if (startAbility == enums.Ability.Dig):
		digBranch.Activate()
	elif (startAbility == enums.Ability.Dash):
		dashBranch.Activate()

	return abilitiesStarter

func InitializeDashBranch() -> EvolutionChoice:
	var dashAbility = DashEvolutionChoice.new()
	var dashCooldownBonus1 = DashUpgradeEvolutionChoice.new("EVOLUTION_AGILITY", "EVOLUTION_AGILITY_DESC", "res://assets/sprites/Icons/IconAgility.png", 2, 0)
	var dashCooldownBonus2 = DashUpgradeEvolutionChoice.new("EVOLUTION_AGILITY", "EVOLUTION_AGILITY_DESC", "res://assets/sprites/Icons/IconAgility.png", 1, 0)	
	var fangAttackBonus1 = DashUpgradeEvolutionChoice.new("EVOLUTION_FANG","EVOLUTION_FANG_DESC", "res://assets/sprites/Icons/IconFang.png", 1, 0)
	var fangAttackBonus2 = DashUpgradeEvolutionChoice.new("EVOLUTION_FANG","EVOLUTION_FANG_DESC", "res://assets/sprites/Icons/IconFang.png", 2, 0)
	var fangAttackBonus3 = DashUpgradeEvolutionChoice.new("EVOLUTION_FANG","EVOLUTION_FANG_DESC", "res://assets/sprites/Icons/IconFang.png", 3, 0)
	dashAbility.SubEvolutions.append(fangAttackBonus1)
	dashAbility.SubEvolutions.append(dashCooldownBonus1)
	fangAttackBonus1.SubEvolutions.append(fangAttackBonus2)
	fangAttackBonus2.SubEvolutions.append(fangAttackBonus3)
	dashCooldownBonus1.SubEvolutions.append(dashCooldownBonus2)
	return dashAbility

func InitializeDigBranch() -> EvolutionChoice:
	var digAbility = DigEvolutionChoice.new()
	var digCooldownBonus1 = DigUpgradeEvolutionChoice.new("EVOLUTION_DIG_CD", "EVOLUTION_DIG_CD_DESC", "res://assets/sprites/Icons/IconDig.png", 0, 5, 0, 0)
	var digCooldownBonus2 = DigUpgradeEvolutionChoice.new("EVOLUTION_DIG_CD", "EVOLUTION_DIG_CD_DESC", "res://assets/sprites/Icons/IconDig.png", 0, 4, 0, 0)
	var digCooldownBonus3 = DigUpgradeEvolutionChoice.new("EVOLUTION_DIG_CD", "EVOLUTION_DIG_CD_DESC", "res://assets/sprites/Icons/IconDig.png", 0, 3, 0, 0)

	var digDurationBonus1 = DigUpgradeEvolutionChoice.new("EVOLUTION_DIG_DURATION", "EVOLUTION_DIG_DURATION_DESC", "res://assets/sprites/Icons/IconDig.png", 0, 0, 3, 0)
	var digDurationBonus2 = DigUpgradeEvolutionChoice.new("EVOLUTION_DIG_DURATION", "EVOLUTION_DIG_DURATION_DESC", "res://assets/sprites/Icons/IconDig.png", 0, 0, 4, 0)
	var digDurationBonus3 = DigUpgradeEvolutionChoice.new("EVOLUTION_DIG_DURATION", "EVOLUTION_DIG_DURATION_DESC", "res://assets/sprites/Icons/IconDig.png", 0, 0, 5, 0)

	var digAttackBonus1 = DigUpgradeEvolutionChoice.new("EVOLUTION_DIG_ATTACK", "EVOLUTION_DIG_ATTACK_DESC", "res://assets/sprites/Icons/IconDig.png", 1, 0, 0, 0)
	var digAttackBonus2 = DigUpgradeEvolutionChoice.new("EVOLUTION_DIG_ATTACK", "EVOLUTION_DIG_ATTACK_DESC", "res://assets/sprites/Icons/IconDig.png", 2, 0, 0, 0)
	var digAttackBonus3 = DigUpgradeEvolutionChoice.new("EVOLUTION_DIG_ATTACK", "EVOLUTION_DIG_ATTACK_DESC", "res://assets/sprites/Icons/IconDig.png", 3, 0, 0, 0)

	var digSpeedBonus1 = DigUpgradeEvolutionChoice.new("EVOLUTION_DIG_SPEED", "EVOLUTION_DIG_SPEED_DESC", "res://assets/sprites/Icons/IconDig.png", 0, 0, 0, 0.75)
	var digSpeedBonus2 = DigUpgradeEvolutionChoice.new("EVOLUTION_DIG_SPEED", "EVOLUTION_DIG_SPEED_DESC", "res://assets/sprites/Icons/IconDig.png", 0, 0, 0, 1)

	digAbility.SubEvolutions.append_array([digCooldownBonus1, digDurationBonus1, digAttackBonus1, digSpeedBonus1])	
	digCooldownBonus1.SubEvolutions.append(digCooldownBonus2)
	digCooldownBonus2.SubEvolutions.append(digCooldownBonus3)
	digAttackBonus1.SubEvolutions.append(digAttackBonus2)
	digAttackBonus2.SubEvolutions.append(digAttackBonus3)
	digSpeedBonus1.SubEvolutions.append(digSpeedBonus2)
	digDurationBonus1.SubEvolutions.append(digDurationBonus2)
	digDurationBonus2.SubEvolutions.append(digDurationBonus3)
	return digAbility
