import QtQuick 2.4
import QtQuick.Controls 1.3

import DICE.App 1.0

QtObject {
    id: root

    property var view
    property Component defaultNavi: Navi {}
    property Component defaultVis: Vis {}
    property Component defaultToolbar: ToolBarMenu {}
    property Component defaultActions: Actions {}
    property Component defaultNaviHeader: NaviHeader {}
    property Component defaultMainHeader: MainHeader {}
    property Menu defaultMainHeaderMenu: MainHeaderMenu {}
    property Component defaultVisHeader: VisHeader {}

    Component.onCompleted: {
        if (root.view.app) {
            loadNaviHeader()
            loadNavi()
            loadToolbar()
            loadMainHeader()
            loadMainHeaderMenu()
            loadVis()
            loadVisHeader()
            loadActions()
        }
    }

    function loadNaviHeader() {
        if (!!root.view.naviHeader) return
        var naviHeaderFile = root.view.app.getNaviHeaderFile()
        if (naviHeaderFile) {
            // load component from file
            var component = Qt.createComponent(naviHeaderFile)
            if (component.status === Component.Error)
                console.log("Error loading naviHeader:", component.errorString());
            component.createObject(root.view)
        } else {
            root.view.naviHeader = defaultNaviHeader
        }
    }

    function loadNavi() {
        if (!!root.view.navi) return
        var naviFile = root.view.app.getNaviFile()
        if (naviFile) {
            // load component from file
            var component = Qt.createComponent(naviFile)
            if (component.status === Component.Error)
                console.log("Error loading navi:", component.errorString());
            component.createObject(root.view)
        } else {
            // generate component from navi model using default Navi component
            root.view.navi = defaultNavi
            var naviModel = root.view.app.getNaviModel()
            root.view.naviObject.model.clear()
            root.view.naviObject.model.append(naviModel)
        }
    }

    function loadToolbar() {
        if (!!root.view.toolBar) return
        var tbFile = root.view.app.getToolBarFile()
        if (tbFile) {
            var component = Qt.createComponent(tbFile)
            if (component.status === Component.Error)
                console.log("Error loading toolBar:", component.errorString());
            root.view.toolBar = component
        } else {
            // load default/empty toolbar ?
            root.view.toolBar = defaultToolbar
        }
    }

    function loadMainHeader() {
        if (!!root.view.mainHeader) return
        var mainHeaderFile = root.view.app.getMainHeaderFile()
        if (mainHeaderFile) {
            // load component from file
            var component = Qt.createComponent(mainHeaderFile)
            if (component.status === Component.Error)
                console.log("Error loading mainHeader:", component.errorString());
            component.createObject(root.view)
        } else {
            root.view.mainHeader = defaultMainHeader
        }
    }

    function loadMainHeaderMenu() {
        if (!!root.view.mainHeaderMenu) return
        var mainHeaderMenuFile = root.view.app.getMainHeaderMenuFile()
        if (mainHeaderMenuFile) {
            // load component from file
            var component = Qt.createComponent(mainHeaderMenuFile)
            if (component.status === Component.Error)
                console.log("Error loading mainHeaderMenu:", component.errorString());
            component.createObject(root.view)
        } else {
            root.view.mainHeaderMenu = defaultMainHeaderMenu
        }
    }

    function loadVis() {
        if (!!root.view.vis) return
        var visFile = app.getVisFile()
        if (visFile) {
            root.view.vis = Qt.createComponent(visFile)
            if (root.view.vis.status === Component.Error)
                console.log("Error loading vis: "+root.view.vis.errorString())
        } else {
            root.view.vis = defaultVis
        }
    }

    function loadVisHeader() {
        if (!!root.view.visHeader) return
        var visHeaderFile = app.getVisHeaderFile()
        if (visHeaderFile) {
            root.view.visHeader = Qt.createComponent(visHeaderFile)
            if (root.view.visHeader.status === Component.Error)
                console.log("Error loading visHeader: "+root.view.visHeader.errorString())
        } else {
            root.view.visHeader = defaultVisHeader
        }
    }

    function loadActions() {
        if (!!root.view.actions) return
        var actionsFile = app.getActionsFile()
        if (actionsFile) {
            var component = Qt.createComponent(actionsFile)
            if (component.status === Component.Error)
                console.log("Error loading actions:", component.errorString());
            else
                root.view.actions = component.createObject(root.view)
        } else {
            root.view.actions = defaultActions.createObject(root.view)
        }
        console.log("ACTIONS: "+actionsFile+" .. "+root.view.actions)
    }
}
