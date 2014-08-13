package flambbets.camera;

import flambe.System;
import flambe.Component;
import flambe.Entity;
import flambe.animation.AnimatedFloat;
import flambe.display.Sprite;
import flambe.math.Rectangle;

class Camera extends Component {

  public static var x:AnimatedFloat;
  public static var y:AnimatedFloat;

  // because it's instanced internally;
  private function new() {}

  override public function onUpdate(dt:Float) {
    x.update(dt);
    y.update(dt);
  }

  public static function initialize() {
    #if debug
      if (_initialized == true) {
        trace("camera the camera is already initialized");
        return;
      }

      _initialized = true;
    #end

    System.root.addChild(new Entity().add(new Camera()));

    _cameraRect = new Rectangle(0, 0, System.stage.width, System.stage.height);
    x = new AnimatedFloat(0, onChangedX);
    y = new AnimatedFloat(0, onChangedY);

    System.stage.resize.connect(onResized);
  }

  private static function onChangedX(cur:Float, prev:Float) {
    var root = System.root;
    var child = root.firstChild;
    var diff = prev - cur;

    _cameraRect.x = cur;

    while (child != null) {
      var next = child.next;
      var sprite = child.get(Sprite);
      if (sprite != null && !child.has(FixedToCamera)) {
        sprite.x._ += diff;
      }
      child = next;
    }
  }

  private static function onChangedY(cur:Float, prev:Float) {
    var root = System.root;
    var child = root.firstChild;
    var diff = prev - cur;

    _cameraRect.y = cur;

    while (child != null) {
      var next = child.next;
      var sprite = child.get(Sprite);
      if (sprite != null && !child.has(FixedToCamera)) {
        sprite.x._ += diff;
      }
      child = next;
    }
  }

  private static function onResized() {
    _cameraRect.width = System.stage.width;
    _cameraRect.height = System.stage.height;
  }

  #if debug
    private static var _initialized:Bool = false;
  #end

  // will be used for future implementations
  private static var _cameraRect:Rectangle;
}
