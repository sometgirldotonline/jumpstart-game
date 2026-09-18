extends CharacterBody2D


const SPEED = 300.0
var JUMP_VELOCITY = -400.0
var coins_collected = 0
var deaths = 0
@onready var all_coins = [
$"../Coin/cc",
$"../Coin2/cc",
$"../Coin3/cc",
$"../Coin4/cc",
$"../Coin5/cc",
$"../Coin6/cc",
$"../Coin7/cc",
$"../Coin8/cc",
]

	

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if not $"../areabox/CollisionShape2D".shape.collide($"../areabox/CollisionShape2D".transform,$playersowncollider.shape,transform):
		coins_collected = 0
		deaths+=1
		position = Vector2(32, 547)
		for c in all_coins:
			c.get_parent().show()
			$"../win".hide()
	for c in all_coins:
		if c.shape.collide(c.global_transform, $playersowncollider.shape, $playersowncollider.global_transform) and c.get_parent().visible:
			coins_collected+=1;
			c.get_parent().hide()
			if coins_collected == 8:
				$"../win".show()
	$"../Coin Label".text = str(coins_collected) + " Coins"
	$"../Death Label".text = str(deaths) + " Deaths"
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_key_pressed(Key.KEY_SHIFT) or Input.is_key_pressed(Key.KEY_DOWN):
		scale = Vector2(15,15)
		JUMP_VELOCITY = -500;
	else:
		scale = Vector2(44.23,44.23)
		JUMP_VELOCITY = -400;
	if $"../win/cc".shape.collide( $"../win/cc".global_transform, $playersowncollider.shape, $playersowncollider.global_transform) and  $"../win".visible:
		position = Vector2(0,0)
#areabox: for when player is out of bounds, if we are colliding we're in bounds, this is a CollisonShape2D
#playersowncollider, our players CollisonShape2D
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
