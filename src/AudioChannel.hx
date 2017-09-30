package;

import haxe.ds.Option;
import haxe.io.Float32Array;

using OptionTools;

class AudioChannel extends NativeChannel {

    public static inline var DEFAULT_SAMPLE_RATE : Float = 44100.0;

    public static var sampleRate(get, null) : Float;
    public static function get_sampleRate() : Float {
        // TODO: Better way to get on native?
        #if js
        return switch( NativeChannel.getContext().option() ) {
            case Some(context) : context.sampleRate;
            case None : DEFAULT_SAMPLE_RATE;
        }
        #else
        return DEFAULT_SAMPLE_RATE;
        #end
    }

    public var generator : Option<Float32Array->Void> = None;

    public function new( bufferSamples : Int ) {
        super(bufferSamples);
    }

    override function onSample( out : Float32Array ) {
        switch( generator ) {
            case Some( generator ) : generator(out);
            case None : for( i in 0...out.length ) out.set(i, 0.0);
        }
	}
}