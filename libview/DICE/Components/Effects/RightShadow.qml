import QtGraphicalEffects 1.0

RectangularGlow {
    width: 2
    height: parent.height
    anchors.left: parent.right
    glowRadius: 4
    spread: 0.1
    color: "#000"
    cornerRadius: 5
    opacity: 0.12
}
