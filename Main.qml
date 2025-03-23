// import QtQuick 2.15
// import QtQuick.VirtualKeyboard
// import QtQuick.Controls 2.15
// import QtQuick.Window 2.15

// Window {
//     visible: true
//     width: 600
//     height: 400
//     title: "Shortcut Practice with Key Text Display"

//     // Define shortcuts and current index
//     property var shortcuts: [
//         { text: "Press Ctrl + C to copy", key: Qt.Key_C, modifier: Qt.ControlModifier },
//         { text: "Press Ctrl + V to paste", key: Qt.Key_V, modifier: Qt.ControlModifier },
//         { text: "Press Ctrl + X to cut", key: Qt.Key_X, modifier: Qt.ControlModifier }
//     ]



//     property int currentIndex: 0

//     // Model to store pressed keys
//     ListModel { id: keyModel }

//     // Timer for clearing rectangles and feedback after 2 seconds
//     Timer {
//         id: clearTimer
//         interval: 2000 // 2 seconds
//         repeat: false
//         onTriggered: {
//             keyModel.clear(); // Clear all rectangles after timer triggers
//             feedbackText.text = ""; // Clear feedback text after timer triggers

//             // Update shortcut text to the next shortcut after clearing
//             currentIndex = (currentIndex + 1) % shortcuts.length;
//             shortcutText.text = shortcuts[currentIndex].text;
//         }
//     }

//     // Create a focusable area using Item
//     Item {
//         anchors.fill: parent
//         focus: true // Ensure the item can receive keyboard focus

//         Column {
//             anchors.centerIn: parent

//             Text {
//                 id: shortcutText
//                 text: shortcuts[currentIndex].text
//                 font.pixelSize: 24
//                 anchors.horizontalCenter: parent.horizontalCenter
//             }

//             Text {
//                 id: feedbackText
//                 text: ""
//                 font.pixelSize: 18
//                 color: "green"
//                 anchors.horizontalCenter: parent.horizontalCenter
//             }

//             // Row for displaying pressed keys as rectangles with their text
//             Row {
//                 id: keyRow
//                 anchors.horizontalCenter: parent.horizontalCenter
//                 spacing: 10

//                 Repeater {
//                     model: keyModel
//                     delegate: Rectangle {
//                         width: Math.max(60, textItem.paintedWidth + 20) // Adjust width based on text length
//                         height: 60
//                         radius: 5
//                         color: "#e1e1e1"
//                         border.color: "#404040"

//                         Text {
//                             id: textItem
//                             anchors.centerIn: parent
//                             text: keyText // Display the readable name of the pressed key
//                             font.pixelSize: 18
//                             horizontalAlignment: Text.AlignHCenter
//                             verticalAlignment: Text.AlignVCenter
//                         }
//                     }
//                 }
//             }
//         }

//         // Key press handler
//         Keys.onPressed: {
//             console.log("Key pressed:", event.key, event.modifiers);

//             let keyText = ""; // Human-readable representation of the key
//             let keyTextArray = []; // Store the texts of keys (for the visual display)

//             // Check if the pressed key matches the current shortcut and prepare visual feedback for it.
//             if ((event.modifiers & shortcuts[currentIndex].modifier) && (event.key === shortcuts[currentIndex].key)) {
//                 feedbackText.text = "Correct! Well done!";
//                 feedbackText.color = "green";

//                 // Append the modifier key if present
//                 if (event.modifiers & Qt.ControlModifier) {
//                     keyTextArray.push("Ctrl");
//                 }

//                 // Append the main key (e.g., "C")
//                 keyTextArray.push(event.text.toUpperCase()); // Display the pressed character in uppercase

//                 // Add the modifier and key separately into the model
//                 for (let i = 0; i < keyTextArray.length; i++) {
//                     keyModel.append({ keyText: keyTextArray[i] });
//                 }

//                 clearTimer.restart();  // Restart timer for clearing rectangles and feedback after display time ends.
//             } else {
//                 feedbackText.text = "Try again!";
//                 feedbackText.color = "red";
//             }
//         }

//         MouseArea {
//             anchors.fill: parent
//             onClicked: {
//                 // Focus the item when clicked to ensure it receives keyboard events.
//                 forceActiveFocus();
//             }
//         }
//     }
// }






//   for making corner round and dotted

// Canvas {
//             id: canvas
//             width: parent.width
//             height: parent.height

//             onPaint: {
//                             var ctx = canvas.getContext("2d");
//                             ctx.lineWidth = 2;
//                             ctx.strokeStyle = keyColors[index] === "green" ? "green" : keyColors[index] === "red" ? "red" : "black";
//                             ctx.setLineDash([6, 3]); // Dotted effect with 6px dash and 3px space

//                             // Draw the top-left corner with arc
//                             ctx.beginPath();
//                             ctx.moveTo(20, 0);
//                             ctx.arcTo(0, 0, 0, 10, 10); // Arc to create rounded corner
//                             ctx.lineTo(0, parent.height - 10); // Line down to bottom-left
//                             ctx.arcTo(0, parent.height, 10, parent.height, 10); // Arc at bottom-left corner

//                             // Draw the bottom-right corner with arc
//                             ctx.lineTo(parent.width - 10, parent.height); // Line to bottom-right corner
//                             ctx.arcTo(parent.width, parent.height, parent.width, parent.height - 10,10); // Arc at bottom-right corner

//                             // Draw the top-right corner with arc
//                             ctx.lineTo(parent.width, 10); // Line to top-right corner
//                             ctx.arcTo(parent.width, 0, parent.width - 10, 0, 10); // Arc at top-right corner

//                             ctx.closePath();
//                             ctx.stroke();
//                         }
//         }





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
       // property string result: ""
        property var keyColors: []
        property int toggleIndex: 0

        Component.onCompleted: {
            resetKeyColors()
            keyHandler.forceActiveFocus()
        }

        function resetKeyColors() {
            keyColors = new Array(dataset[currentIndex].key.length).fill("white")
            keyColorsChanged() // Explicit signal emission
            toggleIndex = 0
        }

        Rectangle {
            id: keyHandler
            anchors.fill: parent
            color: "transparent"
            focus: true

            Keys.onPressed: (event) => {
                console.log("Key event:", event.key, "Modifiers:", event.modifiers)

                if (event.key === Qt.Key_Escape) Qt.quit()

                const expectedKey = dataset[currentIndex].key[toggleIndex]
                const isModifier = ["Ctrl", "Shift", "Alt"].includes(expectedKey)
                let isCorrect = false

                // Handle modifier keys first
                if (isModifier) {
                    isCorrect = checkModifier(expectedKey, event)
                }
                // Handle regular keys with modifiers
                else if (event.modifiers & Qt.ControlModifier && expectedKey === "C") {
                    isCorrect = true
                }
                // Handle other regular keys
                else {
                    const pressedKey = event.text.toUpperCase()
                    isCorrect = (pressedKey === expectedKey.toUpperCase())
                }

                processKeyResult(isCorrect)
                event.accepted = true
            }

            function checkModifier(expected, event) {
                switch(expected) {
                    case "Ctrl": return event.modifiers & Qt.ControlModifier
                    case "Shift": return event.modifiers & Qt.ShiftModifier
                    case "Alt": return event.modifiers & Qt.AltModifier
                }
                return false
            }

            function processKeyResult(correct) {
                if (correct) {
                    keyColors[toggleIndex] = "green"
                    toggleIndex++
                    keyColorsChanged()

                    if (toggleIndex >= dataset[currentIndex].key.length) {
                        resetTimer.start()
                    }
                } else {
                    keyColors[toggleIndex] = "red"
                    keyColorsChanged()
                    resetTimer.start()
                }
            }

            Timer {
                id: resetTimer
                interval: 1200
                onTriggered: {
                    currentIndex = (currentIndex + 1) % dataset.length;
                    resetKeyColors()
                    result = ""
                    keyHandler.forceActiveFocus()
                }
            }
        }

    Column {

        id:main

        width:parent.width
        height:parent.height
        anchors{
                 horizontalCenter: parent.horizontalCenter
                 top: parent.top
                 topMargin: parent.height/3
        }

        Text {
            id:keydes
            text: dataset[currentIndex].description
            font.pointSize: 32
            color: "white"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 100
        }

        Row {
            spacing: 30
            //anchors.horizontalCenter: parent.horizontalCenter
            anchors{
                     horizontalCenter: keydes.horizontalCenter
                     top: keydes.top
                     topMargin: 100
            }

            Repeater {
                model: dataset[currentIndex].key
                delegate: Rectangle {
                    id:keyrect

                    width: keyColors[index] === "green" ? 70 : keyColors[index] === "red" ? 70 : 60
                    height: keyColors[index] === "green" ? 50 : keyColors[index] === "red" ? 50 : 40

                    color: keyColors[index] === "green" ? "white" : keyColors[index] === "red" ? "white" : "black"
                    border.color: keyColors[index] === "green" ? "white" : keyColors[index] === "red" ? "white" : "gray"
                    border.width: 2
                    radius: 10

                    Text {
                        anchors.centerIn: parent
                        font.pointSize: 14
                        color:keyColors[index] === "green" ? "darkblack" : keyColors[index] === "red" ? "darkblack" : "gray"
                        text: modelData
                    }

                    // CheckBoxcircle

                    Rectangle{
                         visible:keyColors[index] === "green" ? true : keyColors[index] === "red" ? true : false
                       anchors{
                           right: parent.right
                           top: parent.top
                            rightMargin: -5
                            topMargin: -5
                       }

                       width:18
                       height:18
                       radius: 9

                       color:keyColors[index] === "green" ? "green" : keyColors[index] === "red" ? "red" : "black"

                       Image {
                           id: myimage
                           anchors.centerIn: parent
                             source:keyColors[index] === "green" ? "qrc:/images/right.png" : keyColors[index] === "red" ?"qrc:/images/wrong.png":"none"
                             width: parent.width/2
                             height: parent.height/2

                           }

                    }
                }
            }
        }

        Button {
            text: "Skip"

            anchors{
                     right: parent.right
                     top: parent.top
                     topMargin: parent.height/2
                     rightMargin: parent.width/4
            }

            onClicked: {
                currentIndex = (currentIndex + 1) % dataset.length;
                resetKeyColors(); // Reset colors when skipping to next shortcut.
            }
        }

        // Text {
        //     text: result
        //     font.pointSize: 30
        //     color: result === "" ? "transparent" : (result === 'Correct! Next shortcut.' ? 'green' : 'red')
        //     visible: result !== "" // Make it visible only if there is a result
        //     anchors.horizontalCenter: parent.horizontalCenter
        //     anchors.topMargin: 20
        // }
    }
}
