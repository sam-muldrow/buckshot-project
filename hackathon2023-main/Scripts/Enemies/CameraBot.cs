using Godot;
using System;

public partial class CameraBot : CharacterBody2D
{
	private static float _gravity = 9.78f;

	[Export]
	public float MoveSpeed = 50.0f;

	private NavigationAgent2D _navAgent;	
	private Area2D _sightArea;
	private AnimatedSprite2D _sprite;

	private bool _dead = false;

	public bool Stop = false;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		_navAgent = GetNode<NavigationAgent2D>("NavAgent");
		_sightArea = GetNode<Area2D>("SightArea");
		_sprite = GetNode<AnimatedSprite2D>("EnemySprite");
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}

	public override void _PhysicsProcess(double delta) 
	{
		if (Stop) { return; }

		if (_dead) 
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
			return;
		} else if (_navAgent.IsNavigationFinished()) 
		{ 
			_sprite.Animation = "static";
			return; 
		}

		if (_sightArea.HasOverlappingBodies()) 
		{
			_navAgent.TargetPosition = _sightArea.GetOverlappingBodies()[0].GlobalTransform.Origin;
		}

		_sprite.Animation = "move";

		Vector2 currentPosition = GlobalTransform.Origin;
		Vector2 nextPathPosition = _navAgent.GetNextPathPosition();

		Velocity = (nextPathPosition - currentPosition).Normalized() * MoveSpeed;
		if (Velocity.X < 0)
		{
			_sprite.FlipH = true;
		} else 
		{
			_sprite.FlipH = false;
		}
		MoveAndSlide();
	}

	private async void ActivateNavigation()
	{
		// Wait for the first physics frame
		await ToSignal(GetTree(), SceneTree.SignalName.PhysicsFrame);

		_navAgent.TargetPosition = GlobalTransform.Origin;
	}

	public void Die()
	{
		if (_dead || Stop) { return; }
		_dead = true;
		GetNode<CollisionShape2D>("Collider").Position = new Vector2(0, 9);
		GetNode<Area2D>("death_node/Area2D").Monitoring = false;
		_sprite.Animation = "die";
	}

	public void HandlePlayerDetected(Node2D body) 
	{
		if (_dead || Stop) { return; }
		_navAgent.TargetPosition = body.GlobalTransform.Origin;
	}
}
