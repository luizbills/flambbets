package flambbets;

import flambe.System;
import flambe.Component;
import flambe.display.PatternSprite;
import flambe.math.Point;

// Based on: https://github.com/aduros/flambe-demos/blob/master/shmup/src/shmup/BackgroundScroller.hx

/**
 * Component to create parallax effect
 *
 * note: this component requires PatternSprite Component
 */
class BackgroundScroller extends Component {

  public var speed(default, null):Point;

  public function new (speedX:Float = 0, speedY:Float = 0) {
    speed = new Point(speedX, speedY);
  }

  override public function onAdded() {
    _backgroundImage = owner.get(PatternSprite);

    #if debug
      if (_backgroundImage == null) {
        throw "component BackgroundScroller requires flambe.display.PatternSprite";
      }
    #end

    _backgroundImage.setSize(
      _backgroundImage.width._ + _backgroundImage.texture.width,
      _backgroundImage.height._ + _backgroundImage.texture.height
    );
  }

  override public function onUpdate (dt:Float) {
    if (speed.x != 0) {
      _backgroundImage.x._ += dt * speed.x;
      if (_backgroundImage.x._ > 0 && speed.x > 0) {
        _backgroundImage.x._ = _backgroundImage.texture.width * -1;
      } else if (_backgroundImage.x._ + _backgroundImage.texture.width < 0 && speed.x < 0) {
        _backgroundImage.x._ = 0;
      }
    }

    if (speed.y != 0) {
      _backgroundImage.y._ += dt * speed.y;
      if (_backgroundImage.y._ > 0 && speed.y > 0) {
        _backgroundImage.y._ = _backgroundImage.texture.height * -1;
      } else if (_backgroundImage.y._ + _backgroundImage.texture.height < 0 && speed.y < 0) {
        _backgroundImage.y._ = 0;
      }
    }
  }

  private var _backgroundImage:PatternSprite;
}
