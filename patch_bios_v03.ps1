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



# --- Process ---

# 1. Read the entire file content into a byte array
$fileBytes_ref = [System.IO.File]::ReadAllBytes($filePath_ref)
$fileBytes = [System.IO.File]::ReadAllBytes($filePath)
$Size_dlt=0
$Size_dlt2=0
if ($fileBytes.Length -lt 0x1000000) {$Size_dlt2=0x600000}
if ($fileBytes_ref.Length -lt 0x1000000) {$Size_dlt=0x600000}

$adr_ver=0x611000
[byte[]]$filever_ref=$fileBytes_ref[($adr_ver-$Size_dlt)..($adr_ver-$Size_dlt+12)]
[byte[]]$filever=$fileBytes[($adr_ver-$Size_dlt2)..($adr_ver-$Size_dlt2+12)]


$encoding = [System.Text.Encoding]::ASCII
$filever_ref_str = $encoding.GetString($filever_ref)
$filever_str = $encoding.GetString($filever)

Write-Host "Version of Reference Bios file that you downloaded ", $filever_ref_str
Write-Host "Version of Input BIOS that you captured __________ ", $filever_str 
Write-Host "Size of the reference is ", $fileBytes_ref.Length, "; Size of the dump is ", $fileBytes.Length, " shift 0x",$Size_dlt2.toString("X")
Write-Host "Reference file will be applied with the following shift", $Size_dlt," and in HEX 0x",$Size_dlt.toString("X")


# Copy chunks from reference to the modded file

# Chunk1 - Padding & ACM; Vol1 & Vol2 with ReBar function; PEI 1; PEI 2; MC1; MC2; FIT+BB bootblock
[int[]]$Adr_start =  0x610010, 0x6a1000, 0xD39000, 0xEB0000, 0xD01000, 0xE80000, 0xFFE000  # The bytes to find (example: IKA in ASCII)
[int[]]$Adr_end =    0x6A1000, 0xCA0000, 0xE80000, 0xFFE000, 0xD31000, 0xEB0000, 0x1000000 # The bytes to replace with (example: OKY in ASCII)


Write-Host "Copying bytes within range from the reference BIOS to the modded BIOS "  -ForegroundColor Yellow

$Adr_length = $Adr_start.Length
    for ($i = 0; $i -lt $Adr_length; $i++) {
    $replaceLength = $Adr_end[$i]-$Adr_start[$i]
    Write-Host "Replacing from address 0x" $Adr_start[$i].toString("X") " to 0x" $Adr_end[$i].toString("X") " , replaced 0x" $replaceLength.toString("X") " bytes"-ForegroundColor Yellow
            for ($k = $Adr_start[$i]; $k -lt $Adr_end[$i]; $k++) {
                $fileBytes[$k-$Size_dlt2] = $fileBytes_ref[$k-$Size_dlt]
            }
        }

#PEI module verification patch to enable boot after modifications
#see https://github.com/LongSoft/UEFITool/issues/446#issuecomment-3795919467
[byte[]]$searchBytes =  0x33, 0xC0, 0x39, 0x45, 0x08, 0x74 # The bytes to find (example: IKA in ASCII)
[byte[]]$replaceBytes = 0x33, 0xC0, 0x40, 0x5D, 0xC3, 0x74 # The bytes to replace with (example: OKY in ASCII)

Write-Host "Replacing short seq by searching the exact byte pattern " -ForegroundColor Yellow

# Ensure the replacement bytes are the same length as the search bytes
if ($searchBytes.Length -ne $replaceBytes.Length) {
    Write-Error "Search bytes and replacement bytes must be the same length."
    exit
}


$searchLength = $SearchBytes.Length
$replaceLength = $ReplaceBytes.Length
$found = $false

$searchLength = $SearchBytes.Length
    $replaceLength = $ReplaceBytes.Length
    $found = $false

if ($false) { 
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
        Write-Host "Match for position 0x", $i.toString("X") -ForegroundColor Yellow
            # Replace the sequence in the array
            for ($k = 0; $k -lt $replaceLength; $k++) {
                $fileBytes[$i + $k] = $ReplaceBytes[$k]
            }
            $found = $true
            # Skip the rest of the found sequence to prevent overlapping matches
            $i += $searchLength - 1
        }
    }
}
    # Write the modified byte array back to the file if any changes were made
        [System.IO.File]::WriteAllBytes($filePath_mod, $fileBytes)
        Write-Host "Replacements complete. File updated." -ForegroundColor Green
		Write-Host "Modded BIOS was saved in ", $filePath_mod -ForegroundColor Green


