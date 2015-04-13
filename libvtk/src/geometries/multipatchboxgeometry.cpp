#include "multipatchboxgeometry.h"

#include "vtkqfborenderer.h"

#include <cmath>

#include <QDebug>

#include <vtkPolyDataMapper.h>
#include <vtkProperty.h>
#include <vtkPlaneSource.h>

QStringList MultiPatchBoxGeometry::patchNames = {"min_X_Plane", "max_X_Plane", "min_Y_Plane", "max_Y_Plane", "min_Z_Plane", "max_Z_Plane"};

MultiPatchBoxGeometry::MultiPatchBoxGeometry(QObject *parent) :
    GeometryBase(parent)
{
}

QStringList MultiPatchBoxGeometry::actorPath(vtkActor *actor)
{
    return {};
}

void MultiPatchBoxGeometry::setMinX(double d)
{
    if (isnan(d)) return;

    vtkPlaneSource* minX = planes["min_X_Plane"];
    double* mxo = minX->GetOrigin();
    minX->SetOrigin(d, mxo[1], mxo[2]);
    double* mxp1 = minX->GetPoint1();
    minX->SetPoint1(d, mxp1[1], mxp1[2]);
    double* mxp2 = minX->GetPoint2();
    minX->SetPoint2(d, mxp2[1], mxp2[2]);
    minX->Update();

    vtkPlaneSource* minY = planes["min_Y_Plane"];
    double* myo = minY->GetOrigin();
    minY->SetOrigin(d, myo[1], myo[2]);
    double* myp2 = minY->GetPoint2();
    minY->SetPoint2(d, myp2[1], myp2[2]);
    minY->Update();

    vtkPlaneSource* maxY = planes["max_Y_Plane"];
    double* mxyo = maxY->GetOrigin();
    maxY->SetOrigin(d, mxyo[1], mxyo[2]);
    double* mxyp2 = maxY->GetPoint2();
    maxY->SetPoint2(d, mxyp2[1], mxyp2[2]);
    maxY->Update();

    vtkPlaneSource* minZ = planes["min_Z_Plane"];
    double* mzo = minZ->GetOrigin();
    minZ->SetOrigin(d, mzo[1], mzo[2]);
    double* mzp2 = minZ->GetPoint2();
    minZ->SetPoint2(d, mzp2[1], mzp2[2]);
    minZ->Update();

    vtkPlaneSource* maxZ = planes["max_Z_Plane"];
    double* mxzo = maxZ->GetOrigin();
    maxZ->SetOrigin(d, mxzo[1], mxzo[2]);
    double* mxzp2 = maxZ->GetPoint2();
    maxZ->SetPoint2(d, mxzp2[1], mxzp2[2]);
    maxZ->Update();

    renderer->needUpdate();
}

void MultiPatchBoxGeometry::setMaxX(double d)
{
    if (isnan(d)) return;

    vtkPlaneSource* maxX = planes["max_X_Plane"];
    double* mxo = maxX->GetOrigin();
    maxX->SetOrigin(d, mxo[1], mxo[2]);
    double* mxp1 = maxX->GetPoint1();
    maxX->SetPoint1(d, mxp1[1], mxp1[2]);
    double* mxp2 = maxX->GetPoint2();
    maxX->SetPoint2(d, mxp2[1], mxp2[2]);
    maxX->Update();

    vtkPlaneSource* minY = planes["min_Y_Plane"];
    double* myp1 = minY->GetPoint1();
    minY->SetPoint1(d, myp1[1], myp1[2]);
    minY->Update();

    vtkPlaneSource* maxY = planes["max_Y_Plane"];
    double* mxyp1 = maxY->GetPoint1();
    maxY->SetPoint1(d, mxyp1[1], mxyp1[2]);
    maxY->Update();

    vtkPlaneSource* minZ = planes["min_Z_Plane"];
    double* mzp1 = minZ->GetPoint1();
    minZ->SetPoint1(d, mzp1[1], mzp1[2]);
    minZ->Update();

    vtkPlaneSource* maxZ = planes["max_Z_Plane"];
    double* mxzp1 = maxZ->GetPoint1();
    maxZ->SetPoint1(d, mxzp1[1], mxzp1[2]);
    maxZ->Update();

    renderer->needUpdate();
}

void MultiPatchBoxGeometry::setMinY(double d)
{
    if (isnan(d)) return;

    vtkPlaneSource* minX = planes["min_X_Plane"];
    double* mxo = minX->GetOrigin();
    minX->SetOrigin(mxo[0], d, mxo[2]);
    double* mxp2 = minX->GetPoint2();
    minX->SetPoint2(mxp2[0], d, mxp2[2]);
    minX->Update();

    vtkPlaneSource* maxX = planes["max_X_Plane"];
    double* mxxo = maxX->GetOrigin();
    maxX->SetOrigin(mxxo[0], d, mxxo[2]);
    double* mxxp2 = maxX->GetPoint2();
    maxX->SetPoint2(mxxp2[0], d, mxxp2[2]);
    maxX->Update();

    vtkPlaneSource* minY = planes["min_Y_Plane"];
    double* myo = minY->GetOrigin();
    minY->SetOrigin(myo[0], d, myo[2]);
    double* myp1 = minY->GetPoint1();
    minY->SetPoint1(myp1[0], d, myp1[2]);
    double* myp2 = minY->GetPoint2();
    minY->SetPoint2(myp2[0], d, myp2[2]);
    minY->Update();

    vtkPlaneSource* minZ = planes["min_Z_Plane"];
    double* mzo = minZ->GetOrigin();
    minZ->SetOrigin(mzo[0], d, mzo[2]);
    double* mzp1 = minZ->GetPoint1();
    minZ->SetPoint1(mzp1[0], d, mzp1[2]);
    minZ->Update();

    vtkPlaneSource* maxZ = planes["max_Z_Plane"];
    double* mxzo = maxZ->GetOrigin();
    maxZ->SetOrigin(mxzo[0], d, mxzo[2]);
    double* mxzp1 = maxZ->GetPoint1();
    maxZ->SetPoint1(mxzp1[0], d, mxzp1[2]);
    maxZ->Update();

    renderer->needUpdate();
}

void MultiPatchBoxGeometry::setMaxY(double d)
{
    if (isnan(d)) return;

    vtkPlaneSource* minX = planes["min_X_Plane"];
    double* mxp1 = minX->GetPoint1();
    minX->SetPoint1(mxp1[0], d, mxp1[2]);
    minX->Update();

    vtkPlaneSource* maxX = planes["max_X_Plane"];
    double* mxxp1 = maxX->GetPoint1();
    maxX->SetPoint1(mxxp1[0], d, mxxp1[2]);
    maxX->Update();

    vtkPlaneSource* maxY = planes["max_Y_Plane"];
    double* myo = maxY->GetOrigin();
    maxY->SetOrigin(myo[0], d, myo[2]);
    double* myp1 = maxY->GetPoint1();
    maxY->SetPoint1(myp1[0], d, myp1[2]);
    double* myp2 = maxY->GetPoint2();
    maxY->SetPoint2(myp2[0], d, myp2[2]);
    maxY->Update();

    vtkPlaneSource* minZ = planes["min_Z_Plane"];
    double* mzp2 = minZ->GetPoint2();
    minZ->SetPoint2(mzp2[0], d, mzp2[2]);
    minZ->Update();

    vtkPlaneSource* maxZ = planes["max_Z_Plane"];
    double* mxzp2 = maxZ->GetPoint2();
    maxZ->SetPoint2(mxzp2[0], d, mxzp2[2]);
    maxZ->Update();

    renderer->needUpdate();
}

void MultiPatchBoxGeometry::setMinZ(double d)
{
    if (isnan(d)) return;

    vtkPlaneSource* minX = planes["min_X_Plane"];
    double* mxo = minX->GetOrigin();
    minX->SetOrigin(mxo[0], mxo[1], d);
    double* mxp1 = minX->GetPoint1();
    minX->SetPoint1(mxp1[0], mxp1[1], d);
    minX->Update();

    vtkPlaneSource* maxX = planes["max_X_Plane"];
    double* mxxo = maxX->GetOrigin();
    maxX->SetOrigin(mxxo[0], mxxo[1], d);
    double* mxxp1 = maxX->GetPoint1();
    maxX->SetPoint1(mxxp1[0], mxxp1[1], d);
    maxX->Update();

    vtkPlaneSource* minY = planes["min_Y_Plane"];
    double* myo = minY->GetOrigin();
    minY->SetOrigin(myo[0], myo[1], d);
    double* myp1 = minY->GetPoint1();
    minY->SetPoint1(myp1[0], myp1[1], d);
    minY->Update();

    vtkPlaneSource* maxY = planes["max_Y_Plane"];
    double* mxyo = maxY->GetOrigin();
    maxY->SetOrigin(mxyo[0], mxyo[1], d);
    double* mxyp1 = maxY->GetPoint1();
    maxY->SetPoint1(mxyp1[0], mxyp1[1], d);
    maxY->Update();

    vtkPlaneSource* minZ = planes["min_Z_Plane"];
    double* mzo = minZ->GetOrigin();
    minZ->SetOrigin(mzo[0], mzo[1], d);
    double* mzp1 = minZ->GetPoint1();
    minZ->SetPoint1(mzp1[0], mzp1[1], d);
    double* mzp2 = minZ->GetPoint2();
    minZ->SetPoint2(mzp2[0], mzp2[1], d);
    minZ->Update();

    renderer->needUpdate();
}

void MultiPatchBoxGeometry::setMaxZ(double d)
{
    if (isnan(d)) return;

    vtkPlaneSource* minX = planes["min_X_Plane"];
    double* mxp2 = minX->GetPoint2();
    minX->SetPoint2(mxp2[0], mxp2[1], d);
    minX->Update();

    vtkPlaneSource* maxX = planes["max_X_Plane"];
    double* mxxp2 = maxX->GetPoint2();
    maxX->SetPoint2(mxxp2[0], mxxp2[1], d);
    maxX->Update();

    vtkPlaneSource* minY = planes["min_Y_Plane"];
    double* myp2 = minY->GetPoint2();
    minY->SetPoint2(myp2[0], myp2[1], d);
    minY->Update();

    vtkPlaneSource* maxY = planes["max_Y_Plane"];
    double* mxyp2 = maxY->GetPoint2();
    maxY->SetPoint2(mxyp2[0], mxyp2[1], d);
    maxY->Update();

    vtkPlaneSource* maxZ = planes["max_Z_Plane"];
    double* mzo = maxZ->GetOrigin();
    maxZ->SetOrigin(mzo[0], mzo[1], d);
    double* mzp1 = maxZ->GetPoint1();
    maxZ->SetPoint1(mzp1[0], mzp1[1], d);
    double* mzp2 = maxZ->GetPoint2();
    maxZ->SetPoint2(mzp2[0], mzp2[1], d);
    maxZ->Update();

    renderer->needUpdate();
}

void MultiPatchBoxGeometry::setVisible(bool visible)
{
    this->visible = visible;
    for (vtkActor* actor: m_actors.values())
        actor->SetVisibility(visible);
    renderer->needUpdate();
}

void MultiPatchBoxGeometry::setResolutionX(int res)
{
    for (QString name: {"min_Y_Plane", "max_Y_Plane", "min_Z_Plane", "max_Z_Plane"}) {
        if (planes.contains(name)) {
            int x, y;
            planes[name]->GetResolution(x, y);
            planes[name]->SetResolution(res, y);
            planes[name]->Update();
        }
    }
    renderer->needUpdate();
}

void MultiPatchBoxGeometry::setResolutionY(int res)
{
    for (QString name: {"min_X_Plane", "max_X_Plane"}) {
        if (planes.contains(name)) {
            int x, y;
            planes[name]->GetResolution(x, y);
            planes[name]->SetResolution(res, y);
            planes[name]->Update();
        }
    }
    for (QString name: {"min_Z_Plane", "max_Z_Plane"}) {
        if (planes.contains(name)) {
            int x, y;
            planes[name]->GetResolution(x, y);
            planes[name]->SetResolution(x, res);
            planes[name]->Update();
        }
    }
    renderer->needUpdate();
}

void MultiPatchBoxGeometry::setResolutionZ(int res)
{
    for (QString name: {"min_X_Plane", "max_X_Plane", "min_Y_Plane", "max_Y_Plane"}) {
        if (planes.contains(name)) {
            int x, y;
            planes[name]->GetResolution(x, y);
            planes[name]->SetResolution(x, res);
            planes[name]->Update();
        }
    }
    renderer->needUpdate();
}

vtkActor *MultiPatchBoxGeometry::makeActor(QString patchName)
{
    vtkPlaneSource* plane = vtkPlaneSource::New();
    if (patchName == "min_X_Plane") {
        plane->SetOrigin(-1, -1, -1);
        plane->SetPoint1(-1, 1, -1);
        plane->SetPoint2(-1, -1, 1);
    } else if (patchName == "max_X_Plane") {
        plane->SetOrigin(1, -1, -1);
        plane->SetPoint1(1, 1, -1);
        plane->SetPoint2(1, -1, 1);
    } else if (patchName == "min_Y_Plane") {
        plane->SetOrigin(-1, -1, -1);
        plane->SetPoint1(1, -1, -1);
        plane->SetPoint2(-1, -1, 1);
    } else if (patchName == "max_Y_Plane") {
        plane->SetOrigin(-1, 1, -1);
        plane->SetPoint1(1, 1, -1);
        plane->SetPoint2(-1, 1, 1);
    } else if (patchName == "min_Z_Plane") {
        plane->SetOrigin(-1, -1, -1);
        plane->SetPoint1(1, -1, -1);
        plane->SetPoint2(-1, 1, -1);
    } else if (patchName == "max_Z_Plane") {
        plane->SetOrigin(-1, -1, 1);
        plane->SetPoint1(1, -1, 1);
        plane->SetPoint2(-1, 1, 1);
    } else {
        // something strange, should never occure here
        Q_ASSERT(false);
    }
    planes[patchName] = plane;
    plane->SetResolution(1, 1);

    vtkPolyDataMapper* mapper = vtkPolyDataMapper::New();
    mapper->SetInputConnection(plane->GetOutputPort());

    vtkActor* actor = vtkActor::New();
    actor->SetMapper(mapper);
    actor->GetProperty()->SetColor(0, 0, 0.6);
    actor->GetProperty()->SetOpacity(0.5);

    actor->GetProperty()->EdgeVisibilityOn();
    actor->GetProperty()->SetEdgeColor(1, 1, 1);
    return actor;
}

void MultiPatchBoxGeometry::createActors()
{
    for (QString patchName: patchNames) {
        vtkActor* actor = makeActor(patchName);
        m_actors[patchName] = actor;
    }
}

