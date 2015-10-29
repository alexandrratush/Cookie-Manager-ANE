package
{
    import com.adobe.protocols.oauth2.OAuth2;
    import com.adobe.protocols.oauth2.event.GetAccessTokenEvent;
    import com.adobe.protocols.oauth2.grant.IGrantType;
    import com.adobe.protocols.oauth2.grant.ImplicitGrant;

    import flash.display.Stage;
    import flash.events.EventDispatcher;
    import flash.geom.Rectangle;
    import flash.media.StageWebView;

    public class VKOauth extends EventDispatcher
    {
        private static const AUTH_END_POINT:String = "https://oauth.vk.com/authorize";
        private static const TOKEN_END_POINT:String = "https://oauth.vk.com/token";
        private static const REDIRECT_URI:String = "https://oauth.vk.com/blank.html";
        private static const SCOPE:String = "friends,photos,status";
        private static const APP_ID:String = "3961467";

        private var _stageWebView:StageWebView;
        private var _oauth2:OAuth2;
        private var _stage:Stage;

        public function VKOauth(stage:Stage)
        {
            _stage = stage;
        }

        public function auth():void
        {
            if (StageWebView.isSupported)
            {
                _stageWebView = new StageWebView(true);
                _stageWebView.stage = _stage;
                _stageWebView.viewPort = new Rectangle(10, 10, _stage.stageWidth - 20, _stage.stageHeight - 20);
                var grant:IGrantType = getGrant();
                _oauth2 = new OAuth2(AUTH_END_POINT, TOKEN_END_POINT);
                _oauth2.addEventListener(GetAccessTokenEvent.TYPE, onGetAccessToken);
                _oauth2.getAccessToken(grant);
            }
        }

        private function getGrant():ImplicitGrant
        {
            return new ImplicitGrant(
                    _stageWebView,
                    APP_ID,
                    REDIRECT_URI,
                    SCOPE,
                    null,
                    {display: "mobile"}
            );
        }

        private function onGetAccessToken(event:GetAccessTokenEvent):void
        {
            _stageWebView.stage = null;
            _stageWebView.viewPort = null;
            _stageWebView.dispose();
            _stageWebView = null;

            dispatchEvent(event);
        }
    }
}
