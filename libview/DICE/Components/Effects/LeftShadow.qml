import QtGraphicalEffects 1.0

RectangularGlow {
    width: 2
    height: parent.height
    anchors.right: parent.left
    glowRadius: 4
    spread: 0.1
    color: "#000"
    cornerRadius: 5
    anchors.left: parent.left
    opacity: 0.12
}
