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

  // private constructor
  // because it's instanced internally (as a single tone)
  // private function new() {}

  override public function onUpdate(dt:Float) {
    x.update(dt);
    y.update(dt);

    if (_x != x._ || _y != y._) {
      var diffX = _x - x._;
      var diffY = _y - y._;

      _cameraRect.x = _x = x._;
      _cameraRect.y = _y = y._;

      var root = System.root;
      var child = root.firstChild;

      while (child != null) {
        var next = child.next;
        var sprite = child.get(Sprite);
        if (sprite != null && !child.has(FixedToCamera)) {
          sprite.x._ += diffX;
          sprite.y._ += diffY;
        }
        child = next;
      }
    }
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
    x = new AnimatedFloat(0);
    y = new AnimatedFloat(0);

    System.stage.resize.connect(onResized);
  }

  private static function onResized() {
    _cameraRect.width = System.stage.width;
    _cameraRect.height = System.stage.height;
  }

  #if debug
    private static var _initialized:Bool = false;
  #end

  private var _x:Float = 0;
  private var _y:Float = 0;

  // will be used for future implementations
  private static var _cameraRect:Rectangle;
}
