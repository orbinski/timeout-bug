# How to cause sql timesouts in Optimizely when adding content types under load. 

Build from standard alloy template, with the following changes/additions: 

1. Updated Optimizely to latest
1. Changed loglevel to warning
1. Added references to EPiServer.ContentDefinitionsApi and EPiServer.ContentDeliveryApi.Cms
1. Added ContentDefinitionsApi and ContentDeliveryApi to the servicecollection
1. Changed website protocol to http to avoid certificate issues

## How to run
1. Install Node.js
1. Run the project and optionally navigate to the website. (http://localhost:5000, Username: sa, password: Qwerty12345!)
1. Open console and run following command to put some load on website (via ContentDeliveryApi endpoint)
	```bash
	npx loadtest@latest -t 200 -c 1 --rps 1 -H Accept-Language:en -k http://localhost:5000/api/episerver/v3.0/content/8?expand=*
	````
1. Run the following command to add content types (via ContentDefinitions Api)
	```bash
	add_contenttypes.ps1
	````

You might need to re-run the add_contenttypes.ps1 script a few times to get the timeouts.

Please note that issue is only happening when you use lists of, or inline blocks of, other content types (which can already exist in db). Example node script generates a modest load at 1 rps whilst we previously used 50. 