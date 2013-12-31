component
	output = false
	hint = "I define the application settings and event handlers."
	{

	// I define the application settings.
	this.name = hash( getCurrentTemplatePath() );
	this.applicationTimeout = createTimeSpan( 0, 1, 0, 0 );

	// We are going to turn on session management so that we can 
	// uniquely identify our users. Then, our XSRF token will be a
	// hashed version of the user-specific tokens.
	this.sessionManagement = true;
	this.sessionTimeout = createTimeSpan( 0, 0, 10, 0 );

}