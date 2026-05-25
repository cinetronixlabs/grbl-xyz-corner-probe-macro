%endmillDiameter = 6.35
%toolR = endmillDiameter / 2

%probeBlockZ = 5.04
%probeBlockX = 10.03
%probeBlockY = 10.00

%fast = 70.0
%slow = 30.0

; ------------------------------------------------------------
; Corner direction setting
; ------------------------------------------------------------
; Left Front  : sx =  1, sy =  1
; Left Back   : sx =  1, sy = -1
; Right Front : sx = -1, sy =  1
; Right Back  : sx = -1, sy = -1
;
; Note:
; These sx / sy values are based on the actual X+ / Y+
; movement directions of your machine.
; They do not depend on the homing position itself.
; If your machine has different axis directions, verify the
; probing direction before running the macro.
;
; This default setting is for the left-back corner.

%sx = 1
%sy = -1

%safeZ = 13.0

%zProbeTravel = 30.0
%zBackoff = 2.0
%zReprobeTravel = 5.0
%zLiftAfterProbe = 3.0

%zTouchDistanceX = 10.0
%zTouchDistanceY = 10.0

%xyApproach = 20.0
%xyProbeTravel = 45.0
%xyDepthBelowPlateTop = 3.0
%xyBackoff = 2.0
%xyReprobeTravel = 8.0
%xyOutClear = 10.0
%xyInsetFromEdge = 5.0

G21
G90
G94
M5

M0 ; Before continuing, place the end mill in the probe block corner hole. The tool tip should be below the top surface of the probe block. Make sure the spindle is OFF.

G91

; ---- Lift the tool out of the corner hole ----
G0 Z[safeZ]

; ---- Move to the Z probing position ----
G0 X[zTouchDistanceX * sx] Y[zTouchDistanceY * sy]

; ---- Z probe ----
G38.2 Z[-zProbeTravel] F[fast]
G0 Z[zBackoff]
G38.2 Z[-zReprobeTravel] F[slow]
G4 P0.1

; Set the current Z position to the probe block thickness
G10 L20 P0 Z[probeBlockZ]
G4 P0.1

; Lift above the probe block top surface
G0 Z[zLiftAfterProbe]

; ---- Move outside the X side ----
G0 X[-(zTouchDistanceX + xyApproach) * sx]

; ---- Lower to the XY probing height ----
G0 Z[-(zLiftAfterProbe + xyDepthBelowPlateTop)]

; ---- X probe ----
G38.2 X[xyProbeTravel * sx] F[fast]
G0 X[-xyBackoff * sx]
G38.2 X[xyReprobeTravel * sx] F[slow]
G4 P0.1

; Set X coordinate from the detected X side
G10 L20 P0 X[-(toolR + probeBlockX) * sx]
G4 P0.1

; Move away from the X contact face
G0 X[-xyOutClear * sx]

; ---- Move outside the Y side ----
G0 Y[-(zTouchDistanceY + xyApproach) * sy]

; Move slightly inside from the detected X edge before probing Y
G90
G0 X[xyInsetFromEdge * sx]
G91

; ---- Y probe ----
G38.2 Y[xyProbeTravel * sy] F[fast]
G0 Y[-xyBackoff * sy]
G38.2 Y[xyReprobeTravel * sy] F[slow]
G4 P0.1

; Set Y coordinate from the detected Y side
G10 L20 P0 Y[-(toolR + probeBlockY) * sy]
G4 P0.1

; Move away from the Y contact face
G0 Y[-xyOutClear * sy]

; ---- Finish ----
G0 Z10

G90
G0 X0 Y0
