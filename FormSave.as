package  {
    import flash.net.URLRequest;
    import flash.net.URLVariables;
    import flash.net.URLLoader;
    import flash.events.EventDispatcher;
    import com.adobe.serialization.json.JSON;
    import flash.net.URLRequestMethod;
    import flash.net.URLLoaderDataFormat;
    import flash.events.Event;

    public class FormSave extends EventDispatcher{
        private var API_URL:String = "";
        private var API_KEY:String = "";
        private var API_DATA:Object = {};
        private var httpRequest:URLRequest;
        private var httpVars:URLVariables;
        private var httpLoader:URLLoader;
        private var httpResponse:String;

        public function setUrl(url:String):void {
            API_URL = url;
        }

        public function getUrl():String {
            return API_URL;
        }

        public function setAPIKEY(key:String):void {
            API_KEY = key;
        }

        public function getAPIKEY():String {
            return API_KEY;
        }

        public function setData(apiData:Object):void {
            API_DATA = apiData;
        }
        public function getResponseData():String {
            return httpResponse;
        }

        public function FormSave() {
            httpRequest = new URLRequest();
            httpVars = new URLVariables();
            httpLoader = new URLLoader();
        }

        public function SaveForm():void {
            httpRequest.url = API_URL;
            httpVars.data = JSON.encode(API_DATA);
            httpRequest.method = URLRequestMethod.POST;
            httpRequest.data = httpVars;
            httpLoader.dataFormat = URLLoaderDataFormat.TEXT;
            httpLoader.addEventListener(Event.COMPLETE, onRequestComplete);
            httpLoader.load(httpRequest);
        }

        private function onRequestComplete(e:Event):void {
            httpLoader.removeEventListener(Event.COMPLETE, onRequestComplete);
            httpResponse = e.target.data;
            dispatchEvent(new Event(Event.COMPLETE));
        }
    }

}
