
<!---
	Delete the XSRF cookie. By doing this, AngularJS will not be able
	to echo it back in the $http / $resource HTTP Headers. 
--->
<cfcookie
	name="XSRF-TOKEN"
	value=""
	expires="now"
	/>

<cfcontent type="text/plain; charset=utf-8" />

Cookie expired! ... Boom! That just happened!