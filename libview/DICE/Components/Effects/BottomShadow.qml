import QtGraphicalEffects 1.0

RectangularGlow {
    width: parent.width - 2
    anchors.horizontalCenter: parent.horizontalCenter
    height: 1
    anchors.top: parent.bottom
    glowRadius: 5
    spread: 0.1
    color: "#000"
    opacity: 0.15
}
