package com.alexandrratush.ane
{
    import com.alexandrratush.ane.utils.SystemUtil;

    import flash.events.EventDispatcher;
    import flash.events.StatusEvent;
    import flash.external.ExtensionContext;

    public class CookieManagerExtension extends EventDispatcher
    {
        public static const EXTENSION_ID:String = "com.alexandrratush.ane.CookieManager";
        public static const ERROR_EVENT:String = "error";

        private static var _instance:CookieManagerExtension;
        private static var _isConstructing:Boolean;

        private var _context:ExtensionContext;

        public function CookieManagerExtension()
        {
            if (!_isConstructing) throw new Error("Singleton, use CookieManagerExtension.getInstance()");
//            if (!isSupported) throw new Error("CookieManagerExtension is not supported on this platform. Use CookieManagerExtension.isSupported getter.");
            _context = ExtensionContext.createExtensionContext(EXTENSION_ID, "");
            _context.addEventListener(StatusEvent.STATUS, onStatusEventHandler);
        }

        public static function getInstance():CookieManagerExtension
        {
            if (_instance == null)
            {
                _isConstructing = true;
                _instance = new CookieManagerExtension();
                _isConstructing = false;
            }
            return _instance;
        }

        public function init():void
        {
            const FUNCTION:String = "init";
            _context.call(FUNCTION);
        }

        public function removeAllCookie():void
        {
            const FUNCTION:String = "removeAllCookie";
            _context.call(FUNCTION);
        }

        public function getCookie(url:String):String
        {
            const FUNCTION:String = "getCookie";
            return _context.call(FUNCTION, url) as String;
        }

        private function onStatusEventHandler(e:StatusEvent):void
        {

        }

        public function dispose():void
        {
            _context.removeEventListener(StatusEvent.STATUS, onStatusEventHandler);
            _context.dispose();
            _context = null;
        }

        public static function get isSupported():Boolean
        {
            return SystemUtil.isAndroid();
        }
    }
}
