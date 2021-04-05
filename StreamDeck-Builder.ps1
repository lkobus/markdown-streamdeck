param($yamlInput, $outputCsv)

Import-Module powershell-yaml

Function GenerateMd($yamlInput, $outputCsv){
    $yamlInput = Get-Content $yamlInput | ConvertFrom-Yaml
    if($null -ne $yamlInput.IconUriPath){ 
        $global:IconUriPath = $yamlInput.IconUriPath
    }
    
    GenerateMdOutput $yamlInput.Services $outputCsv

    if($null -ne $yamlInput.Libs){
        GenerateMdOutput $yamlInput.Libs ($outputCsv.Replace('.md', '-libs.md'))    
    }
    
    if($null -ne $yamlInput.Jobs){
        GenerateMdOutput $yamlInput.Jobs ($outputCsv.Replace('.md', '-jobs.md'))
    }
    
}

Function GenerateMdOutput($collection, $output) {
    $result = FetchCsvModel $collection

    $first = $true
    $mdResult = @()
    $result | ForEach-Object { 
        if($first) {
            $first = $false
            $mdResult += BuildMdTableContent $_
            $mdResult += BuildMdTableSpecs $_
        } else {
            $mdResult += BuildMdTableContent $_
        }
    }

    if(Test-Path $output) { Clear-Content $output }    
    $mdResult | ForEach-Object { Add-Content $output $_ }
    
}

Function BuildMdTableContent($content) {
    $headers = $_.Split(';')           
    $result = "| "
    $headers | foreach { 
        $result = ($result + $_ + " | ")
    }
    $result = $result.TrimEnd()
    return $result
}

Function BuildMdTableSpecs($headers) {
    $headers = $_.Split(';')           
    $result = "|:--"
    $headers | foreach { 
        $result = ($result + "--:|:--")
    }
    $result = $result.TrimEnd('-').TrimEnd('-').TrimEnd(':')
    return $result
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
    $uriPath = $global:IconUriPath
    if($null -ne $content["IconUriPath"]) {
        $uriPath = $content["IconUriPath"]
    }    
    return $uriPath.TrimEnd('/') + "/" + $content["IconFileName"]
}

GenerateMd $yamlInput $outputCsv
#GenerateCsv .\micro_services.yaml .\out.csv