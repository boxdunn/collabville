package playerio{
	/**
	* If there are any errors when using the simpleRegister method of QuickConnect, you will get 
	* back an error object of this type that holds more detail about the cause of the error. 
	* You can use this information to provide better help for your users when they are 
	* filling out your registration form.
	*/
	public class PlayerIORegistrationError extends playerio.PlayerIOError{
		/**
		* The error for the username field, if any.
		*/
		public var usernameError:String;
		/**
		* The error for the password field, if any.
		*/
		public var passwordError:String;
		/**
		* The error for the email field, if any.
		*/
		public var emailError:String;
		/**
		* The error for the captcha field, if any.
		*/
		public var captchaError:String;
		
		/**
		* Creates a PlayerIORegistrationError
		*/
		function PlayerIORegistrationError(message:String, id:int, usernameError:String, passwordError:String, emailError:String, captchaError:String){
			super(message, id);
			this.usernameError = usernameError;
			this.passwordError = passwordError;
			this.emailError = emailError;
			this.captchaError = captchaError;
		}
	}
}
