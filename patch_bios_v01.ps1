$ErrorActionPreference = "Stop"
# Check if a file path argument was provided
Write-Host $args
if ($args.Length -gt 1) {
    # The first command-line argument is stored in $args[0]
    $filePath_ref = $args[0]
    $filePath = $args[1]
    Write-Host "Processing file: $filePath using file $filePath_ref as reference" -ForegroundColor Green

    # Use System.IO.Path to extract just the file name with extension
    $fileNameWithExtension = [System.IO.Path]::GetFileName($filePath)
    $fileNameWithExtension_ref = [System.IO.Path]::GetFileName($filePath_ref)

    # Use System.IO.Path to extract the file name without the extension (BaseName)
    $fileNameOnly = [System.IO.Path]::GetFileNameWithoutExtension($filePath)
    $fileNameExt = [System.IO.Path]::GetExtension($filePath)
    $fileNameOnly_ref = [System.IO.Path]::GetFileNameWithoutExtension($filePath_ref)

    # Example of using the file name (e.g., for logging or further processing)
    # ...
} else {
    Write-Host "Error: No files provided as a command-line argument."
    throw "Terminating"
}

$currentDir = (Get-Location).Path
Write-Host "Current Directory is ", $currentDir
$filePath = $currentDir + "\" + $fileNameWithExtension
$filePath_mod = $currentDir + "\" + $fileNameOnly + "_mod" + $fileNameExt
$filePath_ref = $currentDir + "\" + $fileNameWithExtension_ref
Write-Host "Reference Bios file that you downloaded ", $filePath_ref
Write-Host "Input BIOS that you captured ", $filePath
Write-Host "Modded BIOS that will be created ", $filePath_mod -ForegroundColor Green
Write-Host "All the addresses are in HEX "


#PEI module verification patch to enable boot after modifications
#see https://github.com/LongSoft/UEFITool/issues/446#issuecomment-3795919467
[byte[]]$searchBytes =  0x33, 0xC0, 0x39, 0x45, 0x08, 0x74 # The bytes to find (example: IKA in ASCII)
[byte[]]$replaceBytes = 0x33, 0xC0, 0x40, 0x5D, 0xC3, 0x74 # The bytes to replace with (example: OKY in ASCII)

Write-Host "Replacing short seq by searching the exact byte pattern " -ForegroundColor Blue

# Ensure the replacement bytes are the same length as the search bytes
if ($searchBytes.Length -ne $replaceBytes.Length) {
    Write-Error "Search bytes and replacement bytes must be the same length."
    exit
}

# --- Process ---

# 1. Read the entire file content into a byte array
$fileBytes_ref = [System.IO.File]::ReadAllBytes($filePath_ref)
$fileBytes = [System.IO.File]::ReadAllBytes($filePath)
$Size_dlt=-($fileBytes_ref.Length - $fileBytes.Length)
Write-Host "Size of the reference is ", $fileBytes_ref.Length, "; Size of the dump is ", $fileBytes.Length
Write-Host "Reference file will be applied with the following shift", $Size_dlt," and in HEX 0x",$Size_dlt.toString("X")
$searchLength = $SearchBytes.Length
$replaceLength = $ReplaceBytes.Length
$found = $false

$searchLength = $SearchBytes.Length
    $replaceLength = $ReplaceBytes.Length
    $found = $false

    # Find and replace all occurrences
    for ($i = 0; $i -lt $fileBytes.Length - $searchLength + 1; $i++) {
        $match = $true
        for ($j = 0; $j -lt $searchLength; $j++) {
            if ($fileBytes[$i + $j] -ne $SearchBytes[$j]) {
                $match = $false
                break
            }
        }
        if ($match) {
        Write-Host "Match for position 0x", $i.toString("X") -ForegroundColor Blue
            # Replace the sequence in the array
            for ($k = 0; $k -lt $replaceLength; $k++) {
                $fileBytes[$i + $k] = $ReplaceBytes[$k]
            }
            $found = $true
            # Skip the rest of the found sequence to prevent overlapping matches
            $i += $searchLength - 1
        }
    }


# Copy chunks from reference to the modded file
# Chunk1 - Vol1 & Vol2 with ReBar function; Chunk2 - Microcodes; Chunk3 - FIT and bootblock
[int[]]$Adr_start =  0x6a1000, 0xE80000, 0xFFE000 # The bytes to find (example: IKA in ASCII)
[int[]]$Adr_end =    0xCA0000, 0xEB8000, 0x1000000 # The bytes to replace with (example: OKY in ASCII)
Write-Host "Copying bytes within range from the reference BIOS to the modded BIOS "  -ForegroundColor Yellow

$Adr_length = $Adr_start.Length
    for ($i = 0; $i -lt $Adr_length; $i++) {
    $replaceLength = $Adr_end[$i]-$Adr_start[$i]
    Write-Host "Replacing from address 0x" $Adr_start[$i].toString("X") " to 0x" $Adr_end[$i].toString("X") " , replaced 0x" $replaceLength.toString("X") " bytes"-ForegroundColor Yellow
            for ($k = $Adr_start[$i]; $k -lt $Adr_end[$i]; $k++) {
                $fileBytes[$k] = $fileBytes_ref[$k-$Size_dlt]
            }
        }


    # Write the modified byte array back to the file if any changes were made
        [System.IO.File]::WriteAllBytes($filePath_mod, $fileBytes)
        Write-Host "Replacements complete. File updated." -ForegroundColor Green
		Write-Host "Modded BIOS was saved in ", $filePath_mod -ForegroundColor Green


