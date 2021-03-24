import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import "controls"
import QtQml 2.3

import QtGraphicalEffects 1.15
import QtQuick.Layouts 1.11

Window {
    id: mainWindow
    width: 900
    height: 500
    visible: true
    color: "#00000000"
    property alias lyricslabelFontfamily: lyricslabel.font.family
    property alias minimizeBtn: minimizeBtn
    property alias cancelButton: cancelBtn
    title: qsTr("Lyrics")

    flags: Qt.Window | Qt.FramelessWindowHint

    FontLoader{id:custom_font;source:"../fonts/Courgette-Regular.ttf"}

    property int windowStateChanged: 0
    property color dark: "#33ffffff"
    property color light: "#33353535"
    property color icon_color: "#bdbdbd"
    property color  text_white: "#ffffff"
    property color text_black: "#1a1a1a"

    Rectangle {
        id: bg
        width: 860
        height: 460
        opacity: 1
        color: "#1a272727"
        radius: 5
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.rightMargin: 10
        anchors.leftMargin: 10
        anchors.bottomMargin: 10
        anchors.topMargin: 10
        z:1
        Rectangle {

            QtObject{
                id:internal
                property var dynamicColorbg: control.checked ? dark : light
                property var dynamictextcolor: control.checked? text_black:text_white

            }

            id: appContainer
            width: 860
            height: 460
            color: internal.dynamicColorbg
            radius: 5
            anchors.fill: parent
            anchors.rightMargin: 1
            anchors.leftMargin: 1
            anchors.bottomMargin: 1
            anchors.topMargin: 1

            Rectangle {
                id: topBar
                height: 32
                color: "#33353535"
                radius: 1
                border.color: "#242424"
                border.width: 0
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.leftMargin: 0
                anchors.rightMargin: 0
                anchors.topMargin: 0

                DragHandler{
                    onActiveChanged: if(active)
                                     {
                                         mainWindow.startSystemMove()
                                     }
                }





                Label {
                    id: labelname
                    x: 314
                    y: 10
                    width: 227
                    height: 17
                    color: "#ffffff"
                    text: "Song's Name"
                    horizontalAlignment: Text.AlignHCenter
                    font.pointSize: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Row {
                    id: leftRow
                    x: 0
                    width: 134
                    height: 32
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.rightMargin: 744
                    topPadding: 0
                    anchors.topMargin: 0
                    CancelButton {
                        id: minimizeBtn1
                        x: 0
                        y: 0
                        width: 32
                        height: 32
                        btnColorDefault: "#00000000"
                        btnIconSource: "../images/svg_img/20543871991530177260.svg"
                        onClicked: mainWindow.showMinimized()
                    }

                    Rectangle {
                        id: imageHolder
                        y: 0
                        width: 32
                        height: 32
                        color: "#00000000"

                        Image {
                            id: imagemoon
                            x: 8
                            y: 8
                            width: 16
                            height: 16
                            source: "../images/svg_img/moon.svg"
                            fillMode: Image.PreserveAspectFit


                            ColorOverlay
                            {
                                y: 0
                                anchors.fill: imagemoon
                                source: imagemoon
                                color: icon_color
                                antialiasing: false
                            }



                        }
                    }

                    Switch {
                        id: control
                        x: 0
                        y: 0
                        width: 38
                        height: 32
                        text: qsTr("Switch")

                        indicator: Rectangle {
                            x: 0
                            y: 8
                            implicitWidth: 36

                            implicitHeight: 18
                            radius: 13
                            color: control.checked ? "#17a81a" : "#ffffff"
                            border.color: control.checked ? "#17a81a" : "#cccccc"

                            Rectangle {
                                x: control.checked ? parent.width - width : 0
                                width: 18
                                height: 18
                                radius: 13
                                color: control.down ? "#cccccc" : "#ffffff"
                                border.color: control.checked ? (control.down ? "#17a81a" : "#21be2b") : "#999999"
                            }
                        }
                    }

                    Rectangle {
                        id: imageHolder1
                        width: 32
                        height: 32
                        color: "#00000000"
                        Image {
                            id: imagesun
                            x: 8
                            y: 8
                            width: 16
                            height: 16
                            source: "../images/svg_img/sun_icon.svg"
                            fillMode: Image.PreserveAspectFit
                            ColorOverlay {
                                color: icon_color
                                anchors.fill: imagesun
                                source: imagesun
                                antialiasing: false
                            }
                        }
                    }

                    //                    Rectangle {
                    //                        id: moonbg
                    //                        width: 32
                    //                        height: 32
                    //                        color: "#ffffff"

                    //                        Image {
                    //                            id: image
                    //                            width: 32
                    //                            height: 32
                    //                            source: "qrc:/qtquickplugin/images/template_image.png"
                    //                            sourceSize.height: 300
                    //                            sourceSize.width: 300
                    //                            fillMode: Image.PreserveAspectFit
                    //                        }
                    //                    }
                }
            }

            Rectangle {
                id: scrollcontainer
                x: 8
                y: 38
                width: 862
                height: 432
                color: "#00000000"


                ScrollView {
                    id: scrollView
                    anchors.fill: parent

                    Label {
                        id: lyricslabel
                        color: internal.dynamictextcolor
                        text: qsTr("")
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignLeft
                        //                    horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignBottom
                        rightPadding: 10
                        bottomPadding: 10
                        leftPadding: 10
                        topPadding: 10
                        font.pointSize: 25
                        textFormat: Text.AutoText
                        font.family: custom_font.name
                        font.bold: false
                    }
                }
            }




        }

        Row {
            id: rightRow
            x: 683
            width: 64
            height: 32
            anchors.right: parent.right
            anchors.top: parent.top
            topPadding: 1
            anchors.rightMargin: 1
            anchors.topMargin: 0


            CancelButton{
                id: minimizeBtn
                btnColorDefault: "#00000000"
                btnIconSource: "../images/svg_img/minimize_icon.svg"
                onClicked: mainWindow.showMinimized()

            }

            CancelButton {
                id: cancelBtn
                btnColorDefault: "#00000000"
                btnIconSource: "../images/svg_img/close_icon.svg"
                onClicked: mainWindow.close()
            }

        }






    }


    DropShadow{
        anchors.fill: bg
        horizontalOffset: 0
        verticalOffset: 0
        radius:10
        samples:16
        color: "#80000000"
        source: bg
        z:0
    }

    Connections
    {
        target: backend

        function onPrintSing(name)
        {
            labelname.text= name
        }

        function onPrintLyrics(lyric)
        {

            lyricslabel.text= lyric
        }
    }


}


