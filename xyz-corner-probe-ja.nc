%endmillDiameter = 6.35
%toolR = endmillDiameter / 2

%probeBlockZ = 5.04
%probeBlockX = 10.03
%probeBlockY = 10.00

%fast = 70.0
%slow = 30.0

; ------------------------------------------------------------
; コーナー方向設定
; ------------------------------------------------------------
; 左手前 : sx =  1, sy =  1
; 左奥   : sx =  1, sy = -1
; 右手前 : sx = -1, sy =  1
; 右奥   : sx = -1, sy = -1
;
; 注意:
; sx / sy の値は、機械の実際の X+ / Y+ 方向を基準にしています。
; 原点復帰位置そのものには依存しません。
; 機械の軸方向が異なる場合は、実行前に必ず
; プロービング方向を確認してください。
;
; 初期設定は左奥コーナー用です。

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

M0 ; 続行前に、エンドミルをプローブブロックのコーナー穴に入れてください。工具先端はプローブブロック上面より下にある状態にし、スピンドルは必ずOFFにしてください。

G91

; ---- コーナー穴から工具を上へ抜く ----
G0 Z[safeZ]

; ---- Z測定位置へ移動 ----
G0 X[zTouchDistanceX * sx] Y[zTouchDistanceY * sy]

; ---- Zプローブ ----
G38.2 Z[-zProbeTravel] F[fast]
G0 Z[zBackoff]
G38.2 Z[-zReprobeTravel] F[slow]
G4 P0.1

; 現在位置のZをプローブブロックの厚みに設定
G10 L20 P0 Z[probeBlockZ]
G4 P0.1

; プローブブロック上面から少し上げる
G0 Z[zLiftAfterProbe]

; ---- X側の外側へ移動 ----
G0 X[-(zTouchDistanceX + xyApproach) * sx]

; ---- XY測定用の高さまで下げる ----
G0 Z[-(zLiftAfterProbe + xyDepthBelowPlateTop)]

; ---- Xプローブ ----
G38.2 X[xyProbeTravel * sx] F[fast]
G0 X[-xyBackoff * sx]
G38.2 X[xyReprobeTravel * sx] F[slow]
G4 P0.1

; 測定したX側を基準にX座標を設定
G10 L20 P0 X[-(toolR + probeBlockX) * sx]
G4 P0.1

; X接触面から逃がす
G0 X[-xyOutClear * sx]

; ---- Y側の外側へ移動 ----
G0 Y[-(zTouchDistanceY + xyApproach) * sy]

; Y測定前に、測定済みのX端面から少し内側へ入る
G90
G0 X[xyInsetFromEdge * sx]
G91

; ---- Yプローブ ----
G38.2 Y[xyProbeTravel * sy] F[fast]
G0 Y[-xyBackoff * sy]
G38.2 Y[xyReprobeTravel * sy] F[slow]
G4 P0.1

; 測定したY側を基準にY座標を設定
G10 L20 P0 Y[-(toolR + probeBlockY) * sy]
G4 P0.1

; Y接触面から逃がす
G0 Y[-xyOutClear * sy]

; ---- 終了動作 ----
G0 Z10

G90
G0 X0 Y0
