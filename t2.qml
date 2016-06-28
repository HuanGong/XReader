import QtQuick 2.7

Rectangle{
    width:300; height:300; color: "pink"
    Flipable{
        id:flipable
        anchors.fill:parent
        //width:back.width; height:back.height
        property int angle : 0  //翻转角度
        property bool flipped : false //用来标志是否翻转
        front: Rectangle {
		            id: front2;
                width: flipable.width; height: flipable.height;
                color: "red"
              }//Rectangle {source:”front.png”}  //指定前面的图片
        back: Rectangle {
		            id: back2;
                width: flipable.width; height: flipable.height;
                //width: 300; height: 250;
                color: "green"
              }//Image {source:”back.png”}    //指定背面的图片
        transform:Rotation { //指定原点
            origin.x:flipable.width/2; origin.y:flipable.height/2
            axis.x:0; axis.y:1; axis.z:0 //指定按y轴旋转
            angle:flipable.angle
        }
        states:State{
            name:"back"  //背面的状态
            PropertyChanges {target:flipable; angle:180}
            when:flipable.flipped
        }
        transitions: Transition {
            NumberAnimation{property:"angle";duration:1000}
            PropertyAnimation{
              property: "scale"; from:1.0 ;to: 0.75; duration:1000
            }
        }
        MouseArea{
            anchors.fill:parent
            onClicked:flipable.flipped =!flipable.flipped
            //当鼠标按下时翻转
        }
    }
}
