import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import QtQml 2.3

Button
{
    id: btnTopBar

    property url btnIconSource: "../../images/svg_img/close_icon.svg"
    property color btnColorDefault: "#33353535"
    property color btnColorMouseOver: "#3323272e"
    property color btnColorClicked: "#878787"

    QtObject{
        id: internal

        property var dynamicColor: if(btnTopBar.down){
                                       btnTopBar.down ? btnColorClicked : btnColorDefault
                                   } else {
                                       btnTopBar.hovered ? btnColorMouseOver : btnColorDefault
                                   }

    }




    implicitWidth: 32
    implicitHeight: 32


    background: Rectangle
    {
        id:bgBtn
        color:internal.dynamicColor

        Image {
            id: iconcanel
            source: btnIconSource
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            height: 16
            width: 16
            visible: false
            antialiasing: false
            fillMode: Image.PreserveAspectFit

        }

        ColorOverlay
        {
            anchors.fill:iconcanel
            source:iconcanel
            color:"#bdbdbd"
            antialiasing: false

        }
    }

}
