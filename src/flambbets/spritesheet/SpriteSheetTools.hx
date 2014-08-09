// This class is a Static Extension
package flambbets.spritesheet;

import haxe.ds.StringMap;

import flambe.display.Texture;

// based on: https://github.com/photonstorm/phaser/blob/master/src/animation/AnimationParser.js#L27-L96

class SpriteSheetTools {

  public static function getAllFrames(spriteSheet:Texture, frameWidth:Int, frameHeight:Int, maxFrames:Int = 0, margin:Int = 0, spacing:Int = 0):Array<Texture> {
    #if debug
      validate(spriteSheet, frameWidth, frameHeight, margin, spacing);
    #end

    var frames:Array<Texture> = new Array<Texture>();
    var width = spriteSheet.width;
    var height = spriteSheet.height;

    var row = Math.floor( (width - margin) / (frameWidth + spacing) );
    var column = Math.floor( (height - margin) / (frameHeight + spacing) );
    var totalFrames = row * column;

    if (maxFrames > 0) {
      totalFrames = maxFrames;
    }

    var x = margin;
    var y = margin;

    for (i in 0...totalFrames) {
      frames.push( spriteSheet.subTexture(x, y, frameWidth, frameHeight) );

      x += frameWidth + spacing;

      if ((x + frameWidth) > width) {
        x = margin;
        y += frameHeight + spacing;
      }
    }

    return frames;
  }

  public static function getFrame(spriteSheet:Texture, frameIndex:Int, frameWidth:Int, frameHeight:Int, margin:Int = 0, spacing:Int = 0):Texture {
    var frame:Texture = null;

    var width = spriteSheet.width;
    var height = spriteSheet.height;

    #if debug
      var row = Math.floor( (width - margin) / (frameWidth + spacing) );
      var column = Math.floor( (height - margin) / (frameHeight + spacing) );

      validate(spriteSheet, frameWidth, frameHeight, margin, spacing);

      if (frameIndex >= (row * column) || frameIndex < 0) {
        throw "invalid frameIndex argument";
      }
    #end

    var x = margin;
    var y = margin;

    if (frameIndex == 0) {
      frame = spriteSheet.subTexture(x, y, frameWidth, frameHeight);
    } else {
      for (i in 0...frameIndex) {
        x += frameWidth + spacing;

        if ((x + frameWidth) > width) {
          x = margin;
          y += frameHeight + spacing;
        }

        if (i == (frameIndex - 1)) {
          frame = spriteSheet.subTexture(x, y, frameWidth, frameHeight);
        }
      }
    }

    return frame;
  }

  #if debug
    private static function validate(spriteSheet:Texture, frameWidth:Int, frameHeight:Int, margin:Int = 0, spacing:Int = 0) {
      if (spriteSheet.width < frameWidth || spriteSheet.height < frameHeight) {
        throw "frame size can't be greater than texture size";
      }

      if (frameWidth <= 0 || frameHeight <= 0) {
        throw "frame size must be greater than zero";
      }

      if (margin < 0 || spacing < 0) {
        throw "margin and/or spacing can't be less than zero";
      }
    }
  #end
}
