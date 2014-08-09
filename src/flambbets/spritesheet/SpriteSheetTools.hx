package flambbets.spritesheet;

import haxe.ds.StringMap;

import flambe.display.Texture;

/**
 * Utilities for Sprite Sheet Textures. Designed to be imported with 'using'.
 *
 * based on: https://github.com/photonstorm/phaser/blob/master/src/animation/AnimationParser.js#L27-L96
 */
class SpriteSheetTools {

  /**
   * Get all frames of a sprite sheet
   *
   * @param frameWidth Width of each frame.
   * @param frameHeight Height of each frame.
   * @param maxFrames The total number of frames to extract from the sprite sheet. The default value of 0 means "extract all frames".
   * @param margin If the frames have been drawn with a margin, specify the amount here.
   * @param spacing If the frames have been drawn with spacing between them, specify the amount here.
   * @returns An array containing all frames.
   */
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

  /**
   * Get one specific frame of a sprite sheet
   *
   * @param frameIndex the numeric index of the frame. e.g.: The first frame is the index of 0.
   * @param frameWidth Width of each frame.
   * @param frameHeight Height of each frame.
   * @param margin If the frames have been drawn with a margin, specify the amount here.
   * @param spacing If the frames have been drawn with spacing between them, specify the amount here.
   * @returns The frame, a texture.
   */
  public static function getFrame(spriteSheet:Texture, frameIndex:Int, frameWidth:Int, frameHeight:Int, margin:Int = 0, spacing:Int = 0):Texture {
    var frame:Texture = null;

    var width = spriteSheet.width;
    var height = spriteSheet.height;

    #if debug
      validate(spriteSheet, frameWidth, frameHeight, margin, spacing);

      var row = Math.floor( (width - margin) / (frameWidth + spacing) );
      var column = Math.floor( (height - margin) / (frameHeight + spacing) );

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
