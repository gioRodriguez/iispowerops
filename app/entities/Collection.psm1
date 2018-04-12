function NewCollection {
    $collection = New-Object System.Collections.ArrayList
    $collectionInfo = @{
        'List' = $collection
    }
    $collectionObject = New-Object PSObject -Prop $collectionInfo
    $collectionObject.PSObject.TypeNames.Insert(0,'Illyum.Operations.Entities.Collection')
    
    $collectionObject = $collectionObject | Add-Member ScriptMethod Add {
            param($element)
            $this.List.Add($element) > $null
        } -PassThru -Force
    
    $collectionObject = $collectionObject | Add-Member ScriptMethod Total {
            return $this.List.Count
        } -PassThru -Force
    
    return $collectionObject
}