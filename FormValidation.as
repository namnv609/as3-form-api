package  {
    import printf;
    import flash.display.DisplayObject;
    import com.adobe.utils.StringUtil;
    import flash.utils.getQualifiedClassName;

    public class FormValidation {
        private var validationMessages:Array;
        private var prettyMessage:String;
        private var validationObject:Object;
        private var __root:DisplayObject;

        public function FormValidation(refs) {
            __root = refs;
            validationMessages = new Array();
            prettyMessage = "";
        }

        public function getMessages():Array {
            return validationMessages;
        }

        public function getPrettyMessage(prefix:String = "-"):String {
            for each(var message in validationMessages) {
                prettyMessage += printf("%s %s\n", prefix, message);
            }

            return prettyMessage;
        }

        public function setRules(validationRules:Object):void {
            validationObject = validationRules;
        }

        public function validation():Boolean {
            // Array of special field. Maybe checkbox and radio
            var specialFields:Array = new Array("CheckBox");

            // Get field name to validation
            for (var field:String in validationObject) {
                // Get field value
                var fieldValue = __root[field];
                var fieldType:String = getQualifiedClassName(fieldValue).split("::")[1];

                switch(fieldType) {
                    case "TextInput":
                    case "TextArea":
                    case "Label":
                        fieldValue = StringUtil.trim(__root[field].text);
                        break;
                    case "ComboBox":
                        fieldValue = __root[field].value;
                        break;
                }

                // Get validation
                for (var validation:String in validationObject[field]) {
                    // Call validation function
                    this[validation](fieldValue, validationObject[field][validation]);
                }
            }

            if (validationMessages.length > 0) {
                return false;
            }

            return true;
        }

        /** Valiation rules **/

        /**
        * Not empty validation
        *
        * @param string value Value to check empty
        * @param string message Message for not empty validation
        * @return boolean Empty validation status
        */
        private function required(value:*, message:String):Boolean {
            var valueType:String = typeof(value);
            if (valueType == "object" && value.selected == true) {
                return true;
            } else if (valueType == "string" && value != "") {
                return true;
            }

            validationMessages.push(message);

            return false;
        }

        /**
        * Minimum character validation
        *
        * @param string value Value to check min length
        * @param object Object contain min length value and message
        * @return boolean Min length validation status
        */
        private function minLength(value:String, obj:Object):Boolean {
            if (value.length >= obj.minLength) {
                return true;
            }

            var message:String = printf(obj.message, obj.minLength);
            validationMessages.push(message);

            return false;
        }

        /**
        * Maximum character validation
        *
        * @param string value Value to check max length
        * @param object obj Object contain max length value and message
        * @return boolean Max length validation status
        */
        private function maxLength(value:String, obj:Object):Boolean {
            if (value.length <= obj.maxLength) {
                return true;
            }

            var message:String = printf(obj.message, obj.maxLength);
            validationMessages.push(message);

            return false;
        }

        /**
        * Email validation
        *
        * @param string email Email to validation
        * @param string message Message for invalid email
        * @return boolean Email validation status
        */
        private function email(email:String, message:String):Boolean {
            var emailRegEx:RegExp = /^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;

            if (emailRegEx.test(email) == true) {
                return true;
            }

            validationMessages.push(message);

            return false;
        }

        /**
        * Matches validation
        *
        * @param string value Value to check
        * @param object obj Object contain field to check and message
        * @param boolean Matches validation status
        */
        private function matches(value:String, obj:Object):Boolean {
            var matchValue = __root[obj.field].text;

            if (value == matchValue) {
                return true;
            }

            validationMessages.push(obj.message);

            return false;
        }

        /**
        * Custom regex validation
        *
        * @param string value Custom regular expression
        * @param object obj Object contain expression and message
        * @return boolean RexEx test status
        */
        private function regex(value:String, obj:Object):Boolean {
            var regEx:RegExp = new RegExp(obj.expression, 'g');

            if (regEx.test(value) == true) {
                return true;
            }

            validationMessages.push(obj.message);
            return false;
        }

    }

}
