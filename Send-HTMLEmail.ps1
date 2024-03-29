<#
.SYNOPSIS
Send an email with an object in a pretty table
.DESCRIPTION
Send email
.PARAMETER InputObject
Any PSOBJECT or other Table
.PARAMETER Subject
The Subject of the email
.PARAMETER To
The To field is who receives the email
.PARAMETER From
The From address of the email
.PARAMETER CSS
This is the Cascading Style Sheet that will be used to Style the table
.PARAMETER SmtpServer
The SMTP relay server
.EXAMPLE
PS C:\> Send-HtmlEmail -InputObject (Get-process *vmware* | select CPU, WS) -Subject "This is a process report"
An example to send some process information to email recipient
.NOTES
NAME        :  Send-HtmlEmail
VERSION     :  1.1.0   
LAST UPDATED:  01/03/2013
AUTHOR      :  Milo
.INPUTS
None
.OUTPUTS
None
#> 

function Send-HTMLEmail {
#Requires -Version 2.0
[CmdletBinding()]
 Param 
   ([Parameter(Mandatory=$True,
               Position = 0,
               ValueFromPipeline=$true,
               ValueFromPipelineByPropertyName=$true,
               HelpMessage="Please enter the Inputobject")]
    $InputObject,
    [Parameter(Mandatory=$True,
               Position = 1,
               ValueFromPipeline=$true,
               ValueFromPipelineByPropertyName=$true,
               HelpMessage="Please enter the Subject")]
    [String]$Subject,    
    [Parameter(Mandatory=$False,
               Position = 2,
               HelpMessage="Please enter the To address")]    
    [String[]]$To = "user@domain.com",
    [String]$From = "Admin@domain.com",    
    [String]$CSS,
    [String]$SmtpServer ="smtprelay.domain.com"
   )#End Param

if (!$CSS)
{
    $CSS = @"
        <style type="text/css">
            table {
    	    font-family: Verdana;
    	    border-style: solid;
    	    border-width: 1px;
    	    border-color: #FF6600;
    	    padding: 5px;
    	    table-layout: auto;
    	    text-align: center;
    	    font-size: 8pt;
            }

            table th {
    	    border-bottom-style: solid;
    	    border-bottom-width: 1px;
            font: bold;
            }
            table td {
    	    border-top-style: solid;
    	    border-top-width: 1px;
            }
            .style1 {
            font-family: Courier New, Courier, monospace;
            font-weight:bold;
            font-size:small;
            }
            </style>
"@
}#End if

$HTMLDetails = @{
    Title = $Subject
    Head = $CSS
    }
    
$Splat = @{
    To         =$To
    Body       ="$($InputObject | ConvertTo-Html @HTMLDetails)"
    Subject    =$Subject
    SmtpServer =$SmtpServer
    From       =$From
    BodyAsHtml =$True
    }
    Send-MailMessage @Splat
    
}#Send-HTMLEmail