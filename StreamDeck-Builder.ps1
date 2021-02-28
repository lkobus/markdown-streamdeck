param($yamlInput, $outputCsv)

Import-Module powershell-yaml

<#
.SYNOPSIS
# Generates csv outputs

.DESCRIPTION
Convert a YAML to csv

.PARAMETER yamlInput
Parameter the yaml

.PARAMETER outputCsv
Parameter the output

.EXAMPLE
An example

.NOTES
General notes
#>
Function GenerateCsv($yamlInput, $outputCsv){
    $yamlInput = Get-Content $yamlInput | ConvertFrom-Yaml
    GenerateCsvOutput $yamlInput.Services $outputCsv
    GenerateCsvOutput $yamlInput.Libs ($outputCsv.Replace('.csv', '-libs.csv'))
}

Function GenerateCsvOutput($collection, $output) {
    $result = FetchCsvModel $collection
    if(Test-Path $output) { Clear-Content $output }    
    $result | ForEach-Object { Add-Content $output $_ }
}


Function FetchCsvModel ($inputResource) {
    $first = $true
    $result = @()
    $inputResource | ForEach-Object {
        $headerList =  new-object string[] 100        
        $currentObj = $_
        $serviceName = $_.Keys[0]
        
        $cellList =  new-object string[] 100
        $_[$serviceName].Keys | ForEach-Object {
            $currentContext = $currentObj[[string]$serviceName][[string]$_]
            $contentCell = BuildContentCell $currentContext
            $currentCellPosition = ([int]$currentContext["ColumnPosition"] - 1)

            if($currentCellPosition -ne -1) {
                $oldCell = $cellList[$currentCellPosition]
                $oldHeader = $headerList[$currentCellPosition]
                if($null -ne $oldCell) {
                    AddNextAvaliable $cellList $oldCell
                    AddNextAvaliable $headerList $oldHeader
                }
                $cellList[$currentCellPosition] = $contentCell
                $headerList[$currentCellPosition] = $_
            } else {
                AddNextAvaliable $cellList $contentCell                
                AddNextAvaliable $headerList $_
            }            
            
        }

        $sb = ""
        if($first){
            $headerList | Where-Object { $_ -ne $null }  | ForEach-Object { $sb += $_ + ";" }        
            $first = $false
            $result += $sb.Trim(';')      
        }

        $sb = ""
        $cellList | Where-Object { $_ -ne $null }  | ForEach-Object { $sb += $_ + ";" }        
        $result += $sb.Trim(';')        
    }
    return $result
}

Function AddNextAvaliable($collection, $value) {    
    for($i = 0; $i -lt $collection.Length; $i++) {
        if($null -eq $collection[$i]){
            $collection[$i] += $value                
            break
        }
    }
}

Function BuildContentCell($content){
    if($content.Keys -contains "Hyperlink") {
        return BuildMarkdownIconButtonWithHyperlink $content
    } elseif($content.Keys -contains "Description") {
        return $content["Description"]
    } else {
        return BuildMarkdownIconButton $content
    }

}

Function BuildMarkdownIconButtonWithHyperlink($content) {
    $toolTip = $content["Tooltip"]
    $hyperlink = $content["Hyperlink"]
    $iconFileName = $content["IconFileName"]
    $iconUri = GetIconUri $content
    return "[![$iconFileName]($iconUri)]($hyperlink `"$toolTip`")"
}

Function BuildMarkdownIconButton($content) {
    $toolTip = $content["Tooltip"]
    $iconFileName = $content["IconFileName"]
    $iconUri = GetIconUri $content

    return "![$iconFileName]($iconUri `"$toolTip`")"
}

Function GetIconUri($content) {
    return $content["IconUriPath"] + "/" + $content["IconFileName"]
}

GenerateCsv $yamlInput $outputCsv
#GenerateCsv .\micro_services.yaml .\out.csv