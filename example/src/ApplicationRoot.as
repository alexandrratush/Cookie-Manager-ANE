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
        private var _authButton:Button;
        private var _logoutButton:Button;
        private var _vkOauth:VKOauth;

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

            CookieManagerExtension.getInstance().init();
            CookieManagerExtension.getInstance().addEventListener(ErrorEvent.ERROR, onErrorEventHandler);

            _vkOauth = new VKOauth(Starling.current.nativeStage);
            _vkOauth.addEventListener(GetAccessTokenEvent.TYPE, onGetAccessToken);

            var verticalLayout:VerticalLayout = new VerticalLayout();
            verticalLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
            verticalLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
            verticalLayout.gap = 15;

            _group = new LayoutGroup();
            _group.layout = verticalLayout;
            addChild(_group);

            _authButton = new Button();
            _authButton.label = "Auth";
            _authButton.addEventListener(Event.TRIGGERED, authButtonTriggeredHandler);
            _group.addChild(_authButton);

            _logoutButton = new Button();
            _logoutButton.label = "Logout";
            _logoutButton.addEventListener(Event.TRIGGERED, logoutButtonTriggeredHandler);
            _group.addChild(_logoutButton);

            updatePositions(stage.stageWidth, stage.stageHeight);
        }

        private function authButtonTriggeredHandler(event:Event):void
        {
            _vkOauth.auth();
        }

        private function logoutButtonTriggeredHandler(e:Event):void
        {
            Cc.log("Cookies before remove: " + CookieManagerExtension.getInstance().getCookie("http://vk.com/"));
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

        private function updatePositions(width:int, height:int):void
        {
            _group.validate();
            _group.x = (width - _group.width) / 2;
            _group.y = (height - _group.height) / 2;
        }
    }
}
