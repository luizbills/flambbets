package urgame;

import flambe.Entity;
import flambe.System;
import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.display.PatternSprite;

import flambbets.BackgroundScroller;

class Main {
    private static function main () {
        // Wind up all platform-specific stuff
        System.init();

        // Load up the compiled pack in the assets directory named "bootstrap"
        var manifest = Manifest.fromAssets("bootstrap");
        var loader = System.loadAssetPack(manifest);
        loader.get(onSuccess);
    }

    private static function onSuccess (pack :AssetPack)
    {
        // the background
        var background = new PatternSprite(pack.getTexture('tile'), System.stage.width, System.stage.height);

        // make it moves to down in 100 pixels per second
        var scroller = new BackgroundScroller(0, 100);

        // put on entity
        var entity = new Entity().add(background).add(scroller);

        // add to world
        System.root.addChild(entity);
    }
}
