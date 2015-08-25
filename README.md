Cookie Manager ANE
=============================
Example:

```ActionScript
CookieManagerExtension.getInstance().init();
trace("Cookies: " + CookieManagerExtension.getInstance().getCookie("http://vk.com/"));
CookieManagerExtension.getInstance().removeAllCookie();
```