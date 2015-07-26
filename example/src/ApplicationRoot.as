package
{
    import com.adobe.protocols.oauth2.OAuth2;
    import com.adobe.protocols.oauth2.event.GetAccessTokenEvent;
    import com.adobe.protocols.oauth2.grant.IGrantType;
    import com.adobe.protocols.oauth2.grant.ImplicitGrant;
    import com.alexandrratush.ane.CookieManagerExtension;

    import feathers.controls.Button;
    import feathers.controls.LayoutGroup;
    import feathers.layout.VerticalLayout;
    import feathers.themes.MetalWorksMobileTheme;

    import flash.geom.Rectangle;
    import flash.media.StageWebView;

    import starling.core.Starling;
    import starling.display.Sprite;
    import starling.events.Event;

    public class ApplicationRoot extends Sprite
    {
        private static const AUTH_END_POINT:String = "https://oauth.vk.com/authorize";
        private static const TOKEN_END_POINT:String = "https://oauth.vk.com/token";
        private static const REDIRECT_URI:String = "https://oauth.vk.com/blank.html";
        private static const SCOPE:String = "friends,photos,status";
        private static const APP_ID:String = "3961467";

        private var _group:LayoutGroup;
        private var _vkLoginButton:Button;
        private var _vkLogoutButton:Button;
        private var _stageWebView:StageWebView;
        private var _oauth2:OAuth2;

        public function ApplicationRoot()
        {
            addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
        }

        private function addedToStageHandler(e:Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
            init();
        }

        private function init():void
        {
            new MetalWorksMobileTheme();

            CookieManagerExtension.getInstance().init();

            var verticalLayout:VerticalLayout = new VerticalLayout();
            verticalLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
            verticalLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
            verticalLayout.gap = 15;

            _group = new LayoutGroup();
            _group.layout = verticalLayout;
            addChild(_group);

            _vkLoginButton = new Button();
            _vkLoginButton.label = "Login";
            _vkLoginButton.addEventListener(Event.TRIGGERED, loginButtonTriggeredHandler);
            _group.addChild(_vkLoginButton);

            _vkLogoutButton = new Button();
            _vkLogoutButton.label = "Logout";
            _vkLogoutButton.addEventListener(Event.TRIGGERED, logoutButtonTriggeredHandler);
            _group.addChild(_vkLogoutButton);

            updatePositions(stage.stageWidth, stage.stageHeight);
        }

        private function loginButtonTriggeredHandler(event:Event):void
        {
            trace("cookies " + CookieManagerExtension.getInstance().getCookie("http://vk.com/"));

            if (StageWebView.isSupported)
            {
                _stageWebView = new StageWebView(true);
                _stageWebView.stage = Starling.current.nativeStage;
                _stageWebView.viewPort = new Rectangle(10, 10, stage.stageWidth - 20, stage.stageHeight - 20);
                var grant:IGrantType = getGrant();
                _oauth2 = new OAuth2(AUTH_END_POINT, TOKEN_END_POINT);
                _oauth2.addEventListener(GetAccessTokenEvent.TYPE, onGetAccessToken);
                _oauth2.getAccessToken(grant);
            }
        }

        private function getGrant():ImplicitGrant
        {
            var optionalParams:Object = {display: "mobile"};
            return new ImplicitGrant(
                    _stageWebView,
                    APP_ID,
                    REDIRECT_URI,
                    SCOPE,
                    null,
                    optionalParams
            );
        }

        private function onGetAccessToken(event:GetAccessTokenEvent):void
        {
            if (event.errorCode == null && event.errorMessage == null)
            {
                trace("onGetAccessToken: accessToken = " + event.accessToken);
            } else
            {
                trace("onGetAccessToken: errorMessage " + event.errorMessage);
            }

            _stageWebView.stage = null;
            _stageWebView.viewPort = null;
            _stageWebView.dispose();
            _stageWebView = null;

            trace("cookies " + CookieManagerExtension.getInstance().getCookie("http://vk.com/"));
        }

        private function logoutButtonTriggeredHandler(e:Event):void
        {
            CookieManagerExtension.getInstance().removeAllCookie();
            trace("cookies " + CookieManagerExtension.getInstance().getCookie("http://vk.com/"));
        }

        private function updatePositions(width:int, height:int):void
        {
            _group.validate();
            _group.x = (width - _group.width) / 2;
            _group.y = (height - _group.height) / 2;
        }
    }
}
