package
{
    import com.adobe.protocols.oauth2.event.GetAccessTokenEvent;
    import com.alexandrratush.ane.CookieManagerExtension;
    import com.junkbyte.console.Cc;

    import feathers.controls.Button;
    import feathers.controls.LayoutGroup;
    import feathers.layout.VerticalLayout;
    import feathers.themes.MetalWorksMobileTheme;

    import flash.events.ErrorEvent;

    import starling.core.Starling;
    import starling.display.Sprite;
    import starling.events.Event;

    public class ApplicationRoot extends Sprite
    {
        private var _group:LayoutGroup;
        private var _authVKButton:Button;
        private var _logoutVKButton:Button;
        private var _vkOauth:OauthConnector;

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

            Cc.startOnStage(Starling.current.nativeStage, "");
            Cc.visible = true;
            Cc.width = Starling.current.nativeStage.stageWidth;
            Cc.height = 100;

            _vkOauth = new OauthConnector(Starling.current.nativeStage);
            _vkOauth.addEventListener(GetAccessTokenEvent.TYPE, onGetAccessToken);

            var verticalLayout:VerticalLayout = new VerticalLayout();
            verticalLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
            verticalLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
            verticalLayout.gap = 15;

            _group = new LayoutGroup();
            _group.layout = verticalLayout;
            _group.width = stage.stageWidth;
            _group.height = stage.stageHeight;
            addChild(_group);

            _authVKButton = new Button();
            _authVKButton.label = "Auth with VK";
            _authVKButton.addEventListener(Event.TRIGGERED, authButtonTriggeredHandler);
            _group.addChild(_authVKButton);

            _logoutVKButton = new Button();
            _logoutVKButton.label = "Logout VK";
            _logoutVKButton.addEventListener(Event.TRIGGERED, logoutButtonTriggeredHandler);
            _group.addChild(_logoutVKButton);

            if (CookieManagerExtension.isSupported)
            {
                CookieManagerExtension.getInstance().init();
                CookieManagerExtension.getInstance().addEventListener(ErrorEvent.ERROR, onErrorEventHandler);
            } else
            {
                Cc.log("CookieManagerExtension is not supported");
                _authVKButton.isEnabled = false;
                _logoutVKButton.isEnabled = false;
            }
        }

        private function authButtonTriggeredHandler(event:Event):void
        {
            _vkOauth.auth(SocialData.VK_AUTH_END_POINT,
                    SocialData.VK_TOKEN_END_POINT,
                    SocialData.VK_APP_ID,
                    SocialData.VK_REDIRECT_URI,
                    SocialData.VK_SCOPE,
                    {display: "mobile"}
            );
        }

        private function logoutButtonTriggeredHandler(e:Event):void
        {
            CookieManagerExtension.getInstance().removeAllCookie();
            Cc.log("Cookies after remove: " + CookieManagerExtension.getInstance().getCookie("http://vk.com/"));
        }

        private function onGetAccessToken(event:GetAccessTokenEvent):void
        {
            if (event.errorCode == null && event.errorMessage == null)
                Cc.log("onGetAccessToken: complete");
            else
                Cc.error("onGetAccessToken: error");

            Cc.log("Cookies after auth: " + CookieManagerExtension.getInstance().getCookie("http://vk.com/"));
        }

        private function onErrorEventHandler(e:ErrorEvent):void
        {
            Cc.error("onErrorEventHandler: ");
            Cc.explode(e);
        }
    }
}
