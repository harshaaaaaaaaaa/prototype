import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    id: mainWindow
    visible: true
    width: 800
    height: 600
    title: "Keyboard Shortcuts"
    color: "black"

    // Dataset of keyboard shortcuts (converted from data.jsx)
    property var dataset: [
        {key: ["Ctrl", "C"], description: "Copy selected text"},
        {key: ["Ctrl", "X"], description: "Cut"},
        {key: ["Ctrl", "V"], description: "Paste"},
        {key: ["Ctrl", "Z"], description: "Undo"},
        {key: ["Ctrl", "Y"], description: "Redo"},
        {key: ["Ctrl", "A"], description: "Select all"},
        {key: ["Ctrl", "P"], description: "Print"},
        {key: ["Ctrl", "S"], description: "Save"},
        {key: ["Ctrl", "N"], description: "New window/document"},
        {key: ["Ctrl", "O"], description: "Open"},
        {key: ["Ctrl", "W"], description: "Close"}
    ]

    property int currentIndex: 0
    property var keyColors: []
    property int toggleIndex: 0
    property bool ctrlPressed: false
    property string feedbackMessage: ""

    Component.onCompleted: {
        resetKeyColors()
        keyHandler.forceActiveFocus()
    }

    function resetKeyColors() {
        keyColors = new Array(dataset[currentIndex].key.length).fill("white")
        keyColorsChanged() // Explicit signal emission
        toggleIndex = 0
        feedbackMessage = ""
    }

    Rectangle {
        id: keyHandler
        anchors.fill: parent
        color: "transparent"
        focus: true

        Keys.onPressed: (event) => {
            console.log("Key event:", event.key, "Modifiers:", event.modifiers)
            if (event.key === Qt.Key_Escape) Qt.quit()

            const expectedKeys = dataset[currentIndex].key

            // Check if Ctrl key is pressed
            if (event.key === Qt.Key_Control) {
                ctrlPressed = true
                // Highlight the Ctrl key if it's the first expected key
                if (expectedKeys[0] === "Ctrl") {
                    keyColors[0] = "green"
                    keyColorsChanged()
                    toggleIndex = 1 // Move to the next expected key
                }
            }
            // If we're expecting a letter key after Ctrl
            else if (ctrlPressed && toggleIndex === 1) {
                // Get the expected character key
                const expectedChar = expectedKeys[1]

                // Convert the pressed key to a character
                let pressedChar = String.fromCharCode(event.key).toUpperCase()

                // Special case for common keys
                if (event.key === Qt.Key_C) pressedChar = "C"
                else if (event.key === Qt.Key_X) pressedChar = "X"
                else if (event.key === Qt.Key_V) pressedChar = "V"
                else if (event.key === Qt.Key_Z) pressedChar = "Z"
                else if (event.key === Qt.Key_Y) pressedChar = "Y"
                else if (event.key === Qt.Key_A) pressedChar = "A"
                else if (event.key === Qt.Key_P) pressedChar = "P"
                else if (event.key === Qt.Key_S) pressedChar = "S"
                else if (event.key === Qt.Key_N) pressedChar = "N"
                else if (event.key === Qt.Key_O) pressedChar = "O"
                else if (event.key === Qt.Key_W) pressedChar = "W"

                console.log("Expected char:", expectedChar, "Pressed char:", pressedChar)

                if (pressedChar === expectedChar) {
                    // Correct key combination
                    keyColors[1] = "green"
                    keyColorsChanged()
                    feedbackMessage = "Correct! Well done!"

                    // Success! Move to next shortcut after delay
                    successTimer.start()
                } else {
                    // Wrong key combination
                    keyColors[1] = "red"
                    keyColorsChanged()
                    feedbackMessage = "Try again!"

                    // Reset the key colors after a short delay but stay on same question
                    wrongKeyTimer.start()
                }
            }
            else {
                // If a key is pressed without Ctrl or out of order
                if (toggleIndex < expectedKeys.length) {
                    keyColors[toggleIndex] = "red"
                    keyColorsChanged()
                    feedbackMessage = "Try again! Remember to press keys in sequence."
                    wrongKeyTimer.start()
                }
            }

            event.accepted = true
        }

        Keys.onReleased: (event) => {
            // Reset Ctrl pressed state when Ctrl is released
            if (event.key === Qt.Key_Control) {
                ctrlPressed = false

                // If we haven't completed the sequence yet, mark it as failed
                if (toggleIndex === 1) {
                    keyColors[1] = "red"
                    keyColorsChanged()
                    feedbackMessage = "Try again! Hold Ctrl while pressing the second key."
                    wrongKeyTimer.start()
                }
            }
            event.accepted = true
        }

        Timer {
            id: successTimer
            interval: 1500
            onTriggered: {
                currentIndex = (currentIndex + 1) % dataset.length
                resetKeyColors()
                keyHandler.forceActiveFocus()
            }
        }

        Timer {
            id: wrongKeyTimer
            interval: 1000
            onTriggered: {
                resetKeyColors()
                keyHandler.forceActiveFocus()
            }
        }
    }

    Column {
        id: main
        width: parent.width
        height: parent.height
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: parent.height/3
        }

        Text {
            id: keydes
            text: dataset[currentIndex].description
            font.pointSize: 32
            color: "white"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 100
        }

        // Feedback message display
        Text {
            visible: feedbackMessage !== ""
            text: feedbackMessage
            font.pointSize: 24
            color: feedbackMessage.includes("Correct") ? "green" : "red"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: keydes.bottom
            anchors.topMargin: 20
        }

        Row {
            spacing: 30
            anchors {
                horizontalCenter: keydes.horizontalCenter
                top: keydes.bottom
                topMargin: 80
            }

            Repeater {
                model: dataset[currentIndex].key
                delegate: Rectangle {
                    id: keyrect
                    width: keyColors[index] === "green" ? 70 : keyColors[index] === "red" ? 70 : 60
                    height: keyColors[index] === "green" ? 50 : keyColors[index] === "red" ? 50 : 40
                    color: keyColors[index] === "green" ? "white" : keyColors[index] === "red" ? "white" : "black"
                    border.color: keyColors[index] === "green" ? "white" : keyColors[index] === "red" ? "white" : "gray"
                    border.width: 2
                    radius: 10

                    Text {
                        anchors.centerIn: parent
                        font.pointSize: 14
                        color: keyColors[index] === "green" ? "darkblack" : keyColors[index] === "red" ? "darkblack" : "gray"
                        text: modelData
                    }

                    // CheckBoxcircle
                    Rectangle {
                        visible: keyColors[index] === "green" ? true : keyColors[index] === "red" ? true : false
                        anchors {
                            right: parent.right
                            top: parent.top
                            rightMargin: -5
                            topMargin: -5
                        }
                        width: 18
                        height: 18
                        radius: 9
                        color: keyColors[index] === "green" ? "green" : keyColors[index] === "red" ? "red" : "black"

                        Image {
                            id: myimage
                            anchors.centerIn: parent
                            source: keyColors[index] === "green" ? "qrc:/images/right.png" : keyColors[index] === "red" ? "qrc:/images/wrong.png" : "none"
                            width: parent.width/2
                            height: parent.height/2
                        }
                    }
                }
            }
        }

        Button {
            text: "Skip"
            anchors {
                right: parent.right
                top: parent.top
                topMargin: parent.height/2
                rightMargin: parent.width/4
            }
            onClicked: {
                currentIndex = (currentIndex + 1) % dataset.length
                resetKeyColors()
                keyHandler.forceActiveFocus()
            }
        }
    }
}
