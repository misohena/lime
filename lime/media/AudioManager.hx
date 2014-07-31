package lime.media;


import lime.media.openal.AL;
import lime.media.openal.ALC;
import lime.media.openal.ALContext;
import lime.media.openal.ALDevice;

#if js
import js.Browser;
#end


class AudioManager {
	
	
	public static var context:AudioContext;
	
	
	public static function destroy ():Void {
		
		if (context != null) {
			
			switch (context) {
				
				case OPENAL (alc, al):
					
					var currentContext = alc.getCurrentContext ();
					
					if (currentContext != null) {
						
						var device = alc.getContextsDevice (currentContext);
						alc.makeContextCurrent (null);
						alc.destroyContext (currentContext);
						alc.closeDevice (device);
						
					}
				
				default:
				
			}
			
		}
		
	}
	
	
	public static function init (context:AudioContext = null) {
		
		if (context == null) {
			
			#if js
			try {
				
				untyped __js__ ("window.AudioContext = window.AudioContext || window.webkitAudioContext;");
				AudioManager.context = WEB (cast untyped __js__ ("new AudioContext ()"));
				
			} catch (e:Dynamic) {
				
				AudioManager.context = HTML5 (new HTML5AudioContext ());
				
			}
			#elseif flash
			AudioManager.context = FLASH (new FlashAudioContext ());
			#else
			AudioManager.context = OPENAL (new ALCAudioContext (), new ALAudioContext ());
			
			var device = ALC.openDevice ();
			var ctx = ALC.createContext (device);
			ALC.makeContextCurrent (ctx);
			ALC.processContext (ctx);
			
			#end
			
		} else {
			
			AudioManager.context = context;
			
		}
		
	}
	
	
	public static function play (source:AudioSource):Void {
		
		#if js
		#elseif flash
		source.src.play ();
		#else
		AL.sourcePlay (source.id);
		#end
		
	}
	
	
}