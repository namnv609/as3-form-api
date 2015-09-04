package  {

    import flash.display.MovieClip;
    import FormSave;
    import FormValidation;
    import flash.events.MouseEvent;
    import flash.events.Event;

    public class FormCollection extends MovieClip {


        public function FormCollection() {
            // Add event for btnSave
            btnSave.addEventListener(MouseEvent.CLICK, onClickSubmit);
        }

        /**
        * On click event
        *
        * @param MouseEvent e
        * @return void
        */
        function onClickSubmit(e:MouseEvent) :void {
            // Initial validation object
            var validates:Object = {
                'txtName' : {
                    'required' : 'Name is required'
                },
                'txtEmail' : {
                    'required' : 'Email is required',
                    'email' : 'Invalid email address'
                },
                'txtPhone' : {
                    'required' : 'Phone is required',
                    'regex' : {
                        'message' : 'Phone number must be start with 0 or 84',
                        'expression': '^(0|84)([0-9]{8,10})$'
                    }
                },
                'txtAddress' : {
                    'required' : 'Address is required'
                },
                'cbbGender' : {
                    'required' : 'Please select gender'
                },
                'cbAccept' : {
                    'required' : 'Please accept ToS'
                }
            }

            // Initial Form validation with this scene
            var formValidation:FormValidation = new FormValidation(this.root);
            // Initial Form save
            var formSave:FormSave = new FormSave();

            // Set validation rules
            formValidation.setRules(validates);

            // Check validation
            if (formValidation.validation()){
                // Validation success. Get form data
                var formData:Object = {
                    'name' : txtName.text,
                    'email' : txtEmail.text,
                    'phone' : txtPhone.text,
                    'address': txtAddress.text,
                    'gender' : cbbGender.text
                };

                // For test. Get save to
                var saveTo:String = cbbSaveTo.value;
                // Get post complete
                formSave.addEventListener(Event.COMPLETE, function():void {
                    // Get response data
                    var res:String = formSave.getResponseData();
                    lblMessage.text = res;
                });

                // Set post url
                formSave.setUrl('URL_TO_SERVER_FILE');
                // Set data to save
                formSave.setData(formData);
                // Show message
                lblMessage.text = 'Saving. Please wait...';
                // Save form
                formSave.SaveForm();
            } else {
                // Get validation message
                var validationMessages:String = formValidation.getPrettyMessage('*');
                lblMessage.text = validationMessages;
            }

        }
    }

}
