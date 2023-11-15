using Godot;
using System;

public partial class GunBot : CharacterBody2D
{
	private static float _gravity = 9.78f;

	[Export]
	public float MoveSpeed = 50.0f;

	private NavigationAgent2D _navAgent;	
	private Area2D _sightArea;
	private AnimatedSprite2D _sprite;

	[Export]
	private Timer _fireTimer;
	private Line2D _bulletLine;
	[Export]
	private RayCast2D _bulletRay;
	private float _fireAngle;
	private int _bulletState;
	private float _nextTargetAngle;

	private bool _dead = false;

	public bool Stop = false;

	[Export]
	public AudioStreamPlayer ShotSound;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		_navAgent = GetNode<NavigationAgent2D>("NavAgent");
		_sightArea = GetNode<Area2D>("SightArea");
		_sprite = GetNode<AnimatedSprite2D>("GunBotSprite");
		_bulletLine = _sprite.GetNode<Line2D>("BulletLine");
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		if (_bulletState > 0 && _bulletState < 4)
		{
			_bulletLine.Visible = true;
			_bulletState++;
		} else {
			_bulletLine.Visible = false;
			_bulletState = 0;
		}
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
			_bulletLine.RotationDegrees = 180;
		} else 
		{
			_sprite.FlipH = false;
			_bulletLine.RotationDegrees = 0;
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
		if (_dead) { return; }
		_dead = true;
		GetNode<CollisionShape2D>("Collider").Position = new Vector2(0, 14);
		_sprite.Animation = "die";
	}

	public void HandlePlayerDetected(Node2D body) 
	{
		_navAgent.TargetPosition = body.GlobalTransform.Origin;

		if (_fireTimer.IsStopped() && !((bool)body.Get("Dead"))) {
			_nextTargetAngle = _bulletLine.GlobalTransform.Origin.AngleToPoint(body.GlobalTransform.Origin);
			_fireTimer.Start();
		}	
	}

	public void Fire()
	{
		if (_dead) { return; }

		_bulletLine.Rotation = _nextTargetAngle;
		_bulletRay.Rotation = _bulletLine.Rotation;	

		_bulletState = 1;
		ShotSound.Play();
		if (_bulletRay.GetCollider() is Node2D collider)
			{
				_bulletLine.RemovePoint(1);
				_bulletLine.AddPoint(new Vector2(_bulletLine.GlobalPosition.DistanceTo(_bulletRay.GetCollisionPoint()), 0));
				if (collider.GetGroups().Contains("Player")) 
				{
					GetParent().GetParent().GetNode("death_scene").CallDeferred("dead");
					collider.Call("Die");
				}
			} else 
			{
				_bulletLine.RemovePoint(1);
				_bulletLine.AddPoint(new Vector2(300, 0));
			}

		if (_sightArea.HasOverlappingBodies() && !((bool)_sightArea.GetOverlappingBodies()[0].Get("Dead")))
		{
			_nextTargetAngle = _bulletLine.GlobalTransform.Origin.AngleToPoint(_sightArea.GetOverlappingBodies()[0].GlobalTransform.Origin);
			_fireTimer.Start();
		}
	}
}
