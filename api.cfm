<cfscript>
	
	// Set up the default API response.
	apiResponse = {
		"statusCode" = 200,
		"statusText" = "OK",
		"contentType" = "application/x-json",
		"data" = {}
	};

	// When processing the API request, we are going to check to see
	// if the XSRF cookie and header values match. If either of these
	// values is missing, or they do not match, we'll raise an
	// exception. This error-oriented routing simplifies the logic.
	try {

		// The value WE set.
		xsrfCookie = cookie[ "XSRF-TOKEN" ];

		// The value ANGULARJS set.
		xsrfToken = getHttpRequestData().headers[ "X-XSRF-TOKEN" ];

		if ( xsrfCookie != xsrfToken ) {

			throw( type = "XsrfTokenMismatch" );

		}

		apiResponse.data[ "method" ] = cgi.request_method;
		apiResponse.data[ "time" ] = getTickCount();

	} catch ( any error ) {

		// If we made it this far, some part of the XSRF validation 
		// failed. Either one of the tokens was missing; or, the two 
		// tokens did not match. In any case, the request is not valid.

		apiResponse.statusCode = 401;
		apiResponse.statusText = "Unauthorized";
		apiResponse.data = {};
		
	}
	
</cfscript>

<cfheader 
	statuscode="#apiResponse.statusCode#" 
	statustext="#apiResponse.statusText#"
	/>

<!--- Serialize the API response. --->
<cfcontent 
	type="#apiResponse.contentType#; charset=utf-8" 
	variable="#charsetDecode( serializeJson( apiResponse.data ), 'utf-8' )#"
	/>