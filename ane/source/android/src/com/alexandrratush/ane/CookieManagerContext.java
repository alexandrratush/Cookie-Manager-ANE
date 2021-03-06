package com.alexandrratush.ane;

import android.util.Log;
import android.webkit.CookieManager;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

import java.util.HashMap;
import java.util.Map;

public class CookieManagerContext extends FREContext {
    public static final String KEY = "CookieManagerContext";
    public static final String INIT_FUNCTION = "init";
    public static final String REMOVE_ALL_COOKIE_FUNCTION = "removeAllCookie";
    public static final String GET_COOKIE_FUNCTION = "getCookie";
    public static final String SET_COOKIE_FUNCTION = "setCookie";
    public static final String ACCEPT_COOKIE_FUNCTION = "acceptCookie";
    public static final String SET_ACCEPT_COOKIE_FUNCTION = "setAcceptCookie";

    private CookieManager cookieManager;

    @Override
    public void dispose() {
        Log.i(CookieManagerContext.KEY, "Disposing Extension Context");
        if (cookieManager != null) cookieManager = null;
    }

    @Override
    public Map<String, FREFunction> getFunctions() {
        Map<String, FREFunction> map = new HashMap<>();
        map.put(INIT_FUNCTION, new InitFunction());
        map.put(REMOVE_ALL_COOKIE_FUNCTION, new RemoveAllCookieFunction());
        map.put(GET_COOKIE_FUNCTION, new GetCookieFunction());
        map.put(SET_COOKIE_FUNCTION, new SetCookieFunction());
        map.put(ACCEPT_COOKIE_FUNCTION, new AcceptCookieFunction());
        map.put(SET_ACCEPT_COOKIE_FUNCTION, new SetAcceptCookieFunction());
        return map;
    }

    public class InitFunction implements FREFunction {
        @Override
        public FREObject call(FREContext context, FREObject[] args) {
            try {
                cookieManager = CookieManager.getInstance();
                Log.i(CookieManagerContext.KEY, INIT_FUNCTION);
            } catch (Exception e) {
                Log.e(CookieManagerContext.KEY, INIT_FUNCTION, e);
                context.dispatchStatusEventAsync(INIT_FUNCTION + ": " + e, CookieManagerExtension.ERROR_EVENT);
            }

            return null;
        }
    }

    public class RemoveAllCookieFunction implements FREFunction {
        @Override
        public FREObject call(FREContext context, FREObject[] args) {
            try {
                cookieManager.removeAllCookie();
                Log.i(CookieManagerContext.KEY, REMOVE_ALL_COOKIE_FUNCTION);
            } catch (NullPointerException e) {
                Log.e(CookieManagerContext.KEY, REMOVE_ALL_COOKIE_FUNCTION, e);
                context.dispatchStatusEventAsync(REMOVE_ALL_COOKIE_FUNCTION + ": " + e, CookieManagerExtension.ERROR_EVENT);
            }

            return null;
        }
    }

    public class GetCookieFunction implements FREFunction {
        @Override
        public FREObject call(FREContext context, FREObject[] args) {
            try {
                String url = args[0].getAsString();
                String cookies = cookieManager.getCookie(url);
                Log.i(CookieManagerContext.KEY, GET_COOKIE_FUNCTION + " Cookies: " + cookies);
                return FREObject.newObject(cookies);
            } catch (Exception e) {
                Log.e(CookieManagerContext.KEY, GET_COOKIE_FUNCTION, e);
                context.dispatchStatusEventAsync(GET_COOKIE_FUNCTION + ": " + e, CookieManagerExtension.ERROR_EVENT);
            }

            return null;
        }
    }

    public class SetCookieFunction implements FREFunction {
        @Override
        public FREObject call(FREContext context, FREObject[] args) {
            try {
                String url = args[0].getAsString();
                String value = args[1].getAsString();
                cookieManager.setCookie(url, value);
            } catch (Exception e) {
                Log.e(CookieManagerContext.KEY, SET_COOKIE_FUNCTION, e);
                context.dispatchStatusEventAsync(SET_COOKIE_FUNCTION + ": " + e, CookieManagerExtension.ERROR_EVENT);
            }

            return null;
        }
    }

    public class AcceptCookieFunction implements FREFunction {
        @Override
        public FREObject call(FREContext context, FREObject[] args) {
            try {
                Boolean acceptCookie = cookieManager.acceptCookie();
                return FREObject.newObject(acceptCookie);
            } catch (Exception e) {
                Log.e(CookieManagerContext.KEY, ACCEPT_COOKIE_FUNCTION, e);
                context.dispatchStatusEventAsync(ACCEPT_COOKIE_FUNCTION + ": " + e, CookieManagerExtension.ERROR_EVENT);
            }

            return null;
        }
    }

    public class SetAcceptCookieFunction implements FREFunction {
        @Override
        public FREObject call(FREContext context, FREObject[] args) {
            try {
                Boolean accept = args[0].getAsBool();
                cookieManager.setAcceptCookie(accept);
            } catch (Exception e) {
                Log.e(CookieManagerContext.KEY, SET_ACCEPT_COOKIE_FUNCTION, e);
                context.dispatchStatusEventAsync(SET_ACCEPT_COOKIE_FUNCTION + ": " + e, CookieManagerExtension.ERROR_EVENT);
            }

            return null;
        }
    }
}
