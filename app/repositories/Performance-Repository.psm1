function GetPercentProcessorUsed {
    $processorTime = Get-Counter -Counter "\Processor(_Total)\% Processor Time"
    return $processorTime.CounterSamples.CookedValue
}

Export-ModuleMember -Function 'Get*'