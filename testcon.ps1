## Import the CSV file data.
$DeviceList = Import-Csv -Path C:\xampp\htdocs\list.csv
## Output HTML File
$OutputFile = "C:\xampp\htdocs\index.html"
$listitemalive = """list-group-item alive"""
$listitemdead = """list-group-item dead"""
$column = "col-md-4"



While($true){
	 ## Creating the Result array.
    $Result = @()
	
	## Sort devices in the device list alphabetically based on Name.
    $DeviceList = $DeviceList | Sort-Object -Property Name
	
	## This ForEach loop puts offline devices at the top of the list.
	ForEach ($Device in $DeviceList){
        $PingStatus = Test-Connection -ComputerName $Device.IP -Count 1 -Quiet
		$Result += New-Object PSObject -Property @{
            Status = $PingStatus
            DeviceName = $Device.Name
            DeviceIP = $Device.IP
	    }

        ## Clear the variables after obtaining and storing the results, otherwise duplicate data is entered.

        If ($PingStatus){
            Clear-Variable PingStatus
        }
    }

	$HTML = '<html>
		<head>
			<link rel="stylesheet" type="text/css" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
			<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
			<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
			 <script type="text/javascript">
				window.onload = setupRefresh;
				function setupRefresh(){
					setInterval("refreshBlock();",300);
				}
				function refreshBlock(){
				   $("#list").load("index.html");
				}
			  </script>
			<style>
				/* latin-ext */
				@font-face {
				  font-family: "Raleway";
				  font-style: normal;
				  font-weight: 800;
				  font-display: swap;
				  src: local("Raleway ExtraBold"), local("Raleway-ExtraBold"), url(https://fonts.gstatic.com/s/raleway/v13/1Ptrg8zYS_SKggPNwIouWqhPAMif.woff2) format("woff2");
				  unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
				}
				/* latin */
				@font-face {
				  font-family: "Raleway";
				  font-style: normal;
				  font-weight: 800;
				  font-display: swap;
				  src: local("Raleway ExtraBold"), local("Raleway-ExtraBold"), url(https://fonts.gstatic.com/s/raleway/v13/1Ptrg8zYS_SKggPNwIouWqZPAA.woff2) format("woff2");
				  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
				}
				.col-md-4{
					float:left;
				}
				.list-group{
					margin-left:15%;
					margin-right:15%;
				}
				.list-group-item{
					border: solid 1px;
					border-color: #ffffff;
					font-family:Raleway;
					text-align:center;
				}
				.alive{
					background: #25d366;
				}
				.dead{
					background: #bf0a30;
				}
				@media all and (max-width: 1000px) {
				 .list-group{
					margin-left:0;
					margin-right:0;
					margin-top:0;
				}
			</style>
		</head>
		<body>
			<ul class="list-group" id="list">'
			ForEach ($Entry in $Result){
				If ($Entry.Status -eq $False){
					$HTML += "<li class=$listitemdead>"
				}Else{
					$HTML += "<li class=$listitemalive>"
				}
			$HTML += "<p class=$column>$($Entry.DeviceName)</p>"		
			$HTML += "<p class=$column>$($Entry.DeviceIP)</p>"
			$HTML += "<p class=$column>"
				If ($Entry.Status -eq $False){
					$HTML += "Dead</p></li>"
				}Else{
					$HTML += "Alive</p></li>"
				}				
		}
		$HTML += "</ul></body></html>"
	$HTML | Out-File $OutputFile
	
	Start-Sleep -Seconds 1
}