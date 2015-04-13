# how to compile vtk 6.1:
# clone the following repository somewhere outside the repository:
#   git clone git://vtk.org/VTK.git
#   git clone git://vtk.org/VTK.git
# create a directory "build" inside VTK and "cd build"
# run "cmake .." inside build
# run "cmake-gui .." and check VTK_Group_Imaging, VTK_Group_MPI, VTK_Group_Qt, VTK_Group_Rendering, VTK_Group_StandAlone
# click on "Add Entry" and insert Name: VTK_QT_VERSION, Type: STRING, Value: 5; click OK
# if Qt5 is NOT installed in /usr/lib: Add Entry CMAKE_PREFIX_PATH as PATH to where Qt5 is installed
# click on "Configure", then "Generate" and close cmake-gui
# run make -j4 inside "build" and wait
# if finished w/o errors, run "sudo make install", which will install VTK 6.1 into /usr/local/lib

# configure your project:
# go to "Projects" in Qt Creator and to Build Settings of your current kit
# open "Details" of "Build Environment" and find the value "LD_LIBRARY_PATH"
# click on the value of LD_LIBRARY_PATH and then "Edit"
# append ":/usr/local/lib" to the vale (i.e. where VTK 6.1 is installed). it should look like this:
#   /some/other/paths:.:/usr/local/lib





VTK_VERSION = 6.1
INCLUDEPATH += /usr/local/include/vtk-$${VTK_VERSION}
LIBPATH += /usr/local/lib

# all vtk libraries as given by cmakes ${VTK_LIBRARIES}
LIBS += \
-lvtksys-$${VTK_VERSION} \
-lvtkCommonCore-$${VTK_VERSION} \
-lvtkCommonMath-$${VTK_VERSION} \
-lvtkCommonMisc-$${VTK_VERSION} \
-lvtkCommonSystem-$${VTK_VERSION} \
-lvtkCommonTransforms-$${VTK_VERSION} \
-lvtkCommonDataModel-$${VTK_VERSION} \
-lvtkCommonColor-$${VTK_VERSION} \
-lvtkCommonExecutionModel-$${VTK_VERSION} \
-lvtkFiltersCore-$${VTK_VERSION} \
-lvtkCommonComputationalGeometry-$${VTK_VERSION} \
-lvtkFiltersGeneral-$${VTK_VERSION} \
-lvtkImagingCore-$${VTK_VERSION} \
-lvtkImagingFourier-$${VTK_VERSION} \
-lvtkalglib-$${VTK_VERSION} \
-lvtkFiltersStatistics-$${VTK_VERSION} \
-lvtkFiltersExtraction-$${VTK_VERSION} \
-lvtkInfovisCore-$${VTK_VERSION} \
-lvtkFiltersGeometry-$${VTK_VERSION} \
-lvtkFiltersSources-$${VTK_VERSION} \
-lvtkRenderingCore-$${VTK_VERSION} \
-lvtkzlib-$${VTK_VERSION} \
-lvtkfreetype-$${VTK_VERSION} \
-lvtkftgl-$${VTK_VERSION} \
-lvtkverdict-$${VTK_VERSION} \
-lvtkRenderingFreeType-$${VTK_VERSION} \
-lvtkDICOMParser-$${VTK_VERSION} \
-lvtkIOCore-$${VTK_VERSION} \
-lvtkmetaio-$${VTK_VERSION} \
-lvtkjpeg-$${VTK_VERSION} \
-lvtkpng-$${VTK_VERSION} \
-lvtktiff-$${VTK_VERSION} \
-lvtkIOImage-$${VTK_VERSION} \
-lvtkImagingHybrid-$${VTK_VERSION} \
-lvtkRenderingOpenGL-$${VTK_VERSION} \
-lvtkRenderingContext2D-$${VTK_VERSION} \
-lvtkChartsCore-$${VTK_VERSION} \
-lvtkImagingColor-$${VTK_VERSION} \
-lvtkRenderingAnnotation-$${VTK_VERSION} \
-lvtkgl2ps-$${VTK_VERSION} \
-lvtkRenderingGL2PS-$${VTK_VERSION} \
-lvtkRenderingLabel-$${VTK_VERSION} \
-lvtkIOExport-$${VTK_VERSION} \
-lvtkIOLegacy-$${VTK_VERSION} \
-lvtklibxml2-$${VTK_VERSION} \
-lvtkIOInfovis-$${VTK_VERSION} \
-lvtkTestingRendering-$${VTK_VERSION} \
-lvtkImagingSources-$${VTK_VERSION} \
-lvtkFiltersHybrid-$${VTK_VERSION} \
-lvtkFiltersModeling-$${VTK_VERSION} \
-lvtkImagingGeneral-$${VTK_VERSION} \
-lvtkInteractionStyle-$${VTK_VERSION} \
-lvtkRenderingVolume-$${VTK_VERSION} \
-lvtkInteractionWidgets-$${VTK_VERSION} \
-lvtkViewsCore-$${VTK_VERSION} \
-lvtkViewsContext2D-$${VTK_VERSION} \
-lvtkjsoncpp-$${VTK_VERSION} \
-lvtkIOGeometry-$${VTK_VERSION} \
-lvtkexpat-$${VTK_VERSION} \
-lvtkIOXMLParser-$${VTK_VERSION} \
-lvtkIOXML-$${VTK_VERSION} \
-lvtkDomainsChemistry-$${VTK_VERSION} \
-lvtkParallelCore-$${VTK_VERSION} \
-lvtkFiltersAMR-$${VTK_VERSION} \
-lvtkhdf5_hl-$${VTK_VERSION} \
-lvtkhdf5-$${VTK_VERSION} \
-lvtkIOAMR-$${VTK_VERSION} \
-lvtkFiltersFlowPaths-$${VTK_VERSION} \
-lvtkFiltersImaging-$${VTK_VERSION} \
-lvtkRenderingFreeTypeOpenGL-$${VTK_VERSION} \
-lvtkFiltersGeneric-$${VTK_VERSION} \
-lvtkTestingGenericBridge-$${VTK_VERSION} \
-lvtkFiltersHyperTree-$${VTK_VERSION} \
-lvtkFiltersParallel-$${VTK_VERSION} \
-lvtkParallelMPI-$${VTK_VERSION} \
-lvtkFiltersParallelGeometry-$${VTK_VERSION} \
-lvtkNetCDF-$${VTK_VERSION} \
-lvtkNetCDF_cxx-$${VTK_VERSION} \
-lvtkIONetCDF-$${VTK_VERSION} \
-lvtkexoIIc-$${VTK_VERSION} \
-lvtkIOParallel-$${VTK_VERSION} \
-lvtkFiltersParallelImaging-$${VTK_VERSION} \
-lvtkFiltersParallelMPI-$${VTK_VERSION} \
-lvtkFiltersProgrammable-$${VTK_VERSION} \
-lvtkFiltersSMP-$${VTK_VERSION} \
-lvtkFiltersSelection-$${VTK_VERSION} \
-lvtkFiltersTexture-$${VTK_VERSION} \
-lvtkFiltersVerdict-$${VTK_VERSION} \
-lvtkGUISupportQt-$${VTK_VERSION} \
-lvtkGUISupportQtOpenGL-$${VTK_VERSION} \
-lvtksqlite-$${VTK_VERSION} \
-lvtkIOSQL-$${VTK_VERSION} \
-lvtkGUISupportQtSQL-$${VTK_VERSION} \
-lvtkInfovisLayout-$${VTK_VERSION} \
-lvtkViewsInfovis-$${VTK_VERSION} \
-lvtkViewsQt-$${VTK_VERSION} \
-lvtkGUISupportQtWebkit-$${VTK_VERSION} \
-lvtkproj4-$${VTK_VERSION} \
-lvtkGeovisCore-$${VTK_VERSION} \
-lvtkViewsGeovis-$${VTK_VERSION} \
-lvtkIOEnSight-$${VTK_VERSION} \
-lvtkIOExodus-$${VTK_VERSION} \
-lvtkInteractionImage-$${VTK_VERSION} \
-lvtkRenderingVolumeOpenGL-$${VTK_VERSION} \
-lvtkImagingMath-$${VTK_VERSION} \
-lvtkIOImport-$${VTK_VERSION} \
-lvtkIOLSDyna-$${VTK_VERSION} \
-lvtkIOMINC-$${VTK_VERSION} \
-lvtkIOMPIImage-$${VTK_VERSION} \
-lvtkIOMPIParallel-$${VTK_VERSION} \
-lvtkoggtheora-$${VTK_VERSION} \
-lvtkIOMovie-$${VTK_VERSION} \
-lvtkIOPLY-$${VTK_VERSION} \
-lvtkIOParallelNetCDF-$${VTK_VERSION} \
-lvtkTestingIOSQL-$${VTK_VERSION} \
-lvtkIOVideo-$${VTK_VERSION} \
-lvtkImagingStatistics-$${VTK_VERSION} \
-lvtkImagingStencil-$${VTK_VERSION} \
-lvtkRenderingImage-$${VTK_VERSION} \
-lvtkImagingMorphological-$${VTK_VERSION} \
-lvtkRenderingLOD-$${VTK_VERSION} \
-lvtkRenderingLIC-$${VTK_VERSION} \
-lvtkRenderingQt-$${VTK_VERSION} \
-lvtkRenderingVolumeAMR-$${VTK_VERSION}

