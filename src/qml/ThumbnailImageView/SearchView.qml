import QtQuick 2.11
import QtQuick.Window 2.11
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.4
import QtQuick.Dialogs 1.3
import org.deepin.dtk 1.0
import "../Control"
import "../Control/ListView"

Rectangle {
    width: parent.width
    height: parent.height

    property string currentKeyword: ""
    property int searchResultCount: 0
    property var searchResults: new Array

    function searchFromKeyword(UID, keyword) {
        //1.调起C++，执行搜索
        var searchResult = albumControl.searchPicFromAlbum(UID, keyword, false);

        //2.将结果刷入UI
        currentKeyword = keyword
        flushResultToView(searchResult)
    }

    function flushResultToView(searchResult) {
        if(searchResult.length > 0) {
            noResultView.visible = false
            resultView.visible = true
            theModel.clear()
            var haveVideo = false
            var havePicture = false
            for(var i = 0;i !== searchResult.length;++i) {
                theModel.append({url : searchResult[i], displayFlushHelper : 0})
                if(fileControl.isVideo(searchResult[i])) {
                    haveVideo = true
                } else {
                    havePicture = true
                }
            }
            searchResultCount = searchResult.length
            searchResults = searchResult
            sliderPlayButton.enabled = havePicture

            if(havePicture && !haveVideo) {
                if(searchResult.length === 1) {
                    searchResultLabel.text = qsTr("1 photo found")
                } else {
                    searchResultLabel.text = qsTr("%1 photos found").arg(searchResult.length)
                }
            } else if(haveVideo && !havePicture) {
                if(searchResult.length === 1) {
                    searchResultLabel.text = qsTr("1 video found")
                } else {
                    searchResultLabel.text = qsTr("%1 videos found").arg(searchResult.length)
                }
            } else {
                searchResultLabel.text = qsTr("%1 items found").arg(searchResult.length)
            }
        } else {
            noResultView.visible = true
            resultView.visible = false
        }
    }

    //搜索标题
    Label {
        id: searchTitle
        text: qsTr("Search results")
        anchors.top: parent.top
        anchors.left: parent.left
        font: DTK.fontManager.t3
        color: Qt.rgba(0,0,0)
    }

    //缩略图模型
    ListModel {
        id: theModel
    }

    //有结果展示
    Rectangle {
        id: resultView
        anchors.top: searchTitle.bottom
        anchors.left: searchTitle.left
        anchors.bottom: parent.bottom
        anchors.right: parent.right

        //幻灯片放映按钮
        RecommandButton {
            id: sliderPlayButton
            text: qsTr("Slide Show")
            icon {
                name:"Combined_Shape"
                width: 20
                height: 20
            }
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: 15

            onClicked: {
                stackControl.startMainSliderShow(searchResults, 0)
            }
        }

        //搜索结果label
        Label {
            id: searchResultLabel
            anchors.left: sliderPlayButton.right
            anchors.verticalCenter: sliderPlayButton.verticalCenter
            font: DTK.fontManager.t6
            anchors.leftMargin: 10
        }

        //缩略图视图
        ThumbnailListView {
            id: view
            thumbnailListModel : theModel
            anchors.left: parent.left
            anchors.top: sliderPlayButton.bottom
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.topMargin: 10
        }
    }

    //无结果展示
    Rectangle {
        id: noResultView
        anchors.top: searchTitle.bottom
        anchors.left: searchTitle.left
        anchors.bottom: parent.bottom
        anchors.right: parent.right

        Label {
            id: noResultText
            text: qsTr("No search results")
            font: DTK.fontManager.t3
            anchors.centerIn: parent
            color: Qt.rgba(85/255, 85/255, 85/255, 0.4)
        }
    }

    Component.onCompleted: {
        global.sigRunSearch.connect(searchFromKeyword)
    }
}
