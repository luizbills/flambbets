package flambbets.spritesheet;

import haxe.ds.StringMap;

import flambe.display.Texture;

// based on: https://github.com/photonstorm/phaser/blob/master/src/animation/AnimationParser.js#L27-L96

class SpriteSheetManager {

  public static function create(name:String, texture:Texture, frameWidth:Int, frameHeight:Int, maxFrames:Int = -1, margin:Int = 0, spacing:Int = 0) {
    var frames = new Array<Texture>();

    #if debug
      if (texture == null) {
        throw "argument texture of component Spritesheet can't be null";
      }

      if (texture.width < frameWidth || texture.height < frameHeight) {
        throw "frame size of component Spritesheet can't be greater than texture size";
      }

      if (frameWidth <= 0 || frameHeight <= 0) {
        throw "frame size of component Spritesheet must be greater than zero";
      }

      if (margin < 0 || spacing < 0) {
        throw "margin and spacing of component Spritesheet can't be less than zero";
      }
    #end

    var width = texture.width;
    var height = texture.height;

    var row = Math.floor( (width - margin) / (frameWidth + spacing) );
    var column = Math.floor( (height - margin) / (frameHeight + spacing) );
    var totalFrames = row * column;

    if (maxFrames > 0) {
      totalFrames = maxFrames;
    }

    var x = margin;
    var y = margin;

    for (i in 0...totalFrames) {
      frames.push( texture.subTexture(x, y, frameWidth, frameHeight) );

      x += frameWidth + spacing;

      if ((x + frameWidth) > width) {
          x = margin;
          y += frameHeight + spacing;
      }
    }

    _collection.set(name, frames);
  }

  public static function getFrame(name:String, frameIndex:Int):Texture {
    var frames = _collection.get(name);

    if (frames == null || frameIndex < 0 || frameIndex >= frames.length) {
      return null;
    }

    return frames[frameIndex];
  }

  public static function getAllFrames(name:String):Array<Texture> {
    var frames = _collection.get(name);

    if (frames == null) {
      return null;
    }

    return frames.slice(0);
  }

  public static function remove(name:String) {
    _collection.remove(name);
  }

  public static function reset() {
    _collection = new StringMap<Array<Texture>>();
  }

  private static var _collection:StringMap<Array<Texture>> = new StringMap<Array<Texture>>();
}
