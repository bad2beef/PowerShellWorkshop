# https://www.neutrinoapi.com/create-user/
# pooks
# U4jZmV2IELbsbaV8UcZNK0jIVkSq2w0TOkNVZyH8ycIg3ot8

$burl = 'https://neutrinoapi.com/'
$auth = @{'user-id'='pooks'; 'api-key'='U4jZmV2IELbsbaV8UcZNK0jIVkSq2w0TOkNVZyH8ycIg3ot8'}
#$aurl = 'ip-info'
#$aurl = 'email-validate'
#$aurl = 'sms-message'

$aurl = 'ip-probe'

$params = $auth
#$params['ip']='208.18.84.1'

$params['ip']='23.241.224.182'
#$params['email']='xxjohnxmetalxx@gmail.com'
#$params['number']='5629991116'
#$params['message']='blahgblahblah'
$resp = irm -Method Post ($burl+$aurl) -Body ($params | ConvertTo-Json) -Headers @{"content-type"='application/json'}
$resp
