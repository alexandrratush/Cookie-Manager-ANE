Cookie Manager ANE (Android)
=============================
Native Extension for Adobe AIR

####Using the ANE:

* Add **[CookieManager.ane](https://github.com/alexandrratush/Cookie-Manager-ANE/tree/master/ane/bin)** file to your air project.

* Add **com.alexandrratush.ane.CookieManager** extension id to your application descriptor file. For example:
```xml
<!-- Identifies the ActionScript extensions used by an application. -->
<extensions>
	<extensionID>com.alexandrratush.ane.CookieManager</extensionID>
</extensions>
```

####Code example:

```ActionScript
CookieManagerExtension.getInstance().init();
trace("Cookies: " + CookieManagerExtension.getInstance().getCookie("http://vk.com/"));
CookieManagerExtension.getInstance().removeAllCookie();
```