StartTopLeft     = 1 << 0
StartTopRight    = 1 << 1
StartBottomLeft  = 1 << 2
StartBottomRight = 1 << 3
StartAny = StartTopLeft | StartTopRight | StartBottomLeft | StartBottomRight

EndTopLeft       = 1 << 4
EndTopRight      = 1 << 5
EndBottomLeft    = 1 << 6
EndBottomRight   = 1 << 7
EndAny = EndTopLeft | EndTopRight | EndBottomLeft | EndBottomRight

Any = StartAny | EndAny
######################


StartBottomLeft | EndBottomRight
StartTopLeft | EndBottomLeft
StartTopRight | EndBottomRight
StartBottomLeft | EndBottomLeft
StartTopRight | EndBottomRight
StartTopRight | EndBottomLeft
StartTopRight | EndAny
StartTopLeft | EndBottomRight
StartTopLeft | EndBottomLeft
StartTopRight | EndBottomLeft | EndTopLeft
StartTopRight | EndBottomRight
StartTopLeft | EndBottomRight
StartBottomLeft | EndBottomRight
StartBottomLeft | EndTopRight
StartTopLeft | StartTopRight | EndTopLeft | EndTopRight
StartBottomLeft | EndAny
255
StartBottomLeft | EndAny
StartTopRight | EndBottomLeft
StartTopLeft | EndBottomRight
StartTopLeft | EndTopRight
StartTopLeft | EndTopRight
StartTopLeft | EndTopRight
StartTopLeft | EndTopRight
StartTopLeft | EndTopRight
StartTopLeft | EndAny
StartTopLeft | EndBottomRight
StartTopLeft | EndTopRight
StartTopRight | EndTopLeft
StartTopLeft | EndTopRight
StartBottomLeft | EndAny
StartBottomLeft | EndBottomRight


