DebugEngineMode := false

XYThrow := 20
RotateSensitivity := 1
ThrottleSensitivity := 1

ButtonFire = 1
ButtonEngines = 2
JoystickNumber = 1
ExpoRate = 0.40 ; 0 is regular linear, 1 is full expo

; END OF CONFIG SECTION -- Don't change anything below this point unless you want
; to alter the basic nature of the script.

#SingleInstance

JoystickPrefix = %JoystickNumber%Joy
Hotkey, %JoystickPrefix%%ButtonFire%, DropBombs
Hotkey, %JoystickPrefix%%ButtonEngines%, ToggleEngines

IsEnabled := false

SetTimer, WatchJoystick, 10

GetKeyState, JoyInfo, %JoystickNumber%JoyInfo


return  ; End of auto-execute section.

DropBombs:
Send, c
return

ToggleEngines:
if (IsEnabled == true) {
  IsEnabled := false
  SoundBeep, 440, 500
}
else {
  SoundBeep, 880, 100
  sleep, 20
  SoundBeep, 880, 100
  sleep, 20
  SoundBeep, 880, 100
  IsEnabled := true
}
return

LargestValue(a,b,c) {
  SetFormat, float, 3.4
  biggest := Abs(a) > Abs(b) ? Abs(a) : Abs(b)
  biggest := Abs(c) > biggest ? Abs(c) : biggest
  return Abs(biggest)
}


WatchJoystick:
SetFormat, float, 3.4
GetKeyState, inputTwist, %JoystickNumber%JoyR
GetKeyState, inputThrottle, %JoystickNumber%JoyZ
GetKeyState, inputSlider, %JoystickNumber%JoyU
GetKeyState, inputX, %JoystickNumber%JoyX
GetKeyState, inputY, %JoystickNumber%JoyY
inputThrottle := -1 * (inputThrottle - 50)/50 ; (-1,1)
inputX := (inputX - 50)/50 ; (-1,1)
inputY := (inputY - 50)/50 ; (-1,1)
inputSlider := (inputSlider - 50)/50 ; (-1,1)

; expo rates
inputX := (inputX * Abs(inputX)) * ExpoRate + inputX * (1 - ExpoRate)
inputY := (inputY * Abs(inputY)) * ExpoRate + inputY * (1 - ExpoRate)

if (IsEnabled == false) {
  return
}

; Main formula to map inputs to outputs
CurrentEnginePower1 := ThrottleSensitivity * inputThrottle - RotateSensitivity * inputSlider
CurrentEnginePower2 := ThrottleSensitivity * inputThrottle + RotateSensitivity * inputSlider

; normalize power
biggest := LargestValue(1, CurrentEnginePower1, CurrentEnginePower2)
CurrentEnginePower1 := (CurrentEnginePower1 / biggest) * Abs(inputThrottle)
CurrentEnginePower2 := (CurrentEnginePower2 / biggest) * Abs(inputThrottle)

; for stick
TargetX := inputX * XYThrow
TargetY := inputY * XYThrow



if (DebugEngineMode == true) {
  Tooltip, x %inputX%`, y %inputY%`, s %inputSlider%`, t %inputThrottle%`, e1 %CurrentEnginePower1%`,e2 %CurrentEnginePower2%`, tx %TargetX%`, ty %TargetY%`, cx %CurrentX%`,cy %CurrentY%`
  return
}

DesireToMoveEngine1 += CurrentEnginePower1
DesireToMoveEngine2 += CurrentEnginePower2

if (DesireToMoveEngine1 > 1) {
  DesireToMoveEngine1 += -1
  Send, {NumPad1}
}

if (DesireToMoveEngine1 < -1) {
  DesireToMoveEngine1 += 1
  Send, {NumPad2}
}

if (DesireToMoveEngine2 > 1) {
  DesireToMoveEngine2 += -1
  Send, {NumPad3}
}

if (DesireToMoveEngine2 < -1) {
  DesireToMoveEngine2 += 1
  Send, {NumPad4}
}

if (TargetY - CurrentY < -1 ) {
  Send, {Up}
  CurrentY -= 1
}
if (TargetY - CurrentY > 1) {
  Send, {Down}
  CurrentY += 1
}

if (TargetX - CurrentX < -1 ) {
  Send, {Left}
  CurrentX -= 1
}
if (TargetX - CurrentX > 1) {
  Send, {Right}
  CurrentX += 1
}
return
