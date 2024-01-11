@echo off
setlocal enabledelayedexpansion

:: The directory containing the images
set "IMG_DIR=R:\UNITY\Banter\SmallSpaces\Assets\Zeppelin_Z25\Textures"

:: The directory to store the output images
set "OUTPUT_DIR=R:\UNITY\Banter\SmallSpaces\Assets\Zeppelin_Z25\Textures\Compressed"

:: Create the output directory if it does not exist
if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

:: Iterate through all the "_Albedo.png" files in the directory
for %%F in ("%IMG_DIR%\*_Albedo.png") do (
    call :process "%%~nF" "%%~fF"
)
goto :eof

:: Subroutine to process each pair of "_Albedo" and "_Specular" files
:process
    set "BASE_NAME=%~1"
    set "BASE_NAME_NO_SUFFIX=%BASE_NAME:_Albedo=%"
    
    :: Debug: Print the variables
    echo Debug: BASE_NAME is %BASE_NAME%
    echo Debug: BASE_NAME_NO_SUFFIX is %BASE_NAME_NO_SUFFIX%
    
    :: The corresponding "_Specular" file
    set "SPECULAR_FILE=%IMG_DIR%\%BASE_NAME_NO_SUFFIX%_Specular.png"
    
    :: Debug: Print the name of the corresponding "_Specular" file
    echo Debug: SPECULAR_FILE is %SPECULAR_FILE%
    
    :: Check if the corresponding "_Specular" file exists
    if exist "%SPECULAR_FILE%" (
        echo Processing "%~2" and "%SPECULAR_FILE%"
        
        :: Create a temporary image with just the RGB channels from the "_Specular" file
        magick "%SPECULAR_FILE%" -channel RGB -separate -combine temp_rgb.png

        :: Insert the RGB values from "temp_rgb.png" into the alpha channel of the "_Albedo" file and save as PNG
        magick "%~2" temp_rgb.png -alpha off -compose copy_opacity -composite "%OUTPUT_DIR%\%BASE_NAME_NO_SUFFIX%_Combined.png"

        :: Remove the temporary image
        del temp_rgb.png
    ) else (
        echo Warning: No matching "_Specular" file found for "%~2"
    )

pause