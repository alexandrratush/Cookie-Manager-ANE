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

    public class OauthConnector extends EventDispatcher
    {
        private var _stageWebView:StageWebView;
        private var _oauth2:OAuth2;
        private var _stage:Stage;

        public function OauthConnector(stage:Stage)
        {
            _stage = stage;
        }

        public function auth(authEndpoint:String, tokenEndpoint:String, appId:String, redirectURI:String, scope:String, params:Object):void
        {
            if (StageWebView.isSupported)
            {
                _stageWebView = new StageWebView(true);
                _stageWebView.stage = _stage;
                _stageWebView.viewPort = new Rectangle(10, 10, _stage.stageWidth - 20, _stage.stageHeight - 20);
                var grant:IGrantType = getGrant(appId, redirectURI, scope, params);
                _oauth2 = new OAuth2(authEndpoint, tokenEndpoint);
                _oauth2.addEventListener(GetAccessTokenEvent.TYPE, onGetAccessTokenHandler);
                _oauth2.getAccessToken(grant);
            }
        }

        private function getGrant(appId:String, redirectURI:String, scope:String, params:Object):ImplicitGrant
        {
            return new ImplicitGrant(
                    _stageWebView,
                    appId,
                    redirectURI,
                    scope,
                    null,
                    params
            );
        }

        private function onGetAccessTokenHandler(event:GetAccessTokenEvent):void
        {
            _stageWebView.stage = null;
            _stageWebView.dispose();
            _stageWebView = null;
            dispatchEvent(event);
        }
    }
}
