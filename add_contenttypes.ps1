$contentTypeToCreateId = [guid]::NewGuid().ToString()

function Get-RandomString($length) {
    $chars = "abcdefghijklmnopqrstuvwxyz"
    $string = -join ((65..90) + (97..122) | Get-Random -Count $length | % {[char]$_})
    return $string
}

$slug = Get-RandomString -length 15

$contentTypeThatContainsReferenceToAnAlreadyExistingContentTypeName = "${slug}_contenttype_that_contains_ref"

$contentTypeJsonString = @"
{
    "id":"$contentTypeToCreateId",
    "name":"$contentTypeThatContainsReferenceToAnAlreadyExistingContentTypeName",
    "baseType":"Block",
    "editSettings":{
        "displayName":"ContentType that references another content type",
        "available":false,
        "sortOrder":10000
    },
    "properties":[
        {
            "name":"Heading",
            "dataType":"PropertyString",
            "itemType":"",
            "branchSpecific":true,
            "editSettings":{
                "displayName":"heading",
                "groupName":"Information",
                "sortOrder":1,
                "hint":"",
                "helpText":null,
                "visibility":"default"
            }
        },
        {
            "name":"already_existing_in_db_block_property",
            "dataType":"PropertyBlock",
            "itemType":"ButtonBlock",
            "branchSpecific":false,
            "editSettings":{
                "displayName":"Buttonblock, already existing in alloy db.",
                "groupName":"Information",
                "sortOrder":2,
                "hint":"",
                "helpText":null,
                "visibility":"default"
            }
        }
    ]
}
"@

$url = "http://localhost:5000/api/episerver/v3.0/contenttypes"


# this will add a contenttype with two properties, one string and one block reference. This works EVERY time if you do not add a list- or block reference to another type (for example a alloy ButtonBlock). 
# But if run with already_existing_in_db_block_property, it will cause errors and timeouts (if you run example node script, it will generate approx 1 rps) 

$response = Invoke-RestMethod -Uri $url -Method Post -Body $contentTypeJsonString -ContentType "application/json"

Write-Output "content type created"
