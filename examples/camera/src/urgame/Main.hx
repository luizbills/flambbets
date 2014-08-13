package urgame;

import flambe.Entity;
import flambe.System;
import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.display.*;
import flambe.input.*;

import flambbets.camera.*;

class Main {

  private static function main () {
    // Wind up all platform-specific stuff
    System.init();
    Camera.initialize();

    // Load up the compiled pack in the assets directory named "bootstrap"
    var manifest = Manifest.fromAssets("bootstrap");
    var loader = System.loadAssetPack(manifest);
    loader.get(onSuccess);

    System.root.add(new CameraController(100));
  }

  private static function onSuccess (pack :AssetPack) {
    // Add a solid color background
    var background = new FillSprite(0x202020, System.stage.width, System.stage.height);
    System.root.addChild(new Entity()
      .add(background)
      .add(new FixedToCamera())
    );

    // Add some planes
    for (i in 0...100) {
      var plane = new ImageSprite(pack.getTexture("plane"));
      plane.setXY(Math.random() * System.stage.width, 100 + Math.random() * System.stage.height);
      System.root.addChild(new Entity().add(plane));
    }

    var font = new Font(pack, "handel");
    var label = new TextSprite(font, "TEXT FIXED TO CAMERA");
    label.setXY(50, 50);
    System.root.addChild(new Entity().add(label).add(new FixedToCamera()));
  }
}

