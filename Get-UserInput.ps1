param (
    [switch]$unattended = $false
)

function Get-UserInput {
    param (
        [string]$PromptMessage,
        $CurrentValue
    )

    # Display the prompt message and read the user's input
    if ($unattended)
    {
        return $CurrentValue
    }
    $PromptMessage = "$PromptMessage [$CurrentValue]"
    $userInput = Read-Host -Prompt $PromptMessage

    # Return the user's input
    return $(if ($userInput -eq ""){$CurrentValue} else {$userInput})
}
