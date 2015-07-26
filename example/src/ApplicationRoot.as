package
{
    import com.alexandrratush.ane.CookieManagerExtension;

    import feathers.controls.Button;
    import feathers.controls.LayoutGroup;
    import feathers.layout.VerticalLayout;
    import feathers.themes.MetalWorksMobileTheme;

    import starling.display.Sprite;
    import starling.events.Event;

    public class ApplicationRoot extends Sprite
    {
        private var _group:LayoutGroup;
        private var _vkLoginButton:Button;
        private var _vkLogoutButton:Button;

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
            _vkLogoutButton.addEventListener(Event.TRIGGERED, logouButtonTriggeredHandler);
            _group.addChild(_vkLogoutButton);

            updatePositions(stage.stageWidth, stage.stageHeight);
        }

        private function loginButtonTriggeredHandler(event:Event):void
        {
            CookieManagerExtension.getInstance().init();
            var cookies:String = CookieManagerExtension.getInstance().getCookie("http://vk.com/");
            trace("cookies " + cookies);
        }

        private function logouButtonTriggeredHandler(e:Event):void
        {
            CookieManagerExtension.getInstance().removeAllCookie();
        }

        private function updatePositions(width:int, height:int):void
        {
            _group.validate();
            _group.x = (width - _group.width) / 2;
            _group.y = (height - _group.height) / 2;
        }
    }
}
