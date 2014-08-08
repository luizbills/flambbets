package flambbets.spritesheet;

import haxe.ds.StringMap;

import flambe.Component;
import flambe.display.ImageSprite;
import flambe.display.Texture;
import flambe.util.Signal0;

// this component requires ImageSprite Component
class SpriteSheetAnimation extends Component {

  // events
  public var onStart(default, null):Signal0 = new Signal0();
  public var onLoop(default, null):Signal0 = new Signal0();
  public var onFinish(default, null):Signal0 = new Signal0();

  public var currentAnimation(default, null):String;
  public var paused(default, set):Bool = false;

  public function new(frames:Array<Texture>) {
    _allFrames = frames;
  }

  override public function onAdded() {
    if (_pendingAnimation != null) {
      var i = _pendingAnimation.indexOf(':loop');
      if (i == -1) {
        play(_pendingAnimation);
      } else {
        play(_pendingAnimation.substring(0, i), true);
      }

      _pendingAnimation = null;
    }
  }

  override public function onUpdate(dt:Float) {
    if (currentAnimation == null || paused == true) {
      return;
    }

    _counter += dt * 1000;

    if (_counter >= _anim.timePerFrame) {
      _counter = 0;
      _curFrame++;
      if (_curFrame > _anim.lastFrame) {
        if (_animLoop == true) {
          reset();
          onLoop.emit();
        } else {
          stop();
        }
      } else {
        owner.get(ImageSprite).texture = _allFrames[_curFrame];
      }
    }
  }

  public function add(name:String, firstFrame:Int, lastFrame:Int, duration:Float):SpriteSheetAnimation {
    #if debug
      if (name.length == 0) {
        throw 'invalid animation name';
      }

      if (_animations.exists(name) == true) {
        throw 'already exists an animation named $name';
      }

      if (firstFrame < 0 || lastFrame >= _allFrames.length) {
        throw 'invalid firstFrame/lastFrame argument';
      }

      if (duration <= 0) {
        throw 'argument duration must be greater than zero';
      }
    #end

    var anim = new AnimationData(firstFrame, lastFrame, duration * 1000);
    _animations.set(name, anim);

    return this;
  }

  public function play(name:String, loop:Bool = false):SpriteSheetAnimation {
    _anim = _animations.get(name);

    #if debug
      if (_anim == null) {
        throw 'animation named $name don\'t exists';
      }
    #end

    if (owner != null) {
      if (currentAnimation != null ) {
        stop();
      }

      _animLoop = loop;
      currentAnimation = name;
      reset();

      onStart.emit();
    } else {
      if (loop == true) {
        name += ':loop';
      }
      _pendingAnimation = name;
    }

    return this;
  }

  public function reset():SpriteSheetAnimation {
    if (currentAnimation != null) {
      owner.get(ImageSprite).texture = _allFrames[_anim.firstFrame];
      _curFrame = _anim.firstFrame;
      _counter = 0;
      paused = false;
    }

    return this;
  }

  public function stop():SpriteSheetAnimation {
    onFinish.emit();

    currentAnimation = null;
    owner.get(ImageSprite).texture = _defaultTexture;
    paused = false;

    return this;
  }

  function set_paused(value) {
    if (currentAnimation != null) {
      paused = value;
    }
    return paused;
  }

  private var _defaultTexture:Texture;
  private var _allFrames:Array<Texture>;

  private var _pendingAnimation:String;
  private var _animations:StringMap<AnimationData> = new StringMap<AnimationData>();
  private var _anim:AnimationData;
  private var _curFrame:Int;
  private var _counter:Float;
  private var _animLoop:Bool;
}

private class AnimationData {

  public var firstFrame:Int;
  public var lastFrame:Int;
  public var duration:Float;
  public var timePerFrame:Float;

  public function new(firstFrame:Int, lastFrame:Int, duration:Float) {
    this.firstFrame = firstFrame;
    this.lastFrame = lastFrame;
    this.duration = duration;
    timePerFrame = duration / (lastFrame - firstFrame + 1);
  }
}
