$contentTypeOneId = [guid]::NewGuid().ToString()
$contentTypeTwoId = [guid]::NewGuid().ToString()


function Get-RandomString($length) {
    $chars = "abcdefghijklmnopqrstuvwxyz"
    $string = -join ((65..90) + (97..122) | Get-Random -Count $length | % {[char]$_})
    return $string
}

$slug = Get-RandomString -length 15

$contentTypeOneName = "${slug}_informationsectionp"
$contentTypeTwoName = "${slug}_informationsection"

$contentTypeOneJsonString = @"
{
    "id":"$contentTypeOneId",
    "name":"$contentTypeOneName",
    "baseType":"Block",
    "editSettings":{
        "displayName":"informationSectionP",
        "available":false,
        "sortOrder":10000
    },
    "properties":[
        {
            "name":"information_section_paragraph_body",
            "dataType":"PropertyXhtmlString",
            "itemType":"",
            "branchSpecific":true,
            "editSettings":{
                "displayName":"information_section_paragraph_body",
                "groupName":"Information",
                "sortOrder":0,
                "hint":"BasicXhtml",
                "helpText":null,
                "visibility":"default"
            }
        },
        {
            "name":"information_section_paragraph_has_page_link",
            "dataType":"PropertyBoolean",
            "itemType":"",
            "branchSpecific":true,
            "editSettings":{
                "displayName":"information_section_paragraph_has_page_link",
                "groupName":"Information",
                "sortOrder":1,
                "hint":"",
                "helpText":null,
                "visibility":"default"
            }
        },
        {
            "name":"information_section_paragraph_page_link_label",
            "dataType":"PropertyString",
            "itemType":"",
            "branchSpecific":true,
            "editSettings":{
                "displayName":"information_section_paragraph_page_link_label",
                "groupName":"Information",
                "sortOrder":2,
                "hint":"",
                "helpText":null,
                "visibility":"default"
            }
        },
        {
            "name":"information_section_paragraph_page_link_url",
            "dataType":"PropertyString",
            "itemType":"",
            "branchSpecific":true,
            "editSettings":{
                "displayName":"information_section_paragraph_page_link_url",
                "groupName":"Information",
                "sortOrder":3,
                "hint":"",
                "helpText":null,
                "visibility":"default"
            }
        }
    ]
}
"@



$contentTypeTwoJsonString = @"
{
    "id":"$contentTypeTwoId",
    "name":"$contentTypeTwoName",
    "baseType":"Block",
    "editSettings":{
        "displayName":"informationSection",
        "available":false,
        "sortOrder":10000
    },
    "properties":[
        {
            "name":"information_section_header",
            "dataType":"PropertyString",
            "itemType":"",
            "branchSpecific":true,
            "editSettings":{
                "displayName":"information_section_header",
                "groupName":"Information",
                "sortOrder":0,
                "hint":"",
                "helpText":null,
                "visibility":"default"
            }
        },
        {
            "name":"information_section_right_side",
            "dataType":"PropertyBoolean",
            "itemType":"",
            "branchSpecific":true,
            "editSettings":{
                "displayName":"information_section_right_side",
                "groupName":"Information",
                "sortOrder":1,
                "hint":"",
                "helpText":null,
                "visibility":"default"
            }
        },
        {
            "name":"information_section_paragraphs",
            "dataType":"PropertyCollection",
            "itemType":"$contentTypeOneName",
            "branchSpecific":true,
            "editSettings":{
                "displayName":"information_section_paragraphs",
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

$responseOne = Invoke-RestMethod -Uri $url -Method Post -Body $contentTypeOneJsonString -ContentType "application/json"

$responseTwo = Invoke-RestMethod -Uri $url -Method Post -Body $contentTypeTwoJsonString -ContentType "application/json"

Write-Output "Two content types created"
