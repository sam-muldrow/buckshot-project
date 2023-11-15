using Godot;
using System;

public partial class PlayerGunLaunch : CharacterBody2D
{
	private static float _gravity = 9.78f;

	private Sprite2D _handSprite;
	private Sprite2D _gunSprite;
	private Line2D _bulletLine;
	private RayCast2D _bulletRay;
	// 0 = no bullet fired, 1-3 = visisble frames
	private int _bulletState = 0;

	public bool Dead;

	[Export]
	private Timer _refireTimer;
	private bool _refireAllowed = true;

	public bool Stop;

	[Export]
	public float GunLaunchVelocity = 500.0f;

	[Export]
	public AnimatedSprite2D PlayerSprite;

	[Export]
	public AudioStreamPlayer ShotSound;

	public PackedScene GunDropScene = (PackedScene)GD.Load("res://GunDrop.tscn");

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		_handSprite = GetNode<Sprite2D>("Hands");
		_gunSprite = _handSprite.GetNode<Sprite2D>("GunSprite");
		_bulletLine = _gunSprite.GetNode<Line2D>("BulletVisual");
		_bulletRay = _gunSprite.GetNode<RayCast2D>("BulletRay");
		_refireTimer.Timeout += EnableRefire;
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		if (Stop) { return; }
		if (_bulletState > 0 && _bulletState < 4)
		{
			_bulletLine.Visible = true;
			_bulletState++;
		} else {
			_bulletLine.Visible = false;
			_bulletState = 0;
		}
	}

	public override void _Input(InputEvent @event)
	{
		if (Dead || Stop) { return; }

		if (@event is InputEventMouseButton eventMouseButton) 
		{
			if (!_refireAllowed || !eventMouseButton.Pressed || eventMouseButton.ButtonIndex != MouseButton.Left) { return; }
			Vector2 clickPosition = eventMouseButton.GlobalPosition;
			Vector2 playerPosition = GetGlobalTransformWithCanvas().Origin;
			Velocity = Velocity + (new Vector2(GunLaunchVelocity, GunLaunchVelocity) * clickPosition.DirectionTo(playerPosition));
			_bulletState = 1;
			_refireAllowed = false;
			ShotSound.Play();
			if (_bulletRay.GetCollider() is Node2D collider)
			{
				_bulletLine.RemovePoint(1);
				_bulletLine.AddPoint(new Vector2(_bulletLine.GlobalPosition.DistanceTo(_bulletRay.GetCollisionPoint()), 0));
				if (collider.GetGroups().Contains("Enemies")) 
				{
					collider.Call("Die");
				}
			} else 
			{
				_bulletLine.RemovePoint(1);
				_bulletLine.AddPoint(new Vector2(400, 0));
			}
			_refireTimer.Start();
			
		} else if (@event is InputEventMouseMotion eventMouseMotion) 
		{
			Vector2 mousePosition = eventMouseMotion.GlobalPosition;
			Vector2 playerPosition = GetGlobalTransformWithCanvas().Origin;
			_handSprite.Rotation = playerPosition.AngleToPoint(mousePosition);
			if (_handSprite.RotationDegrees > 90 || _handSprite.RotationDegrees < -90)
			{
				PlayerSprite.FlipH = true;
				_gunSprite.FlipV = true;
				_handSprite.Position = new Vector2(-6, _handSprite.Position.Y);
				_bulletLine.Position = new Vector2(13, 4);
				_bulletRay.Position = new Vector2(13, 4);
			} else
			{
				PlayerSprite.FlipH = false;
				_gunSprite.FlipV = false;
				_handSprite.Position = new Vector2(6, _handSprite.Position.Y);
				_bulletLine.Position = new Vector2(13, -2);
				_bulletRay.Position = new Vector2(13, -2);
			}
		}
	}

	public override void _PhysicsProcess(double delta)
	{
		if (Stop) { return; }

		Velocity = Velocity + new Vector2(0, _gravity);
		if (IsOnFloor()) 
		{
			if (!Dead) { PlayerSprite.Animation = "idle"; }
			Velocity = Velocity.Lerp(new Vector2(0, Velocity.Y), 0.1f);
		} else 
		{
			if (!Dead) { PlayerSprite.Animation = "jump"; }
			Velocity = Velocity.Lerp(new Vector2(0, Velocity.Y), 0.01f);
		}
		MoveAndSlide();
		//GD.Print(Velocity);
	}
	

	private void EnableRefire()
	{
		if (Dead || Stop) { return; }
		_refireAllowed = true;
	}

	public void Die()
	{
		if (Dead || Stop) { return; }
		Dead = true;
		_handSprite.Visible = false;
		var gunDrop = GunDropScene.Instantiate<CharacterBody2D>();
		GetParent().GetParent().AddChild(gunDrop);
		gunDrop.Velocity = Velocity;
		gunDrop.GlobalPosition = _gunSprite.GlobalPosition;
		if (_handSprite.RotationDegrees > 90 || _handSprite.RotationDegrees < -90)
		{
			gunDrop.GetNode<Sprite2D>("GunSprite").FlipH = true;
		}
		PlayerSprite.Animation = "die";
	}
}
