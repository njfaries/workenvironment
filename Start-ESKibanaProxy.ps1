<#
.SYNOPSIS
Starts an elasticsearch proxy on localhost with a set of Amazon IAM credentials. Must have installed the 
aws-es-kibana npm package. Check http://qaserver/CloudInfrastructure/mdwiki/#!./OperationsCookbook/ViewingLogs.md 
under How to Set Up a Kibana Proxy for more details. 

.DESCRIPTION
Starts an elasticsearch proxy on localhost with a set of Amazon IAM credentials. Must have installed the 
aws-es-kibana npm package. Check http://qaserver/CloudInfrastructure/mdwiki/#!./OperationsCookbook/ViewingLogs.md 
under How to Set Up a Kibana Proxy for more details. 

$Id$

.PARAMETER Environment
The cloud environment. If specified, the script will attempt to grab the access and secret key of the aws powershell 
profile which has the same name as the environment. The environment parameter will also be used to determine the 
AWSElasticSearchEndpoint for the centralized logging server if specified.

.PARAMETER Region
AWS Region

.PARAMETER LocalPort
The local port to host the proxy

.PARAMETER
AWSElasticSearchEndpoint
The public endpoint of the elasticsearch cluster. 

.PARAMETER
AWSAccessKey
The aws access key to use. If specified, it will override any keys associated with the aws profile for a specified 
environment.

.PARAMETER
AWSSecretKey
The aws secret key to use. If specified, it will override any keys associated with the aws profile for a specified 
environment.

.PARAMETER
BindAddress
The machine addresss to host the proxy on. 

.EXAMPLE

Start-EsKibanaProxy -Environment Production -Region us-west-2

Starts a proxy for the centralized logging elasticsearch cluster in Production.
#>

function Start-ESKibanaProxy
{
    param(
        [ValidateSet("Development", "Test", "Production")]
        [string]$Environment = "Development",
        [string]$Region = "us-west-2",
        [int]$LocalPort = 9200,
        [string]$AWSElasticSearchEndpoint,
        [string]$AWSAccessKey,
        [string]$AWSSecretKey,
        [string]$BindAddress = "localhost"
    )

    process
    {
        if (-not (($AWSAccessKey) -and ($AWSSecretKey)))
        {
            if (-not $Environment -or $Environment -eq "")
            {
                Write-Error "Must specify one of environment or aws access/secret key"
                exit(2)
            }
    
            $credentials = Get-AwsCredentials -ProfileName $Environment
            if (!$credentials)
            {
                $credentials = Get-AwsCredentials -ProfileName $Environment.ToLower()
            }
            
            $decryptedCredentials = $credentials.GetCredentials()
            $AWSAccessKey = $decryptedCredentials.AccessKey
            $AWSSecretKey = $decryptedCredentials.SecretKey
        }

        $env:AWS_ACCESS_KEY_ID = $AWSAccessKey
        $env:AWS_SECRET_ACCESS_KEY = $AWSSecretKey

        if (-not $AWSElasticSearchEndpoint -or $AWSElasticSearchEndpoint -eq "")
        {
            if ($Environment.ToLower() -eq "development")
            {
                $AWSElasticSearchEndpoint = "search-cloud-logs-us-west-2-pxia7bo2rqac4x7sq4gkahlpea.us-west-2.es.amazonaws.com"
            }
            elseif($Environment.ToLower() -eq "test")
            {
                $AWSElasticSearchEndpoint = "search-cloud-logs-us-west-2-pb5jch2xlf5vffuee2357npabm.us-west-2.es.amazonaws.com"
            }
            elseif($Environment.ToLower() -eq "production")
            {
                $AWSElasticSearchEndpoint = "search-cloud-logs-us-west-2-7osebgqfgunthvzrjxtm6cotvi.us-west-2.es.amazonaws.com"
            }
            else
            {
                Write-Error "No elastic search endpoint exists in this environment"
                exit(2)
            }
        }

        aws-es-kibana $AWSElasticSearchEndpoint -r $Region.ToLower() -b $BindAddress -p $LocalPort
    }
}