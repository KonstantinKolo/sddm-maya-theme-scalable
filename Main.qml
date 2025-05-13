//
// [maya] main.qml
//
// Main script for the SDDM theme
//
// (c) 2016 Sanjeev Premi (spremi@ymail.com)
//
// SPDX-License-Identifier: MIT
//                          (https://spdx.org/licenses/MIT.html)
//


import QtQuick 2.0
import SddmComponents 2.0

import "./components"

Rectangle {
  id  : maya_root

  property color primaryShade : config.primaryShade ? config.primaryShade : "#000000"
  property color primaryLight : config.primaryLight ? config.primaryLight : "#7986CB"
  property color primaryDark  : config.primaryDark  ? config.primaryDark  : "#000000"

  property color primaryHue1  : config.primaryHue1  ? config.primaryHue1  : "#FE0000"
  property color primaryHue2  : config.primaryHue2  ? config.primaryHue2  : "#D50808"
  property color primaryHue3  : config.primaryHue3  ? config.primaryHue3  : "#2b2b2b"
  property color primaryHue4  : config.primaryHue4  ? config.primaryHue4  : "#540000"

  property color accentShade  : config.accentShade  ? config.accentShade  : "#FE0000"
  property color accentDark  : config.accentDark  ? config.accentDark  : "#3c3c3c"
  property color accentLight  : config.accentLight  ? config.accentLight  : "#EE0852"
  property color accentLight2  : config.accentLight  ? config.accentLight  : "#b61c4e"

  property color accentHue1   : config.accentHue1   ? config.accentHue1   : "#FF669A"
  property color accentHue2   : config.accentHue2   ? config.accentHue2   : "#D50808"
  property color accentHue3   : config.accentHue3   ? config.accentHue3   : "#850303"

  property color normalText   : config.normalText   ? config.normalText   : "#FE0000"
  property color boxText : config.boxText ? config.boxText : "#000000"

  property color successText  : config.successText  ? config.successText  : "#40C408"
  property color failureText  : config.failureText  ? config.failureText  : "#850000"
  property color warningText  : config.warningText  ? config.warningText  : "#FF4400"

  property color rebootColor  : config.rebootColor  ? config.rebootColor  : "#FE0000"
  property color powerColor   : config.powerColor   ? config.powerColor   : "#FE0000"

  readonly property color defaultBg : primaryShade ? primaryShade : "#000000"

  //
  // Scale factor for screens that use 2x scale eg. some laptops
  //
  readonly property int scaleFactor : config.scaleFactor ? config.scaleFactor : 1

  //
  // Indicates one unit of measure in pixels
  //
  readonly property int spUnit: 64 * scaleFactor

  //
  // Symmetric padding on all sides
  //
  readonly property int padSym : (spUnit / 8)

  //
  // Asymmetric padding in horizontal and vertical directions
  //
  readonly property int padAsymH : (spUnit / 2)
  readonly property int padAsymV : (spUnit / 8)

  //
  // Font sizes
  //
  readonly property int spFontNormal  : 24 * scaleFactor
  readonly property int spFontSmall   : 16 * scaleFactor


  LayoutMirroring.enabled: Qt.locale().textDirection == Qt.RightToLeft
  LayoutMirroring.childrenInherit: true

  TextConstants { id: textConstants }

  Connections {
    target: sddm

    onLoginSucceeded: {
      prompt_bg.color = successText
      prompt_txt.text = textConstants.loginSucceeded

      maya_busy.visible = false;
      maya_busy_anim.stop()

      anim_success.start()
    }
    onLoginFailed: {
      prompt_bg.color = failureText
      prompt_txt.text = textConstants.loginFailed

      maya_busy.visible = false;
      maya_busy_anim.stop()

      anim_failure.start()
    }
    onInformationMessage: {
      prompt_bg.color = failureText
      prompt_txt.text = message

      maya_busy.visible = false;
      maya_busy_anim.stop()

      anim_failure.start()
    }
  }


  signal tryLogin()

  onTryLogin : {
    maya_busy.visible = true;
    maya_busy_anim.start()

    sddm.login(maya_username.text, maya_password.text, maya_session.index);
  }


  FontLoader {
    id: opensans_cond_light
    source: "fonts/OpenSans_CondLight.ttf"
  }

  Repeater {
    model: screenModel

    Item {
      Rectangle {
        x       : geometry.x
        y       : geometry.y
        width   : geometry.width
        height  : geometry.height
        color   : defaultBg
      }
    }
  }

  //
  // Status bar on top
  //
  Rectangle {
    x       : 0
    y       : 0
    width   : parent.width
    height  : spUnit

    color   : primaryDark

    Row {
      x       : (parent.width  / 2) + padAsymH
      y       : padAsymV
      width   : ((parent.width  / 2) - (padAsymH * 2))
      height  : (parent.height - (padAsymV * 2))

      spacing : padAsymH

      layoutDirection : Qt.RightToLeft

      //
      // Current date & time
      //
      SpClock {
        height  : parent.height

        tColor  : normalText

        tFont.family    : opensans_cond_light.name
        tFont.pixelSize : spFontNormal
      }
    }
  }


  //
  // Header
  //
  Rectangle {
    x       : 0
    y       : spUnit
    width   : parent.width
    height  : spUnit

    color   : primaryShade

    Row {
      x       : padAsymH
      y       : padAsymV
      width   : (parent.width  - (padAsymH * 2))
      height  : (parent.height - (padAsymV * 2))

      //
      // Welcome Text
      //
      Text {
        id      : maya_welcome

        width   : parent.width
        height  : parent.height

        text    : textConstants.welcomeText.arg("ArchLinux")
        color   : normalText

        font.family         : opensans_cond_light.name
        font.pixelSize      : spFontNormal

        fontSizeMode        : Text.VerticalFit
        horizontalAlignment : Text.AlignLeft
        verticalAlignment   : Text.AlignVCenter
      }
    }
  }

  //
  // Toolbar
  //
  Rectangle {
    x       : 0
    y       : (spUnit * 2)
    width   : parent.width
    height  : spUnit

    color   : primaryShade

    Row {
      x       : (parent.width  / 2) + padAsymH
      y       : padAsymV
      width   : ((parent.width  / 2) - (padAsymH * 2))
      height  : (parent.height - (padAsymV * 2))

      spacing : padAsymH 

      layoutDirection : Qt.RightToLeft

      //
      // Layout selection
      //
      LayoutBoxCustom {
        id      : maya_layout

        width   : spUnit * 2 
        height  : parent.height

        color       : primaryHue1
        borderColor : primaryHue4
        focusColor  : primaryHue2
        hoverColor  : primaryHue2
        textColor   : boxText
        menuColor   : primaryHue1

        font.family     : opensans_cond_light.name
        font.pixelSize  : spFontNormal

        arrowIcon: "images/ic_arrow_drop_down_white_24px.svg"
        arrowColor: primaryHue3

        KeyNavigation.tab     : maya_username
        KeyNavigation.backtab : maya_session

        Image {
          fillMode : Image.Stretch
        }
      }

      Text {
        height  : parent.height

        text    : textConstants.layout

        color   : boxText

        font.family     : opensans_cond_light.name
        font.pixelSize  : spFontNormal

        horizontalAlignment : Text.AlignLeft
        verticalAlignment   : Text.AlignVCenter
      }

      //
      // Session selection
      //
      ComboBox {
        id      : maya_session

        model   : sessionModel
        index   : sessionModel.lastIndex

        width   : spUnit * 3
        height  : parent.height

        color       : primaryHue1
        borderColor : primaryHue4
        focusColor  : primaryHue2
        hoverColor  : primaryHue2
        textColor   : boxText
        menuColor   : primaryHue1

        font.family     : opensans_cond_light.name
        font.pixelSize  : spFontNormal

        arrowIcon: "images/ic_arrow_drop_down_white_24px.svg"
        arrowColor: primaryHue3

        KeyNavigation.tab     : maya_layout
        KeyNavigation.backtab : maya_shutdown
      }

      Text {
        height  : parent.height

        text    : textConstants.session

        color   : boxText

        font.family     : opensans_cond_light.name
        font.pixelSize  : spFontNormal

        horizontalAlignment : Text.AlignLeft
        verticalAlignment   : Text.AlignVCenter
      }
    }
  }

  //
  // Footer
  //
  Rectangle {
    x       : 0
    y       : (parent.height - spUnit)
    width   : parent.width 
    height  : spUnit 

    color   : primaryHue3

    Row {
      x : padAsymH;
      y : padAsymV;

      width   : (parent.width  - (padAsymH * 2))
      height  : (parent.height - (padAsymV * 2))

      spacing: padAsymH

      layoutDirection : Qt.RightToLeft

      //
      // Shutdown button
      //
      SpButton {
        id      : maya_shutdown

        height  : parent.height 
        width   : (spUnit * 4) 

        font.family : opensans_cond_light.name
        font.pixelSize : spFontNormal

        label       : textConstants.shutdown
        labelColor  : normalText

        icon        : "images/ic_power_settings_new_white_24px.svg"

        iconColor   : accentShade

        hoverIconColor  : primaryHue4
        hoverLabelColor : accentShade

        KeyNavigation.tab     : maya_session
        KeyNavigation.backtab : maya_reboot

        onClicked: sddm.powerOff()
      }

      //
      // Reboot button
      //
      SpButton {
        id      : maya_reboot

        height  : parent.height
        width   : (spUnit * 4)

        font.family : opensans_cond_light.name

        label       : textConstants.reboot
        labelColor  : normalText

        icon        : "images/ic_refresh_white_24px.svg"
        iconColor   : accentLight

        hoverIconColor  : accentLight2
        hoverLabelColor : accentLight2

        KeyNavigation.tab     : maya_shutdown
        KeyNavigation.backtab : maya_login

        onClicked: sddm.reboot()
      }
    }
  }

  //
  // Login container
  //
  Rectangle {
    x       : (parent.width  - (6 * spUnit)) / 2
    y       : (parent.height - (5 * spUnit)) / 2
    width   : (6 * spUnit)
    height  : (5 * spUnit)

    color   : primaryHue3

    Row {
      x       : padSym
      y       : padSym
      width   : (parent.width - (padSym * 2))
      height  : (spUnit - (padSym * 2))

      Text {
        width   : parent.width
        height  : parent.height

        text    : textConstants.userName
        color   : normalText

        font.family     : opensans_cond_light.name
        font.pixelSize  : spFontNormal

        horizontalAlignment : Text.AlignLeft
        verticalAlignment   : Text.AlignBottom
      }
    }

    Row {
      x       : padSym
      y       : spUnit + padSym
      width   : (parent.width - (padSym * 2))
      height  : (spUnit - (padSym * 2))

      TextBox {
        id      : maya_username

        width   : parent.width
        height  : parent.height

        color       : accentHue3
        borderColor : primaryHue4
        focusColor  : accentLight
        hoverColor  : accentLight
        textColor   : normalText

        font.family     : opensans_cond_light.name
        font.pixelSize  : spFontNormal

        KeyNavigation.tab     : maya_password
        KeyNavigation.backtab : maya_layout
      }
    }

    Row {
      x       : padSym
      y       : (2 * spUnit) + padSym
      width   : (parent.width - (padSym * 2))
      height  : (spUnit - (padSym * 2))

      Text {
        width   : parent.width
        height  : parent.height

        text    : textConstants.password
        color   : normalText

        font.family     : opensans_cond_light.name
        font.pixelSize  : spFontNormal

        horizontalAlignment : Text.AlignLeft
        verticalAlignment   : Text.AlignBottom
      }
    }

    Row {
      x       : padSym
      y       : (3 * spUnit) + padSym
      width   : (parent.width - (padSym * 2))
      height  : (spUnit - (padSym * 2))

      PasswordBox {
        id      : maya_password

        width   : parent.width
        height  : parent.height

        color       : accentHue3
        borderColor : primaryHue4
        focusColor  : accentLight
        hoverColor  : accentLight
        textColor   : normalText

        image       : "images/ic_warning_white_24px.svg"

        tooltipEnabled  : true
        tooltipText     : textConstants.capslockWarning
        tooltipFG       : normalText
        tooltipBG       : primaryHue3

        font.family     : opensans_cond_light.name
        font.pixelSize  : spFontSmall

        KeyNavigation.tab     : maya_login
        KeyNavigation.backtab : maya_username

        Keys.onPressed: {
          if ((event.key === Qt.Key_Return) || (event.key === Qt.Key_Enter)) {
            maya_root.tryLogin()

            event.accepted = true;
          }
        }
      }
    }

    Row {
      x       : padSym
      y       : (4 * spUnit) + padSym
      width   : (parent.width - (padSym * 2))
      height  : (spUnit - (padSym * 2))

      Button {
        id      : maya_login

        width   : parent.width
        height  : parent.height

        text    : textConstants.login

        color         : primaryDark
        textColor     : normalText

        borderColor   : primaryHue1

        pressedColor  : accentDark
        activeColor   : accentDark

        font.family     : opensans_cond_light.name
        font.pixelSize  : spFontNormal
        font.weight     : Font.DemiBold

        KeyNavigation.tab     : maya_reboot
        KeyNavigation.backtab : maya_layout

        onClicked: maya_root.tryLogin()

        Keys.onPressed: {
          if ((event.key === Qt.Key_Return) || (event.key === Qt.Key_Enter)) {
            maya_root.tryLogin()

            event.accepted = true;
          }
        }
      }
    }
  }

  //
  // Busy animation (just above footer)
  //
  Rectangle {
    id      : maya_busy

    x       : (parent.width  - (6 * spUnit)) / 2
    y       : (parent.height - (1.5 * spUnit))
    width   : (6 * spUnit)
    height  : (spUnit / 4)

    visible : false

    color   : "transparent"

    border.color  : accentHue1
    border.width  : 1

    Rectangle {
      id      : maya_busy_indicator

      x       : 0
      y       : 0
      width   : (spUnit / 4)
      height  : parent.height

      color   : accentHue3
    }

    SequentialAnimation {
      id      : maya_busy_anim

      running : false
      loops   : Animation.Infinite

      NumberAnimation {
        target    : maya_busy_indicator
        property  : "x"
        from      : 0
        to        : (6 * spUnit) - (spUnit / 4)
        duration  : 2500
      }

      NumberAnimation {
        target    : maya_busy_indicator
        property  : "x"
        to        : 0
        duration  : 2500
      }
    }
  }

  //
  // Prompt container
  //
  Rectangle {
    id      : prompt_bg

    x       : (parent.width / 4)
    y       : (parent.height - (3 * spUnit))
    width   : (parent.width / 2)
    height  : spUnit

    color   : "transparent"

    Text {
      id      : prompt_txt

      x       : padSym
      y       : padSym
      width   : (parent.width  - (padSym * 2))
      height  : (parent.height - (padSym * 2))

      color   : normalText

      text    : textConstants.prompt

      font.pixelSize  : spFontNormal

      horizontalAlignment : Text.AlignHCenter
      verticalAlignment   : Text.AlignVCenter
    }

    SequentialAnimation on color {
      id      : anim_success
      running : false

      ColorAnimation {
        from: "transparent"
        to: successText
        duration: 250
      }
    }

    SequentialAnimation on color {
      id      : anim_failure
      running : false

      ColorAnimation {
        from: "transparent"
        to: failureText
        duration: 250
      }

      PauseAnimation {
        duration: 500
      }

      ColorAnimation {
        from: failureText
        to: "transparent"
        duration: 500
      }

      onStopped: {
        maya_password.text  = ""
        prompt_txt.text     = textConstants.prompt
      }
    }
  }


  Component.onCompleted: {
    if (maya_username.text === "")
      maya_username.focus = true
    else
      maya_password.focus = true
  }
}
