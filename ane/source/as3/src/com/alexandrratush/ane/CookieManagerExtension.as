package com.alexandrratush.ane
{
    import flash.events.ErrorEvent;
    import flash.events.EventDispatcher;
    import flash.events.StatusEvent;
    import flash.external.ExtensionContext;
    import flash.system.Capabilities;

    public class CookieManagerExtension extends EventDispatcher
    {
        public static const EXTENSION_ID:String = "com.alexandrratush.ane.CookieManager";
        public static const ERROR_EVENT:String = "error";

        private static var _instance:CookieManagerExtension;
        private static var _isConstructing:Boolean;

        private var _context:ExtensionContext;

        public function CookieManagerExtension()
        {
            if (!isSupported) throw new Error("CookieManagerExtension is not supported on this platform. Use CookieManagerExtension.isSupported getter.");
            if (!_isConstructing) throw new Error("Singleton, use CookieManagerExtension.getInstance()");
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
            if (_context == null)
            {
                _context = ExtensionContext.createExtensionContext(EXTENSION_ID, "");
                _context.addEventListener(StatusEvent.STATUS, onStatusEventHandler);
                _context.call("init");
            }
        }

        public function removeAllCookie():void
        {
            _context.call("removeAllCookie");
        }

        public function getCookie(url:String):String
        {
            return _context.call("getCookie", url) as String;
        }

        public function setCookie(url:String, value:String):void
        {
            _context.call("setCookie", url, value);
        }

        public function acceptCookie():Boolean
        {
            return _context.call("acceptCookie");
        }

        public function setAcceptCookie(accept:Boolean):void
        {
            _context.call("setAcceptCookie", accept);
        }

        private function onStatusEventHandler(e:StatusEvent):void
        {
            if (e.level == ERROR_EVENT)
                dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, e.code));
        }

        public function dispose():void
        {
            if (_context != null)
            {
                _context.removeEventListener(StatusEvent.STATUS, onStatusEventHandler);
                _context.dispose();
                _context = null;
            }
        }

        public static function get isSupported():Boolean
        {
            return Capabilities.os.toLowerCase().indexOf("linux") > -1;
        }
    }
}
