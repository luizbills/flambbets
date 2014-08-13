package urgame;

import flambe.System;
import flambe.Component;
import flambbets.camera.Camera;
import flambe.input.*;

class CameraController extends Component {

  public var speed(default, set):Float;

  public function new(speed:Float) {
    this.speed = speed;
  }

  override public function onUpdate(dt:Float) {
    var isDown = System.keyboard.isDown;

    if (isDown(Key.Up)) {
      Camera.y._ -= 100 * dt;
    }
    if (isDown(Key.Down)) {
      Camera.y._ += 100 * dt;
    }
    if (isDown(Key.Left)) {
      Camera.x._ -= 100 * dt;
    }
    if (isDown(Key.Right)) {
      Camera.x._ += 100 * dt;
    }
  }

  function set_speed(value:Float) {
    if (value < 0) {
      value *= -1;
    }
    speed = value;
    return speed;
  }
}
