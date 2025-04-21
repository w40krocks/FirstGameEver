extends CharacterBody3D

var MoveSpeed :float
var Health : float
var MaxHealth : float

func _HealthChange(HealthChange: float):
	Health = Health + HealthChange
	if Health > MaxHealth:
		Health = MaxHealth
