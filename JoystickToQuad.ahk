DebugEngineMode := false

XYSensitivity := 4
RotateSensitivity := -4
ThrottleSensitivity := 1

ButtonFire = 1
ButtonEngines = 2
JoystickNumber = 1

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

LargestValue(a,b,c,d) {
  SetFormat, float, 3.4
  biggest := Abs(a) > Abs(b) ? Abs(a) : Abs(b)
  biggest := Abs(c) > biggest ? Abs(c) : biggest
  biggest := Abs(d) > biggest ? Abs(d) : biggest
  return Abs(biggest)
}


WatchJoystick:
SetFormat, float, 3.4
GetKeyState, inputTwist, %JoystickNumber%JoyR
GetKeyState, inputThrottle, %JoystickNumber%JoyZ
GetKeyState, inputSlider, %JoystickNumber%JoyU
GetKeyState, inputX, %JoystickNumber%JoyX
GetKeyState, inputY, %JoystickNumber%JoyY
inputThrottle := -1 * (inputThrottle - 100)/100 ; (0-1)
inputX := (inputX - 50)/50 ; (-1,1)
inputY := (inputY - 50)/50 ; (-1,1)
inputSlider := (inputSlider - 50)/50 ; (-1,1)

if (IsEnabled == false) {
  return
}

; Main formula to map inputs to outputs
CurrentEnginePower1 := (ThrottleSensitivity * inputThrottle) + (XYSensitivity * (inputX) + XYSensitivity * (inputY) - RotateSensitivity * (inputSlider))
CurrentEnginePower2 := (ThrottleSensitivity * inputThrottle) + (-XYSensitivity * (inputX) + XYSensitivity * (inputY) + RotateSensitivity * (inputSlider))
CurrentEnginePower3 := (ThrottleSensitivity * inputThrottle) + (-XYSensitivity * (inputX) - XYSensitivity * (inputY) - RotateSensitivity * (inputSlider))
CurrentEnginePower4 := (ThrottleSensitivity * inputThrottle) + (XYSensitivity * (inputX) - XYSensitivity * (inputY) + RotateSensitivity * (inputSlider))

; normalize power
biggest := LargestValue(CurrentEnginePower1, CurrentEnginePower2, CurrentEnginePower3, CurrentEnginePower4)
CurrentEnginePower1 := (CurrentEnginePower1 / biggest) + (inputThrottle - 1)
CurrentEnginePower2 := (CurrentEnginePower2 / biggest) + (inputThrottle - 1)
CurrentEnginePower3 := (CurrentEnginePower3 / biggest) + (inputThrottle - 1)
CurrentEnginePower4 := (CurrentEnginePower4 / biggest) + (inputThrottle - 1)

if (DebugEngineMode == true) {
  Tooltip, %biggest%`, x %inputX%`, y %inputY%`, s %inputSlider%`, t %inputThrottle%`, e1 %CurrentEnginePower1%`,e2 %CurrentEnginePower2%`,e3 %CurrentEnginePower3%`,e4 %CurrentEnginePower4%`
  return
}

DesireToMoveEngine1 += CurrentEnginePower1
DesireToMoveEngine2 += CurrentEnginePower2
DesireToMoveEngine3 += CurrentEnginePower3
DesireToMoveEngine4 += CurrentEnginePower4

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

if (DesireToMoveEngine3 > 1) {
  DesireToMoveEngine3 += -1
  Send, {NumPad5}
}

if (DesireToMoveEngine3 < -1) {
  DesireToMoveEngine3 += 1
  Send, {NumPad6}
}

if (DesireToMoveEngine4 > 1) {
  DesireToMoveEngine4 += -1
  Send, {NumPad7}
}

if (DesireToMoveEngine4 < -1) {
  DesireToMoveEngine4 += 1
  Send, {NumPad8}
}
return
