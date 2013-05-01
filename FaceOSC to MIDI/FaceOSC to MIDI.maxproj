{
	"name" : "FaceOSC to MIDI",
	"version" : 1,
	"creationdate" : -844763679,
	"modificationdate" : -844763497,
	"viewrect" : [ 67.0, 281.0, 300.0, 500.0 ],
	"autoorganize" : 1,
	"hideprojectwindow" : 0,
	"showdependencies" : 1,
	"autolocalize" : 0,
	"contents" : 	{
		"patchers" : 		{
			"FaceOSC to MIDI.maxpat" : 			{
				"kind" : "patcher",
				"local" : 1,
				"toplevel" : 1
			}
,
			"faceosc-parser.maxpat" : 			{
				"kind" : "patcher",
				"local" : 1
			}
,
			"value-scaler.maxpat" : 			{
				"kind" : "patcher",
				"local" : 1
			}

		}
,
		"code" : 		{
			"running-average.js" : 			{
				"kind" : "javascript",
				"local" : 1
			}

		}
,
		"externals" : 		{
			"OSC-route.mxo" : 			{
				"kind" : "object",
				"local" : 1
			}

		}

	}
,
	"layout" : 	{

	}
,
	"searchpath" : 	{

	}
,
	"detailsvisible" : 0
}
