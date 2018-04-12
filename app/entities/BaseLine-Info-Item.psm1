function NewBaseLineInfoItem ($category, $attribute, $value, $description = '') {
     $baseLineItemInfo = @{
        'Server' = $env:computername;
        'Category' = $category;
        'Attribute' = $attribute;
        'Value' = $value;
        'Description' =  $description;
    }

    $baseLineItemObject = New-Object PSObject -Prop $baseLineItemInfo
    $baseLineItemObject.PSObject.TypeNames.Insert(0,'Illyum.Operations.Entities.BaseLine.ItemInfo')

    return $baseLineItemObject
}