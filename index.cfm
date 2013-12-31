<cfscript>

	// Set the XSRF token cookie. The cookie is user-specific and 
	// "salted". Once in place, AngularJS will look for this cookie
	// before initiating the $http / $resource requests; when found,
	// AngularJS will automatically echo the token in the HEADER
	// value, "X-XSRF-TOKEN".
	cookie[ "XSRF-TOKEN" ] = lcase( 
		hash( "#session.cfid#-#session.cftoken#-#getTickCount()#" )
	);

</cfscript>

<!--- ----------------------------------------------------- --->
<!--- ----------------------------------------------------- --->

<cfcontent type="text/html; charset=utf-8" />

<!doctype html>
<html ng-app="demo">
<head>
	<meta charset="utf-8" />

	<title>
		Preventing Cross-Site Request Forgery With AngularJS And ColdFusion
	</title>

	<style type="text/css">

		a[ ng-click ] {
			color: blue ;
			cursor: pointer ;
			text-decoration: underline ;
		}

	</style>
</head>
<body ng-controller="DemoController">

	<h1>
		Preventing Cross-Site Request Forgery With AngularJS And ColdFusion
	</h1>

	<p>
		<a ng-click="makeGetRequest()">Make GET Request</a> 
		&mdash;
		<a ng-click="makePostRequest()">Make POST Request</a> 
		&mdash;
		<a href="delete_cookie.cfm" target="_blank">Delete XSRF Cookie</a> 
	</p>

	<h3>
		API Log
	</h3>

	<ul>
		<li ng-repeat="item in apiLog">
			{{ item.message }}
		</li>
	</ul>


	<script type="text/javascript" src="./assets/angularjs/angular.min.js"></script>
	<script type="text/javascript" src="./assets/angularjs/angular-resource.min.js"></script>
	<script type="text/javascript">

		// Define our AngularJS application.
		var app = angular.module( "demo", [ "ngResource" ] );


		// -------------------------------------------------- //
		// -------------------------------------------------- //


		// I am the application controller.
		app.controller(
			"DemoController",
			function( $scope, $resource ) {

				// I keep track of the API request values.
				$scope.apiLog = [];

				// I create a proxy for the server-side API end-point.
				// I sit on top of the $http resource and will append
				// an "X-XSRF-TOKEN" header to all outgoing requests 
				// if the "XSRF-TOKEN" cookie value is available.
				var resource = $resource(
					"api.cfm",
					{},
					{		
						performGet: {
							method: "GET"
						},
						performPost: {
							method: "POST"
						}
					}
				);


				// ---
				// PUBLIC METHODS.
				// ---


				// I make GET requests to the API.
				$scope.makeGetRequest = function() {

					resource.performGet()
						.$promise
							.then( handleResolution, handleRejection )
					;

				};


				// I make POST requests to the API.
				$scope.makePostRequest = function() {

					resource.performPost()
						.$promise
							.then( handleResolution, handleRejection )
					;

				};


				// ---
				// PRIVATE METHODS.
				// ---


				// I handle successful resource resolutions.
				function handleResolution( response ) {

					$scope.apiLog.unshift({
						message: ( response.method + ": " + response.time )
					});

				}


				// I handle resource response rejections.
				function handleRejection( response ) {

					$scope.apiLog.unshift({
						message: "*** XSRF Attack! ***"
					});

				}

			}
		);


	</script>

</body>
</html>