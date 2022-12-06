using Godot;
using System;

public class Player : KinematicBody2D
{
	// Declare member variables here. 
	[Export] public float RunSpeed = 100.0f;
	[Export] public float JumpSpeed = -400.0f;
	[Export] public float Gravity = 1200.0f;
	
	bool movementEnabled = true;
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(float delta)  
	{
		var velocity = Vector2.Zero;
		
		// -- MOVEMENT --
		// Get User Input
		if (Input.IsActionPressed("guard") && IsOnFloor()) {
			movementEnabled = false;
		}
		if (Input.IsActionPressed("left") && movementEnabled) {
			velocity.x -= RunSpeed;
		}
		if (Input.IsActionPressed("right") && movementEnabled) {
			velocity.x += RunSpeed;
		}
		if (Input.IsActionPressed("jump") && IsOnFloor() && movementEnabled) {
			velocity.y = JumpSpeed;
		}
		
		velocity.y += Gravity * delta;
		
		velocity = MoveAndSlide(velocity, new Vector2(0, -1));
		
		
	}
}
