
.pragma library

function CreateQmlObjects(componentName, parent) {
    var component = Qt.createComponent(componentName);
    if (component.status === Component.Ready) {

    }
}


function finishCreation(component, parent) {
    var obj = null;
    if (component.status === Component.Ready) {
        obj = component.createObject(parent, {});
    } else if (component.status === Component.Error) {
        // Error Handling
        console.log("Error loading component:", component.errorString());
    }
}
