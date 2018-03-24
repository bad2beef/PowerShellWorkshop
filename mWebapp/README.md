#	Web Interaction

##	Web Communication Cmdlets and Classes
###	About
1. PowerShell has several network communication Cmdlets.
2. Mainly Invoke-WebRequest is used.
3. .NET Web Classes can be used as well.

### Examples
1. 	Perform a Google search with IWR.
2. 	Download a file with Net.WebClient.

### Additional Comments
1. Invoke-RestMethod is similar to Invoke-WebRequest, but deserializes the response differently. In-built support for XML and JSON.
2. Systems without Internet Explorer (running Server Core) need to pass -UseBasicParsing in Invoke-WebRequest.
3. Built-in Cmdlets don’t always perform well.
4. When working with .NET Classes some PowerShell magic is absent (such as working directories.)

##	Web Service Proxy
### About
1. Easy access to WSDL-described Web Services
2. Usually SOAP, often ASP.net, but not necessarily either.

### Examples
1. GeoIP lookup via WebServiceProxy object.

### Additional Comments
1. Good discoverability, generally easy use.
2. Very low barrier to entry.

##	Internet Explorer COM Object
### About
1. Its possible to run and control Internet Explorer and other COM applications via Powershell.
2. If you need to use a “real” browser instead of the Web cmdlets you can.

### Examples
1. Navigate to Google and inspect data.
2. Complex Web Form Interation

### Additional Comments
1. Fat-clients with web-based interactive logins (SAML, 2FA, etc…) can be authenticated this way. Log in and retrieve OAuth token, for example.
