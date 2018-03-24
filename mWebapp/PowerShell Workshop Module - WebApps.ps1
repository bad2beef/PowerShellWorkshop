#######################################
# Web Communication Cmdlets and Classes
#######################################
Invoke-WebRequest -Uri 'http://google.com'
$Response = Invoke-WebRequest -Uri 'http://google.com' -SessionVariable 'WebSession'
$WebSession
$Response.Forms[0].Fields
$Form = $Response.Forms[0]
$Form.Fields['q'] = 'powershell'
$Form.Submit()
$SearchResults = Invoke-WebRequest -Uri ( 'http://google.com' + $Form.Action ) -Method $Form.Method -WebSession $WebSession -Body $Form.Fields
$SearchResults.RawContent

$WebClient = New-Object -TypeName System.Net.WebClient
$WebClient.DownloadFile( 'https://www.google.com/favicon.ico', 'C:\Vagrant\google_icon.ico')

#######################################
# Web Service Proxy
#######################################
$Service = New-WebServiceProxy -Uri 'http://google.com'
$Service = New-WebServiceProxy -Uri 'http://www.webservicex.net/geoipservice.asmx?WSDL'
$Service | Get-Member
Get-Member -InputObject $Service -Name GetGeoIP | Format-List
Get-Member -InputObject $Service -Name GetGeoIPAsync | Format-List
$Service.GetGeoIP( '8.8.8.8' )

#######################################
# Internet Explorer COM Object
#######################################
# Example: Navigate to Google and inspect data.
$IE = New-Object -TypeName 'InternetExplorer'
$IE = New-Object -ComObject 'InternetExplorer.Application'
$IE
$IE | Get-Member
$IE.GetType()
$IE.Visible = $true
$IE.Navigate( 'http://google.com' )
$IE
$IE.Document
$IE.Document | Get-Member
$IE.Document.cookie
$IE.Document.title
$IE.Document.title = 'Foobar!'
$IE.Document.childNodes[1].innerHTML
$IE.Quit()

# Example: Complex Web Form Interation
$ie = New-Object -com InternetExplorer.Application
$ie.visible = $true
$ie.silent = $false
$ie.navigate2("https://10.10.83.123:9443/triton/login/pages/loginPage.jsf")
$username = "jkennedy"
while($ie.Busy) { Start-Sleep -Milliseconds 100 }
#
if ($ie.document.url -Match "invalidcert")
        {
        "Bypassing SSL Certificate Error Page";
        $sslbypass=$ie.Document.getElementsByTagName("a") | where-object {$_.id -eq "overridelink"};
        $sslbypass.click();
        Write-Host "Bypassing Certificate";
        };
Write-Host "Attempting to Login to website"
Start-Sleep 10
$doc = $ie.Document
#$UserNameField = $doc.getElementByName("loginForm:idUserName")
$UserNameField = $doc.forms['loginForm'].elements["loginForm:idUserName"]
$UserNameField.value = "$username"
#$PassField = $doc.getElementById('loginForm:idPassword')
$PassField = $doc.forms['loginForm'].elements["loginForm:idPassword"]
$PassField.value = "$password"
#$LoginButton = $doc.getElementByName('loginForm:idLoginButton')
$LoginButton = $doc.forms['loginForm'].elements['loginForm:idLoginButton']
$LoginButton.setActive()
$LoginButton.click()
Start-Sleep 10
#Navigate to custom computers view
$iframe = $doc.parentWindow.frames[2]
$cust_comps = $iframe.document.body.getElementsByClassName("msmSMLinkItem") |Where-Object -Property innerText -like "Custom Computers"
$cust_comps.click()
Start-Sleep 5
#####
$servers = Import-Csv C:\scripts\dlp_servers.csv
#####
$servers | ForEach-Object {
$iframe = $doc.parentWindow.frames[2]
$innerframe = $iframe.frames[1]
$new_comp_button =  $innerframe.document.body.getElementsByClassName("toolbarItemText")[0]
$new_comp_button.click()
Start-Sleep 3
$new_comp_form = $innerframe.document.forms['computerDetailsForm']
$ncomp_ip = $new_comp_form.elements["computerDetailsForm:idIpHostName"]
$ncomp_fqdn = $new_comp_form.elements["computerDetailsForm:idFQDN"]
$ncomp_desc = $new_comp_form.elements["computerDetailsForm:idDescription"]
Start-Sleep 3
#maybe an innerloop to assign variables from the foreach object?
$server = $_.server
$fqdn = $_.fqdn
$desc = $_.desc
$ncomp_ip.value = "$server"
$ncomp_fqdn.value = "$fqdn"
$ncomp_desc.value = "$desc"
$ok_button = $innerframe.document.body.getElementsByClassName("paButtonText") | Where-Object -Property outerTEXT -eq "OK"
#$ncomp_ip.value = "var"
#$ncomp_fqdn.value = ()
#$ncomp_desc.value = ()
$ok_button.click()
Start-Sleep 5
}
$ie.parent.quit()