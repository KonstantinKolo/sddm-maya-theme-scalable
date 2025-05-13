//
// [maya] components/SpButton.qml
//
// Implements custom action button with label
//
// (c) 2016 Sanjeev Premi (spremi@ymail.com)
//
// SPDX-License-Identifier: MIT
//                          (https://spdx.org/licenses/MIT.html)
//


import QtQuick 2.0

Item {
  id  : sp_button

  property bool enabled : true

  property alias icon   : sp_button_icon.source
  property alias label  : sp_button_label.text
  property alias font   : sp_button_label.font

  property color iconColor        : "#aaaaaa"
  property color labelColor       : "#424242"

  property color hoverIconColor   : "#cccccc"
  property color hoverLabelColor  : "#808080"

  property color pressIconColor   : "#753636"
  property color pressLabelColor  : "#753636"

  property color disableColor     : "#888888"

  readonly property int scaleFactor : config.scaleFactor ? config.scaleFactor : 1

  signal pressed()
  signal released()
  signal clicked()

  Row {
    x : 4
    y : 4

    spacing : 8 * scaleFactor

    Rectangle {
      id  : sp_button_bg

      width   : 40 * scaleFactor
      height  : 40 * scaleFactor

      radius  : 20 * scaleFactor

      color   : iconColor

      Image {
        id  : sp_button_icon

        width   : 40 * scaleFactor
        height  : 40 * scaleFactor

        source  : "./blank.svg"

        fillMode            : Image.Stretch
        horizontalAlignment : Image.AlignHCenter
        verticalAlignment   : Image.AlignVCenter
      }
    }

    Text {
      id  : sp_button_label

      height  : 40 * scaleFactor

      text    : ""
      color   : labelColor

      font.pixelSize  : 24 * scaleFactor
      font.weight     : Font.DemiBold

      fontSizeMode        : Text.VerticalFit
      horizontalAlignment : Text.AlignRight
      verticalAlignment   : Text.AlignVCenter
    }
  }


  //
  // States and associated visual attributes
  //
  states: [
    State {
      name  : "disabled"
      when  : (sp_button.enabled === false)

      PropertyChanges {
        target  : sp_button_bg
        color   : disableColor
      }

      PropertyChanges {
        target  : sp_button_label
        color   : disableColor
      }

    },
    State {
      name  : "hover"

      PropertyChanges {
        target  : sp_button_label
        color   : hoverLabelColor
      }

      PropertyChanges {
        target  : sp_button_bg
        color   : hoverIconColor
      }
    },
    State {
      name  : "pressed"

      PropertyChanges {
        target  : sp_button_label
        color   : hoverLabelColor
      }

      PropertyChanges {
        target  : sp_button_bg
        color   : pressIconColor
      }
    }
  ]

  //
  // Behavior on state transitions
  //
  transitions: [
    Transition {
      from  : ""
      to    : "hover"

      ColorAnimation {
        duration: 250
      }
    },
    Transition {
      from  : ""
      to    : "pressed"

      ColorAnimation {
        duration: 25
      }
    },
    Transition {
      from  : "disabled"
      to    : "enabled"

      ColorAnimation {
        duration: 50
      }
    },
    Transition {
      from  : "enabled"
      to    : "disabled"

      ColorAnimation {
        duration: 50
      }
    }
  ]

  //
  // Area to react to mouse actions
  //
  MouseArea {
    anchors.fill    : sp_button

    hoverEnabled    : true
    cursorShape     : Qt.PointingHandCursor
    acceptedButtons : Qt.LeftButton

    onEntered : {
      sp_button.state = "hover"
    }

    onExited  : {
      sp_button.state = ""
    }

    onPressed  : {
      sp_button.state = "pressed"
    }

    onClicked  : {
      sp_button.clicked()
    }

    onReleased  : {
      if (containsMouse) {
        sp_button.state = "hover"
      } else {
        sp_button.state = ""
      }
    }
  }
}
