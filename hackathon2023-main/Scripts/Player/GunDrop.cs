using Godot;
using System;

public partial class GunDrop : CharacterBody2D
{
	private static float _gravity = 9.78f;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}

	public override void _PhysicsProcess(double delta)
	{
		Velocity = Velocity + new Vector2(0, _gravity);
		if (IsOnFloor()) 
		{
			Velocity = Velocity.Lerp(new Vector2(0, Velocity.Y), 0.1f);
		} else 
		{
			Velocity = Velocity.Lerp(new Vector2(0, Velocity.Y), 0.01f);
		}
		MoveAndSlide();
		//GD.Print(Velocity);
	}
}
