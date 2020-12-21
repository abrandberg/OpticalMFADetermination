function out = model
%
% linearOpticsTutorial.m
%
% Model exported on Dec 9 2020, 23:52 by COMSOL 5.6.0.280.

import com.comsol.model.*
import com.comsol.model.util.*

model = ModelUtil.create('Model');

model.modelPath('C:\Users\augus\Documents\softwareProjects\OpticalMFADetermination\comsolModel');

model.label('linearOpticsTutorial.mph');

model.param.set('aAngle', '0', 'Analyzer azimuth');
model.param.set('retAngle1', '17*pi/180', 'Fast axis, 2nd linear retarder');
model.param.set('wallTkn', '4e-6[m]', 'Fiber wall thickness');
model.param.set('wavelength', '500e-9[m]', 'wavelength');
model.param.set('fracPolar', '0', 'Fraction polar in');
model.param.set('pAngle', '45*pi/180');

model.component.create('comp1', true);

model.component('comp1').geom.create('geom1', 3);

model.component('comp1').curvedInterior(false);

model.result.table.create('tbl1', 'Table');
model.result.table.create('tbl2', 'Table');

model.component('comp1').mesh.create('mesh1');

model.component('comp1').geom('geom1').create('wp1', 'WorkPlane');
model.component('comp1').geom('geom1').feature('wp1').set('quickz', 1);
model.component('comp1').geom('geom1').feature('wp1').set('unite', true);
model.component('comp1').geom('geom1').feature('wp1').geom.create('sq1', 'Square');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('sq1').set('base', 'center');
model.component('comp1').geom('geom1').create('arr1', 'Array');
model.component('comp1').geom('geom1').feature('arr1').set('type', 'linear');
model.component('comp1').geom('geom1').feature('arr1').set('linearsize', 5);
model.component('comp1').geom('geom1').feature('arr1').set('displ', [0 0 1]);
model.component('comp1').geom('geom1').feature('arr1').selection('input').set({'wp1'});
model.component('comp1').geom('geom1').create('pt1', 'Point');
model.component('comp1').geom('geom1').feature('pt1').set('p', [0 0 5]);
model.component('comp1').geom('geom1').run;

model.variable.create('var1');
model.variable('var1').set('delta', '360/wavelength*0.05*wallTkn*pi/180', '360/wavelength*0.05*wallTkn*pi/180');

model.view.create('view3', 2);
model.view.create('view4', 3);

model.component('comp1').physics.create('gop', 'GeometricalOptics', 'geom1');
model.component('comp1').physics('gop').create('relg1', 'ReleaseGrid', -1);
model.component('comp1').physics('gop').create('lpol1', 'LinearPolarizer', 2);
model.component('comp1').physics('gop').feature('lpol1').selection.set([1]);
model.component('comp1').physics('gop').create('lpol2', 'LinearPolarizer', 2);
model.component('comp1').physics('gop').feature('lpol2').selection.set([4]);
model.component('comp1').physics('gop').create('lwav1', 'LinearWaveRetarder', 2);
model.component('comp1').physics('gop').feature('lwav1').selection.set([2]);
model.component('comp1').physics('gop').create('rd1', 'RayDetector', 2);
model.component('comp1').physics('gop').feature('rd1').selection.set([5]);
model.component('comp1').physics('gop').create('lwav2', 'LinearWaveRetarder', 2);
model.component('comp1').physics('gop').feature('lwav2').selection.set([3]);

model.result.table('tbl1').label('Accumulated Probe Table 1');
model.result.table('tbl2').comments('Ray Evaluation 2');

model.component('comp1').view('view2').axis.set('xmin', -1.5948904752731323);
model.component('comp1').view('view2').axis.set('xmax', 1.5948904752731323);
model.view('view3').axis.set('xmin', -2.4317691326141357);
model.view('view3').axis.set('xmax', 2.4317691326141357);
model.view('view3').axis.set('ymin', -1.0100806951522827);
model.view('view3').axis.set('ymax', 1.0100806951522827);

model.component('comp1').physics('gop').prop('IntensityComputation').set('IntensityComputation', 'ComputeIntensity');
model.component('comp1').physics('gop').prop('MaximumSecondary').set('MaximumSecondary', 0);
model.component('comp1').physics('gop').feature('mp1').set('n', [0.05; 0; 0; 0; 0.05; 0; 0; 0; 0.05]);
model.component('comp1').physics('gop').feature('mp1').set('ki', [1; 0; 0; 0; 1; 0; 0; 0; 1]);
model.component('comp1').physics('gop').feature('op1').set('lambda0', 'wavelength');
model.component('comp1').physics('gop').feature('relg1').set('L0', [0; 0; 1]);
model.component('comp1').physics('gop').feature('relg1').set('InitialPolarizationType', 'PartiallyPolarized');
model.component('comp1').physics('gop').feature('relg1').set('InitialPolarization', 'UserDefined');
model.component('comp1').physics('gop').feature('relg1').set('P0', 'fracPolar');
model.component('comp1').physics('gop').feature('relg1').set('lambda0min', '(660[nm])-sqrt(3)*(100[nm])');
model.component('comp1').physics('gop').feature('relg1').set('lambda0max', '(660[nm])+sqrt(3)*(100[nm])');
model.component('comp1').physics('gop').feature('relg1').set('numin', '(4.54e14[Hz])-sqrt(3)*(1E14[Hz])');
model.component('comp1').physics('gop').feature('relg1').set('numax', '(4.54e14[Hz])+sqrt(3)*(1E14[Hz])');
model.component('comp1').physics('gop').feature('lpol1').set('Ta', {'sin(pAngle)'; 'cos(pAngle)'; '0'});
model.component('comp1').physics('gop').feature('lpol2').set('Ta', {'sin(aAngle)'; 'cos(aAngle)'; '0'});
model.component('comp1').physics('gop').feature('lwav1').set('Fa', {'sin(retAngle1)'; 'cos(retAngle1)'; '0'});
model.component('comp1').physics('gop').feature('lwav1').set('deltal', 'delta');
model.component('comp1').physics('gop').feature('rd1').set('ReleaseFeature', 'relg1');
model.component('comp1').physics('gop').feature('lwav2').set('Fa', {'sin(-retAngle1)'; 'cos(-retAngle1)'; '0'});
model.component('comp1').physics('gop').feature('lwav2').set('deltal', 'delta');

model.study.create('std1');
model.study('std1').create('param3', 'Parametric');
model.study('std1').create('param2', 'Parametric');
model.study('std1').create('rtrac', 'RayTracing');

model.sol.create('sol1');
model.sol('sol1').study('std1');
model.sol('sol1').attach('std1');
model.sol('sol1').create('st1', 'StudyStep');
model.sol('sol1').create('v1', 'Variables');
model.sol('sol1').create('t1', 'Time');
model.sol('sol1').feature('t1').create('fc1', 'FullyCoupled');
model.sol('sol1').feature('t1').create('i1', 'Iterative');
model.sol('sol1').feature('t1').feature('i1').create('ja1', 'Jacobi');
model.sol('sol1').feature('t1').feature.remove('fcDef');
model.sol.create('sol2');
model.sol('sol2').study('std1');
model.sol('sol2').label('Parametric Solutions 1');

model.batch.create('p1', 'Parametric');
model.batch('p1').create('so1', 'Solutionseq');
model.batch('p1').study('std1');

model.result.dataset.create('ray1', 'Ray');
model.result.dataset('ray1').set('solution', 'sol2');
model.result.numerical.create('ray1', 'Ray');
model.result.numerical.create('ray2', 'Ray');
model.result.numerical('ray1').set('probetag', 'none');
model.result.numerical('ray2').set('probetag', 'none');
model.result.create('pg1', 'PlotGroup3D');
model.result.create('pg3', 'PlotGroup1D');
model.result.create('pg4', 'PlotGroup1D');
model.result.create('pg5', 'PlotGroup1D');
model.result('pg1').set('data', 'ray1');
model.result('pg1').create('rtrj1', 'RayTrajectories');
model.result('pg1').feature('rtrj1').create('col1', 'Color');
model.result('pg1').feature('rtrj1').create('filt1', 'RayTrajectoriesFilter');
model.result('pg1').feature('rtrj1').feature('col1').set('expr', 'gop.I');
model.result('pg3').set('data', 'dset2');
model.result('pg3').create('rtp1', 'Ray1D');
model.result('pg3').feature('rtp1').set('data', 'ray1');
model.result('pg3').feature('rtp1').set('expr', 'gop.I');
model.result('pg4').set('data', 'dset2');
model.result('pg4').create('rtp1', 'Ray1D');
model.result('pg4').feature('rtp1').set('data', 'ray1');
model.result('pg4').feature('rtp1').set('expr', 'gop.I0');
model.result('pg5').set('data', 'dset2');
model.result('pg5').create('rtp1', 'Ray1D');
model.result('pg5').create('rtp2', 'Ray1D');
model.result('pg5').feature('rtp1').set('data', 'ray1');
model.result('pg5').feature('rtp1').set('expr', 'gop.pax');
model.result('pg5').feature('rtp2').set('data', 'ray1');
model.result('pg5').feature('rtp2').set('expr', 'gop.pay');
model.result.export.create('data1', 'Data');
model.result.report.create('rpt3', 'Report');
model.result.report('rpt3').create('tp1', 'TitlePage');
model.result.report('rpt3').create('toc1', 'TableOfContents');
model.result.report('rpt3').create('sec1', 'Section');
model.result.report('rpt3').create('sec2', 'Section');
model.result.report('rpt3').create('sec3', 'Section');
model.result.report('rpt3').create('sec4', 'Section');
model.result.report('rpt3').feature('sec1').create('root1', 'Model');
model.result.report('rpt3').feature('sec1').create('sec1', 'Section');
model.result.report('rpt3').feature('sec1').create('sec2', 'Section');
model.result.report('rpt3').feature('sec1').create('sec3', 'Section');
model.result.report('rpt3').feature('sec1').feature('sec1').create('param1', 'Parameter');
model.result.report('rpt3').feature('sec1').feature('sec2').create('sec1', 'Section');
model.result.report('rpt3').feature('sec1').feature('sec2').feature('sec1').create('var1', 'Variables');
model.result.report('rpt3').feature('sec1').feature('sec3').create('sec1', 'Section');
model.result.report('rpt3').feature('sec1').feature('sec3').feature('sec1').create('func1', 'Functions');
model.result.report('rpt3').feature('sec2').create('comp1', 'ModelNode');
model.result.report('rpt3').feature('sec2').create('sec1', 'Section');
model.result.report('rpt3').feature('sec2').create('sec2', 'Section');
model.result.report('rpt3').feature('sec2').create('sec3', 'Section');
model.result.report('rpt3').feature('sec2').create('sec4', 'Section');
model.result.report('rpt3').feature('sec2').feature('sec1').create('sec1', 'Section');
model.result.report('rpt3').feature('sec2').feature('sec1').feature('sec1').create('sec1', 'Section');
model.result.report('rpt3').feature('sec2').feature('sec1').feature('sec1').feature('sec1').create('csys1', 'CoordinateSystem');
model.result.report('rpt3').feature('sec2').feature('sec2').create('geom1', 'Geometry');
model.result.report('rpt3').feature('sec2').feature('sec3').create('phys1', 'Physics');
model.result.report('rpt3').feature('sec2').feature('sec4').create('mesh1', 'Mesh');
model.result.report('rpt3').feature('sec3').create('std1', 'Study');
model.result.report('rpt3').feature('sec3').create('sec1', 'Section');
model.result.report('rpt3').feature('sec3').feature('sec1').create('sec1', 'Section');
model.result.report('rpt3').feature('sec3').feature('sec1').create('sec2', 'Section');
model.result.report('rpt3').feature('sec3').feature('sec1').feature('sec1').create('sol1', 'Solver');
model.result.report('rpt3').feature('sec3').feature('sec1').feature('sec2').create('sol1', 'Solver');
model.result.report('rpt3').feature('sec4').create('sec1', 'Section');
model.result.report('rpt3').feature('sec4').create('sec2', 'Section');
model.result.report('rpt3').feature('sec4').create('sec3', 'Section');
model.result.report('rpt3').feature('sec4').create('sec4', 'Section');
model.result.report('rpt3').feature('sec4').create('sec5', 'Section');
model.result.report('rpt3').feature('sec4').feature('sec1').create('param1', 'ResultParameter');
model.result.report('rpt3').feature('sec4').feature('sec2').create('sec1', 'Section');
model.result.report('rpt3').feature('sec4').feature('sec2').create('sec2', 'Section');
model.result.report('rpt3').feature('sec4').feature('sec2').create('sec3', 'Section');
model.result.report('rpt3').feature('sec4').feature('sec2').feature('sec1').create('dset1', 'DataSet');
model.result.report('rpt3').feature('sec4').feature('sec2').feature('sec2').create('dset1', 'DataSet');
model.result.report('rpt3').feature('sec4').feature('sec2').feature('sec3').create('dset1', 'DataSet');
model.result.report('rpt3').feature('sec4').feature('sec3').create('sec1', 'Section');
model.result.report('rpt3').feature('sec4').feature('sec3').create('sec2', 'Section');
model.result.report('rpt3').feature('sec4').feature('sec3').feature('sec1').create('num1', 'DerivedValues');
model.result.report('rpt3').feature('sec4').feature('sec3').feature('sec2').create('num1', 'DerivedValues');
model.result.report('rpt3').feature('sec4').feature('sec4').create('sec1', 'Section');
model.result.report('rpt3').feature('sec4').feature('sec4').create('sec2', 'Section');
model.result.report('rpt3').feature('sec4').feature('sec4').create('sec3', 'Section');
model.result.report('rpt3').feature('sec4').feature('sec4').create('sec4', 'Section');
model.result.report('rpt3').feature('sec4').feature('sec4').feature('sec1').create('mtbl1', 'Table');
model.result.report('rpt3').feature('sec4').feature('sec4').feature('sec2').create('mtbl1', 'Table');
model.result.report('rpt3').feature('sec4').feature('sec4').feature('sec3').create('mtbl1', 'Table');
model.result.report('rpt3').feature('sec4').feature('sec4').feature('sec4').create('mtbl1', 'Table');
model.result.report('rpt3').feature('sec4').feature('sec5').create('sec1', 'Section');
model.result.report('rpt3').feature('sec4').feature('sec5').create('sec2', 'Section');
model.result.report('rpt3').feature('sec4').feature('sec5').create('sec3', 'Section');
model.result.report('rpt3').feature('sec4').feature('sec5').create('sec4', 'Section');
model.result.report('rpt3').feature('sec4').feature('sec5').feature('sec1').create('pg1', 'PlotGroup');
model.result.report('rpt3').feature('sec4').feature('sec5').feature('sec2').create('pg1', 'PlotGroup');
model.result.report('rpt3').feature('sec4').feature('sec5').feature('sec3').create('pg1', 'PlotGroup');
model.result.report('rpt3').feature('sec4').feature('sec5').feature('sec4').create('pg1', 'PlotGroup');

model.study('std1').feature('param3').set('sweeptype', 'filled');
model.study('std1').feature('param3').set('pname', {'retAngle1' 'wallTkn' 'aAngle' 'wavelength' 'fracPolar'});
model.study('std1').feature('param3').set('plistarr', {'17*pi/180' '4e-6' 'range(0,0.1308996938995747,6.283185307179586)' 'range(4.0e-7,5.0e-8,6.5e-7)' '0'});
model.study('std1').feature('param3').set('punit', {'' 'm' '' 'm' ''});
model.study('std1').feature('param3').set('useaccumtable', true);
model.study('std1').feature('param3').set('accumtable', 'tbl1');
model.study('std1').feature('param2').active(false);
model.study('std1').feature('param2').set('sweeptype', 'filled');
model.study('std1').feature('param2').set('pname', {'retAngle1' 'wallTkn' 'aAngle' 'wavelength'});
model.study('std1').feature('param2').set('plistarr', {'-14*pi/180' '2e-6' 'range(0,0.1308996938995747,6.283185307179586)' 'range(4.0e-7,5.0e-8,6.5e-7)'});
model.study('std1').feature('param2').set('punit', {'' 'm' '' 'm'});
model.study('std1').feature('rtrac').set('timestepspec', 'specifylength');
model.study('std1').feature('rtrac').set('llist', 'range(0,0.1,5.1)');

model.sol('sol1').attach('std1');
model.sol('sol1').feature('st1').label('Compile Equations: Ray Tracing');
model.sol('sol1').feature('v1').label('Dependent Variables 1.1');
model.sol('sol1').feature('v1').set('clist', {'0.0 3.3356409519815207E-10 6.671281903963041E-10 1.0006922855944564E-9 1.3342563807926083E-9 1.6678204759907602E-9 2.0013845711889128E-9 2.3349486663870647E-9 2.6685127615852166E-9 3.0020768567833685E-9 3.3356409519815204E-9 3.6692050471796728E-9 4.0027691423778255E-9 4.336333237575977E-9 4.669897332774129E-9 5.0034614279722804E-9 5.337025523170433E-9 5.670589618368585E-9 6.004153713566737E-9 6.33771780876489E-9 6.671281903963041E-9 7.004845999161194E-9 7.3384100943593455E-9 7.671974189557497E-9 8.005538284755651E-9 8.339102379953801E-9 8.672666475151953E-9 9.006230570350105E-9 9.339794665548259E-9 9.67335876074641E-9 1.0006922855944561E-8 1.0340486951142714E-8 1.0674051046340866E-8 1.1007615141539018E-8 1.134117923673717E-8 1.1674743331935322E-8 1.2008307427133474E-8 1.2341871522331626E-8 1.267543561752978E-8 1.3008999712727931E-8 1.3342563807926082E-8 1.3676127903124235E-8 1.4009691998322387E-8 1.4343256093520537E-8 1.4676820188718691E-8 1.501038428391684E-8 1.5343948379114995E-8 1.567751247431315E-8 1.6011076569511302E-8 1.6344640664709452E-8 1.6678204759907603E-8 1.7011768855105756E-8 ' '1.7011768855105756E-11[s]'});
model.sol('sol1').feature('t1').label('Time-Dependent Solver 1.1');
model.sol('sol1').feature('t1').set('tlist', '0.0 3.3356409519815207E-10 6.671281903963041E-10 1.0006922855944564E-9 1.3342563807926083E-9 1.6678204759907602E-9 2.0013845711889128E-9 2.3349486663870647E-9 2.6685127615852166E-9 3.0020768567833685E-9 3.3356409519815204E-9 3.6692050471796728E-9 4.0027691423778255E-9 4.336333237575977E-9 4.669897332774129E-9 5.0034614279722804E-9 5.337025523170433E-9 5.670589618368585E-9 6.004153713566737E-9 6.33771780876489E-9 6.671281903963041E-9 7.004845999161194E-9 7.3384100943593455E-9 7.671974189557497E-9 8.005538284755651E-9 8.339102379953801E-9 8.672666475151953E-9 9.006230570350105E-9 9.339794665548259E-9 9.67335876074641E-9 1.0006922855944561E-8 1.0340486951142714E-8 1.0674051046340866E-8 1.1007615141539018E-8 1.134117923673717E-8 1.1674743331935322E-8 1.2008307427133474E-8 1.2341871522331626E-8 1.267543561752978E-8 1.3008999712727931E-8 1.3342563807926082E-8 1.3676127903124235E-8 1.4009691998322387E-8 1.4343256093520537E-8 1.4676820188718691E-8 1.501038428391684E-8 1.5343948379114995E-8 1.567751247431315E-8 1.6011076569511302E-8 1.6344640664709452E-8 1.6678204759907603E-8 1.7011768855105756E-8 ');
model.sol('sol1').feature('t1').set('rtol', 1.0E-5);
model.sol('sol1').feature('t1').set('timemethod', 'genalpha');
model.sol('sol1').feature('t1').set('estrat', 'exclude');
model.sol('sol1').feature('t1').set('tstepsgenalpha', 'strict');
model.sol('sol1').feature('t1').feature('dDef').label('Direct 1');
model.sol('sol1').feature('t1').feature('aDef').label('Advanced 1');
model.sol('sol1').feature('t1').feature('fc1').label('Fully Coupled 1.1');
model.sol('sol1').feature('t1').feature('fc1').set('ntolfact', 0.1);
model.sol('sol1').feature('t1').feature('i1').label('Iterative 1.1');
model.sol('sol1').feature('t1').feature('i1').feature('ilDef').label('Incomplete LU 1');
model.sol('sol1').feature('t1').feature('i1').feature('ja1').label('Jacobi 1.1');
model.sol('sol1').runAll;

model.batch('p1').set('control', 'param3');
model.batch('p1').set('sweeptype', 'filled');
model.batch('p1').set('pname', {'retAngle1' 'wallTkn' 'aAngle' 'wavelength' 'fracPolar'});
model.batch('p1').set('plistarr', {'17*pi/180' '4e-6' 'range(0,0.1308996938995747,6.283185307179586)' 'range(4.0e-7,5.0e-8,6.5e-7)' '0'});
model.batch('p1').set('punit', {'' 'm' '' 'm' ''});
model.batch('p1').set('useaccumtable', true);
model.batch('p1').set('accumtable', 'tbl1');
model.batch('p1').set('err', true);
model.batch('p1').feature('so1').set('seq', 'sol1');
model.batch('p1').feature('so1').set('psol', 'sol2');
model.batch('p1').feature('so1').set('param', {'"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","0","wavelength","4E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","0","wavelength","4.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","0","wavelength","5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","0","wavelength","5.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","0","wavelength","6E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","0","wavelength","6.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","0.130899693899575","wavelength","4E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","0.130899693899575","wavelength","4.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","0.130899693899575","wavelength","5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","0.130899693899575","wavelength","5.5E-7","fracPolar","0"'  ...
'"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","0.130899693899575","wavelength","6E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","0.130899693899575","wavelength","6.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","0.261799387799149","wavelength","4E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","0.261799387799149","wavelength","4.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","0.261799387799149","wavelength","5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","0.261799387799149","wavelength","5.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","0.261799387799149","wavelength","6E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","0.261799387799149","wavelength","6.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","0.392699081698724","wavelength","4E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","0.392699081698724","wavelength","4.5E-7","fracPolar","0"'  ...
'"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","0.392699081698724","wavelength","5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","0.392699081698724","wavelength","5.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","0.392699081698724","wavelength","6E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","0.392699081698724","wavelength","6.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","0.523598775598299","wavelength","4E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","0.523598775598299","wavelength","4.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","0.523598775598299","wavelength","5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","0.523598775598299","wavelength","5.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","0.523598775598299","wavelength","6E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","0.523598775598299","wavelength","6.5E-7","fracPolar","0"'  ...
'"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","0.654498469497874","wavelength","4E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","0.654498469497874","wavelength","4.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","0.654498469497874","wavelength","5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","0.654498469497874","wavelength","5.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","0.654498469497874","wavelength","6E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","0.654498469497874","wavelength","6.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","0.785398163397448","wavelength","4E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","0.785398163397448","wavelength","4.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","0.785398163397448","wavelength","5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","0.785398163397448","wavelength","5.5E-7","fracPolar","0"'  ...
'"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","0.785398163397448","wavelength","6E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","0.785398163397448","wavelength","6.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","0.916297857297023","wavelength","4E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","0.916297857297023","wavelength","4.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","0.916297857297023","wavelength","5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","0.916297857297023","wavelength","5.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","0.916297857297023","wavelength","6E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","0.916297857297023","wavelength","6.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","1.0471975511966","wavelength","4E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","1.0471975511966","wavelength","4.5E-7","fracPolar","0"'  ...
'"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","1.0471975511966","wavelength","5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","1.0471975511966","wavelength","5.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","1.0471975511966","wavelength","6E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","1.0471975511966","wavelength","6.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","1.17809724509617","wavelength","4E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","1.17809724509617","wavelength","4.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","1.17809724509617","wavelength","5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","1.17809724509617","wavelength","5.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","1.17809724509617","wavelength","6E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","1.17809724509617","wavelength","6.5E-7","fracPolar","0"'  ...
'"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","1.30899693899575","wavelength","4E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","1.30899693899575","wavelength","4.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","1.30899693899575","wavelength","5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","1.30899693899575","wavelength","5.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","1.30899693899575","wavelength","6E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","1.30899693899575","wavelength","6.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","1.43989663289532","wavelength","4E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","1.43989663289532","wavelength","4.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","1.43989663289532","wavelength","5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","1.43989663289532","wavelength","5.5E-7","fracPolar","0"'  ...
'"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","1.43989663289532","wavelength","6E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","1.43989663289532","wavelength","6.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","1.5707963267949","wavelength","4E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","1.5707963267949","wavelength","4.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","1.5707963267949","wavelength","5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","1.5707963267949","wavelength","5.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","1.5707963267949","wavelength","6E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","1.5707963267949","wavelength","6.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","1.70169602069447","wavelength","4E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","1.70169602069447","wavelength","4.5E-7","fracPolar","0"'  ...
'"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","1.70169602069447","wavelength","5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","1.70169602069447","wavelength","5.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","1.70169602069447","wavelength","6E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","1.70169602069447","wavelength","6.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","1.83259571459405","wavelength","4E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","1.83259571459405","wavelength","4.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","1.83259571459405","wavelength","5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","1.83259571459405","wavelength","5.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","1.83259571459405","wavelength","6E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","1.83259571459405","wavelength","6.5E-7","fracPolar","0"'  ...
'"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","1.96349540849362","wavelength","4E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","1.96349540849362","wavelength","4.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","1.96349540849362","wavelength","5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","1.96349540849362","wavelength","5.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","1.96349540849362","wavelength","6E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","1.96349540849362","wavelength","6.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","2.0943951023932","wavelength","4E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","2.0943951023932","wavelength","4.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","2.0943951023932","wavelength","5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","2.0943951023932","wavelength","5.5E-7","fracPolar","0"'  ...
'"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","2.0943951023932","wavelength","6E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","2.0943951023932","wavelength","6.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","2.22529479629277","wavelength","4E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","2.22529479629277","wavelength","4.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","2.22529479629277","wavelength","5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","2.22529479629277","wavelength","5.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","2.22529479629277","wavelength","6E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","2.22529479629277","wavelength","6.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","2.35619449019235","wavelength","4E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","2.35619449019235","wavelength","4.5E-7","fracPolar","0"'  ...
'"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","2.35619449019235","wavelength","5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","2.35619449019235","wavelength","5.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","2.35619449019235","wavelength","6E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","2.35619449019235","wavelength","6.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","2.48709418409192","wavelength","4E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","2.48709418409192","wavelength","4.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","2.48709418409192","wavelength","5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","2.48709418409192","wavelength","5.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","2.48709418409192","wavelength","6E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","2.48709418409192","wavelength","6.5E-7","fracPolar","0"'  ...
'"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","2.61799387799149","wavelength","4E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","2.61799387799149","wavelength","4.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","2.61799387799149","wavelength","5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","2.61799387799149","wavelength","5.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","2.61799387799149","wavelength","6E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","2.61799387799149","wavelength","6.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","2.74889357189107","wavelength","4E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","2.74889357189107","wavelength","4.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","2.74889357189107","wavelength","5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","2.74889357189107","wavelength","5.5E-7","fracPolar","0"'  ...
'"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","2.74889357189107","wavelength","6E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","2.74889357189107","wavelength","6.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","2.87979326579064","wavelength","4E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","2.87979326579064","wavelength","4.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","2.87979326579064","wavelength","5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","2.87979326579064","wavelength","5.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","2.87979326579064","wavelength","6E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","2.87979326579064","wavelength","6.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","3.01069295969022","wavelength","4E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","3.01069295969022","wavelength","4.5E-7","fracPolar","0"'  ...
'"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","3.01069295969022","wavelength","5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","3.01069295969022","wavelength","5.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","3.01069295969022","wavelength","6E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","3.01069295969022","wavelength","6.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","3.14159265358979","wavelength","4E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","3.14159265358979","wavelength","4.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","3.14159265358979","wavelength","5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","3.14159265358979","wavelength","5.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","3.14159265358979","wavelength","6E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","3.14159265358979","wavelength","6.5E-7","fracPolar","0"'  ...
'"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","3.27249234748937","wavelength","4E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","3.27249234748937","wavelength","4.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","3.27249234748937","wavelength","5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","3.27249234748937","wavelength","5.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","3.27249234748937","wavelength","6E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","3.27249234748937","wavelength","6.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","3.40339204138894","wavelength","4E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","3.40339204138894","wavelength","4.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","3.40339204138894","wavelength","5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","3.40339204138894","wavelength","5.5E-7","fracPolar","0"'  ...
'"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","3.40339204138894","wavelength","6E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","3.40339204138894","wavelength","6.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","3.53429173528852","wavelength","4E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","3.53429173528852","wavelength","4.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","3.53429173528852","wavelength","5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","3.53429173528852","wavelength","5.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","3.53429173528852","wavelength","6E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","3.53429173528852","wavelength","6.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","3.66519142918809","wavelength","4E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","3.66519142918809","wavelength","4.5E-7","fracPolar","0"'  ...
'"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","3.66519142918809","wavelength","5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","3.66519142918809","wavelength","5.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","3.66519142918809","wavelength","6E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","3.66519142918809","wavelength","6.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","3.79609112308767","wavelength","4E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","3.79609112308767","wavelength","4.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","3.79609112308767","wavelength","5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","3.79609112308767","wavelength","5.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","3.79609112308767","wavelength","6E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","3.79609112308767","wavelength","6.5E-7","fracPolar","0"'  ...
'"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","3.92699081698724","wavelength","4E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","3.92699081698724","wavelength","4.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","3.92699081698724","wavelength","5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","3.92699081698724","wavelength","5.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","3.92699081698724","wavelength","6E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","3.92699081698724","wavelength","6.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","4.05789051088682","wavelength","4E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","4.05789051088682","wavelength","4.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","4.05789051088682","wavelength","5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","4.05789051088682","wavelength","5.5E-7","fracPolar","0"'  ...
'"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","4.05789051088682","wavelength","6E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","4.05789051088682","wavelength","6.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","4.18879020478639","wavelength","4E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","4.18879020478639","wavelength","4.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","4.18879020478639","wavelength","5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","4.18879020478639","wavelength","5.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","4.18879020478639","wavelength","6E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","4.18879020478639","wavelength","6.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","4.31968989868597","wavelength","4E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","4.31968989868597","wavelength","4.5E-7","fracPolar","0"'  ...
'"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","4.31968989868597","wavelength","5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","4.31968989868597","wavelength","5.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","4.31968989868597","wavelength","6E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","4.31968989868597","wavelength","6.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","4.45058959258554","wavelength","4E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","4.45058959258554","wavelength","4.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","4.45058959258554","wavelength","5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","4.45058959258554","wavelength","5.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","4.45058959258554","wavelength","6E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","4.45058959258554","wavelength","6.5E-7","fracPolar","0"'  ...
'"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","4.58148928648511","wavelength","4E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","4.58148928648511","wavelength","4.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","4.58148928648511","wavelength","5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","4.58148928648511","wavelength","5.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","4.58148928648511","wavelength","6E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","4.58148928648511","wavelength","6.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","4.71238898038469","wavelength","4E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","4.71238898038469","wavelength","4.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","4.71238898038469","wavelength","5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","4.71238898038469","wavelength","5.5E-7","fracPolar","0"'  ...
'"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","4.71238898038469","wavelength","6E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","4.71238898038469","wavelength","6.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","4.84328867428426","wavelength","4E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","4.84328867428426","wavelength","4.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","4.84328867428426","wavelength","5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","4.84328867428426","wavelength","5.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","4.84328867428426","wavelength","6E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","4.84328867428426","wavelength","6.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","4.97418836818384","wavelength","4E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","4.97418836818384","wavelength","4.5E-7","fracPolar","0"'  ...
'"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","4.97418836818384","wavelength","5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","4.97418836818384","wavelength","5.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","4.97418836818384","wavelength","6E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","4.97418836818384","wavelength","6.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","5.10508806208341","wavelength","4E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","5.10508806208341","wavelength","4.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","5.10508806208341","wavelength","5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","5.10508806208341","wavelength","5.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","5.10508806208341","wavelength","6E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","5.10508806208341","wavelength","6.5E-7","fracPolar","0"'  ...
'"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","5.23598775598299","wavelength","4E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","5.23598775598299","wavelength","4.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","5.23598775598299","wavelength","5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","5.23598775598299","wavelength","5.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","5.23598775598299","wavelength","6E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","5.23598775598299","wavelength","6.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","5.36688744988256","wavelength","4E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","5.36688744988256","wavelength","4.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","5.36688744988256","wavelength","5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","5.36688744988256","wavelength","5.5E-7","fracPolar","0"'  ...
'"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","5.36688744988256","wavelength","6E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","5.36688744988256","wavelength","6.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","5.49778714378214","wavelength","4E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","5.49778714378214","wavelength","4.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","5.49778714378214","wavelength","5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","5.49778714378214","wavelength","5.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","5.49778714378214","wavelength","6E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","5.49778714378214","wavelength","6.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","5.62868683768171","wavelength","4E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","5.62868683768171","wavelength","4.5E-7","fracPolar","0"'  ...
'"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","5.62868683768171","wavelength","5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","5.62868683768171","wavelength","5.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","5.62868683768171","wavelength","6E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","5.62868683768171","wavelength","6.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","5.75958653158129","wavelength","4E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","5.75958653158129","wavelength","4.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","5.75958653158129","wavelength","5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","5.75958653158129","wavelength","5.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","5.75958653158129","wavelength","6E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","5.75958653158129","wavelength","6.5E-7","fracPolar","0"'  ...
'"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","5.89048622548086","wavelength","4E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","5.89048622548086","wavelength","4.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","5.89048622548086","wavelength","5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","5.89048622548086","wavelength","5.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","5.89048622548086","wavelength","6E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","5.89048622548086","wavelength","6.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","6.02138591938044","wavelength","4E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","6.02138591938044","wavelength","4.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","6.02138591938044","wavelength","5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","6.02138591938044","wavelength","5.5E-7","fracPolar","0"'  ...
'"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","6.02138591938044","wavelength","6E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","6.02138591938044","wavelength","6.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","6.15228561328001","wavelength","4E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","6.15228561328001","wavelength","4.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","6.15228561328001","wavelength","5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","6.15228561328001","wavelength","5.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","6.15228561328001","wavelength","6E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","6.15228561328001","wavelength","6.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","6.28318530717959","wavelength","4E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","6.28318530717959","wavelength","4.5E-7","fracPolar","0"'  ...
'"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","6.28318530717959","wavelength","5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","6.28318530717959","wavelength","5.5E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","6.28318530717959","wavelength","6E-7","fracPolar","0"' '"retAngle1","0.296705972839036","wallTkn","4E-6","aAngle","6.28318530717959","wavelength","6.5E-7","fracPolar","0"'});
model.batch('p1').attach('std1');
model.batch('p1').run;

model.result.numerical('ray1').set('expr', 'gop.I');
model.result.numerical('ray1').set('unit', 'W/m^2');
model.result.numerical('ray1').set('descr', 'Intensity');
model.result.numerical('ray2').set('looplevelinput', {'last' 'all' 'all'});
model.result.numerical('ray2').set('table', 'tbl2');
model.result.numerical('ray2').set('expr', 'gop.I');
model.result.numerical('ray2').set('unit', 'W/m^2');
model.result.numerical('ray2').set('descr', 'Intensity');
model.result.numerical('ray2').setResult;
model.result('pg1').active(false);
model.result('pg1').label('No Wave retarder');
model.result('pg1').set('looplevel', [1 1 1]);
model.result('pg1').set('edges', false);
model.result('pg3').active(false);
model.result('pg3').set('showlegendsmaxmin', true);
model.result('pg3').feature('rtp1').set('linewidth', 2);
model.result('pg3').feature('rtp1').set('linemarker', 'cycle');
model.result('pg3').feature('rtp1').set('legend', true);
model.result('pg3').feature('rtp1').set('dataseries', 'none');
model.result('pg4').set('xlabel', 't (s)');
model.result('pg4').set('ylabel', 'Initial intensity (W/m<sup>2</sup>)');
model.result('pg4').set('showlegends', false);
model.result('pg4').set('xlabelactive', false);
model.result('pg4').set('ylabelactive', false);
model.result('pg4').feature('rtp1').set('linewidth', 2);
model.result('pg4').feature('rtp1').set('linemarker', 'cycle');
model.result('pg4').feature('rtp1').set('legend', true);
model.result('pg4').feature('rtp1').set('dataseries', 'none');
model.result('pg5').active(false);
model.result('pg5').set('showlegends', false);
model.result('pg5').feature('rtp1').set('unit', 'rad');
model.result('pg5').feature('rtp1').set('linewidth', 2);
model.result('pg5').feature('rtp1').set('linemarker', 'cycle');
model.result('pg5').feature('rtp1').set('legend', true);
model.result('pg5').feature('rtp1').set('dataseries', 'none');
model.result('pg5').feature('rtp2').set('unit', 'rad');
model.result('pg5').feature('rtp2').set('linewidth', 2);
model.result('pg5').feature('rtp2').set('linemarker', 'cycle');
model.result('pg5').feature('rtp2').set('legend', true);
model.result('pg5').feature('rtp2').set('dataseries', 'none');
model.result.report('rpt3').set('templatesource', 'complete');
model.result.report('rpt3').set('filename', 'C:\Users\augus\Documents\softwareProjects\OpticalMFADetermination\comsolModel\systemReport.html');
model.result.report('rpt3').feature('tp1').label('LinearOpticsTutorial');
model.result.report('rpt3').feature('sec1').label('Global Definitions');
model.result.report('rpt3').feature('sec1').feature('root1').set('includeunitsystem', true);
model.result.report('rpt3').feature('sec1').feature('sec1').label('Parameters');
model.result.report('rpt3').feature('sec1').feature('sec2').label('Variables');
model.result.report('rpt3').feature('sec1').feature('sec2').feature('sec1').label('Variables 1');
model.result.report('rpt3').feature('sec1').feature('sec2').feature('sec1').set('source', 'firstchild');
model.result.report('rpt3').feature('sec1').feature('sec3').label('Functions');
model.result.report('rpt3').feature('sec1').feature('sec3').feature('sec1').label('Function 1');
model.result.report('rpt3').feature('sec1').feature('sec3').feature('sec1').set('source', 'firstchild');
model.result.report('rpt3').feature('sec2').label('Component 1');
model.result.report('rpt3').feature('sec2').feature('comp1').set('includeauthor', true);
model.result.report('rpt3').feature('sec2').feature('comp1').set('includedatecreated', true);
model.result.report('rpt3').feature('sec2').feature('comp1').set('includeversion', true);
model.result.report('rpt3').feature('sec2').feature('comp1').set('includeframes', true);
model.result.report('rpt3').feature('sec2').feature('comp1').set('includegeomshapeorder', true);
model.result.report('rpt3').feature('sec2').feature('sec1').label('Definitions');
model.result.report('rpt3').feature('sec2').feature('sec1').feature('sec1').label('Coordinate Systems');
model.result.report('rpt3').feature('sec2').feature('sec1').feature('sec1').feature('sec1').label('Boundary System 1');
model.result.report('rpt3').feature('sec2').feature('sec1').feature('sec1').feature('sec1').set('source', 'firstchild');
model.result.report('rpt3').feature('sec2').feature('sec2').label('Geometry 1');
model.result.report('rpt3').feature('sec2').feature('sec2').set('source', 'firstchild');
model.result.report('rpt3').feature('sec2').feature('sec3').label('Geometrical Optics');
model.result.report('rpt3').feature('sec2').feature('sec3').set('source', 'firstchild');
model.result.report('rpt3').feature('sec2').feature('sec4').label('Mesh 1');
model.result.report('rpt3').feature('sec2').feature('sec4').set('source', 'firstchild');
model.result.report('rpt3').feature('sec2').feature('sec4').feature('mesh1').set('includestats', true);
model.result.report('rpt3').feature('sec2').feature('sec4').feature('mesh1').set('children', {'size' 'on'; 'ftri1' 'on'; 'ftri1' 'on'; 'ftri1' 'on'});
model.result.report('rpt3').feature('sec3').label('Study 1');
model.result.report('rpt3').feature('sec3').feature('std1').set('children', {'param3' 'on'; 'param2' 'on'; 'rtrac' 'on'});
model.result.report('rpt3').feature('sec3').feature('sec1').label('Solver Configurations');
model.result.report('rpt3').feature('sec3').feature('sec1').feature('sec1').label('Solution 1');
model.result.report('rpt3').feature('sec3').feature('sec1').feature('sec1').set('source', 'firstchild');
model.result.report('rpt3').feature('sec3').feature('sec1').feature('sec1').feature('sol1').set('includelog', true);
model.result.report('rpt3').feature('sec3').feature('sec1').feature('sec2').label('Parametric Solutions 1');
model.result.report('rpt3').feature('sec3').feature('sec1').feature('sec2').set('source', 'firstchild');
model.result.report('rpt3').feature('sec3').feature('sec1').feature('sec2').feature('sol1').set('noderef', 'sol2');
model.result.report('rpt3').feature('sec3').feature('sec1').feature('sec2').feature('sol1').set('includelog', true);
model.result.report('rpt3').feature('sec3').feature('sec1').feature('sec2').feature('sol1').set('children', {'su1' 'on';  ...
'su2' 'on';  ...
'su3' 'on';  ...
'su4' 'on';  ...
'su5' 'on';  ...
'su6' 'on';  ...
'su7' 'on';  ...
'su8' 'on';  ...
'su9' 'on';  ...
'su10' 'on';  ...
'su11' 'on';  ...
'su12' 'on';  ...
'su13' 'on';  ...
'su14' 'on';  ...
'su15' 'on';  ...
'su16' 'on';  ...
'su17' 'on';  ...
'su18' 'on';  ...
'su19' 'on';  ...
'su20' 'on';  ...
'su21' 'on';  ...
'su22' 'on';  ...
'su23' 'on';  ...
'su24' 'on';  ...
'su25' 'on';  ...
'su26' 'on';  ...
'su27' 'on';  ...
'su28' 'on';  ...
'su29' 'on';  ...
'su30' 'on';  ...
'su31' 'on';  ...
'su32' 'on';  ...
'su33' 'on';  ...
'su34' 'on';  ...
'su35' 'on';  ...
'su36' 'on';  ...
'su37' 'on';  ...
'su38' 'on';  ...
'su39' 'on';  ...
'su40' 'on';  ...
'su41' 'on';  ...
'su42' 'on';  ...
'su43' 'on';  ...
'su44' 'on';  ...
'su45' 'on';  ...
'su46' 'on';  ...
'su47' 'on';  ...
'su48' 'on';  ...
'su49' 'on';  ...
'su50' 'on';  ...
'su51' 'on';  ...
'su52' 'on';  ...
'su53' 'on';  ...
'su54' 'on';  ...
'su55' 'on';  ...
'su56' 'on';  ...
'su57' 'on';  ...
'su58' 'on';  ...
'su59' 'on';  ...
'su60' 'on';  ...
'su61' 'on';  ...
'su62' 'on';  ...
'su63' 'on';  ...
'su64' 'on';  ...
'su65' 'on';  ...
'su66' 'on';  ...
'su67' 'on';  ...
'su68' 'on';  ...
'su69' 'on';  ...
'su70' 'on';  ...
'su71' 'on';  ...
'su72' 'on';  ...
'su73' 'on';  ...
'su74' 'on';  ...
'su75' 'on';  ...
'su76' 'on';  ...
'su77' 'on';  ...
'su78' 'on';  ...
'su79' 'on';  ...
'su80' 'on';  ...
'su81' 'on';  ...
'su82' 'on';  ...
'su83' 'on';  ...
'su84' 'on';  ...
'su85' 'on';  ...
'su86' 'on';  ...
'su87' 'on';  ...
'su88' 'on';  ...
'su89' 'on';  ...
'su90' 'on';  ...
'su91' 'on';  ...
'su92' 'on';  ...
'su93' 'on';  ...
'su94' 'on';  ...
'su95' 'on';  ...
'su96' 'on';  ...
'su97' 'on';  ...
'su98' 'on';  ...
'su99' 'on';  ...
'su100' 'on';  ...
'su101' 'on';  ...
'su102' 'on';  ...
'su103' 'on';  ...
'su104' 'on';  ...
'su105' 'on';  ...
'su106' 'on';  ...
'su107' 'on';  ...
'su108' 'on';  ...
'su109' 'on';  ...
'su110' 'on';  ...
'su111' 'on';  ...
'su112' 'on';  ...
'su113' 'on';  ...
'su114' 'on';  ...
'su115' 'on';  ...
'su116' 'on';  ...
'su117' 'on';  ...
'su118' 'on';  ...
'su119' 'on';  ...
'su120' 'on';  ...
'su121' 'on';  ...
'su122' 'on';  ...
'su123' 'on';  ...
'su124' 'on';  ...
'su125' 'on';  ...
'su126' 'on';  ...
'su127' 'on';  ...
'su128' 'on';  ...
'su129' 'on';  ...
'su130' 'on';  ...
'su131' 'on';  ...
'su132' 'on';  ...
'su133' 'on';  ...
'su134' 'on';  ...
'su135' 'on';  ...
'su136' 'on';  ...
'su137' 'on';  ...
'su138' 'on';  ...
'su139' 'on';  ...
'su140' 'on';  ...
'su141' 'on';  ...
'su142' 'on';  ...
'su143' 'on';  ...
'su144' 'on';  ...
'su145' 'on';  ...
'su146' 'on';  ...
'su147' 'on';  ...
'su148' 'on';  ...
'su149' 'on';  ...
'su150' 'on';  ...
'su151' 'on';  ...
'su152' 'on';  ...
'su153' 'on';  ...
'su154' 'on';  ...
'su155' 'on';  ...
'su156' 'on';  ...
'su157' 'on';  ...
'su158' 'on';  ...
'su159' 'on';  ...
'su160' 'on';  ...
'su161' 'on';  ...
'su162' 'on';  ...
'su163' 'on';  ...
'su164' 'on';  ...
'su165' 'on';  ...
'su166' 'on';  ...
'su167' 'on';  ...
'su168' 'on';  ...
'su169' 'on';  ...
'su170' 'on';  ...
'su171' 'on';  ...
'su172' 'on';  ...
'su173' 'on';  ...
'su174' 'on';  ...
'su175' 'on';  ...
'su176' 'on';  ...
'su177' 'on';  ...
'su178' 'on';  ...
'su179' 'on';  ...
'su180' 'on';  ...
'su181' 'on';  ...
'su182' 'on';  ...
'su183' 'on';  ...
'su184' 'on';  ...
'su185' 'on';  ...
'su186' 'on';  ...
'su187' 'on';  ...
'su188' 'on';  ...
'su189' 'on';  ...
'su190' 'on';  ...
'su191' 'on';  ...
'su192' 'on';  ...
'su193' 'on';  ...
'su194' 'on';  ...
'su195' 'on';  ...
'su196' 'on';  ...
'su197' 'on';  ...
'su198' 'on';  ...
'su199' 'on';  ...
'su200' 'on';  ...
'su201' 'on';  ...
'su202' 'on';  ...
'su203' 'on';  ...
'su204' 'on';  ...
'su205' 'on';  ...
'su206' 'on';  ...
'su207' 'on';  ...
'su208' 'on';  ...
'su209' 'on';  ...
'su210' 'on';  ...
'su211' 'on';  ...
'su212' 'on';  ...
'su213' 'on';  ...
'su214' 'on';  ...
'su215' 'on';  ...
'su216' 'on';  ...
'su217' 'on';  ...
'su218' 'on';  ...
'su219' 'on';  ...
'su220' 'on';  ...
'su221' 'on';  ...
'su222' 'on';  ...
'su223' 'on';  ...
'su224' 'on';  ...
'su225' 'on';  ...
'su226' 'on';  ...
'su227' 'on';  ...
'su228' 'on';  ...
'su229' 'on';  ...
'su230' 'on';  ...
'su231' 'on';  ...
'su232' 'on';  ...
'su233' 'on';  ...
'su234' 'on';  ...
'su235' 'on';  ...
'su236' 'on';  ...
'su237' 'on';  ...
'su238' 'on';  ...
'su239' 'on';  ...
'su240' 'on';  ...
'su241' 'on';  ...
'su242' 'on';  ...
'su243' 'on';  ...
'su244' 'on';  ...
'su245' 'on';  ...
'su246' 'on';  ...
'su247' 'on';  ...
'su248' 'on';  ...
'su249' 'on';  ...
'su250' 'on';  ...
'su251' 'on';  ...
'su252' 'on';  ...
'su253' 'on';  ...
'su254' 'on';  ...
'su255' 'on';  ...
'su256' 'on';  ...
'su257' 'on';  ...
'su258' 'on';  ...
'su259' 'on';  ...
'su260' 'on';  ...
'su261' 'on';  ...
'su262' 'on';  ...
'su263' 'on';  ...
'su264' 'on';  ...
'su265' 'on';  ...
'su266' 'on';  ...
'su267' 'on';  ...
'su268' 'on';  ...
'su269' 'on';  ...
'su270' 'on';  ...
'su271' 'on';  ...
'su272' 'on';  ...
'su273' 'on';  ...
'su274' 'on';  ...
'su275' 'on';  ...
'su276' 'on';  ...
'su277' 'on';  ...
'su278' 'on';  ...
'su279' 'on';  ...
'su280' 'on';  ...
'su281' 'on';  ...
'su282' 'on';  ...
'su283' 'on';  ...
'su284' 'on';  ...
'su285' 'on';  ...
'su286' 'on';  ...
'su287' 'on';  ...
'su288' 'on';  ...
'su289' 'on';  ...
'su290' 'on';  ...
'su291' 'on';  ...
'su292' 'on';  ...
'su293' 'on';  ...
'su294' 'on'});
model.result.report('rpt3').feature('sec4').label('Results');
model.result.report('rpt3').feature('sec4').feature('sec1').label('Parameters 1');
model.result.report('rpt3').feature('sec4').feature('sec1').set('source', 'firstchild');
model.result.report('rpt3').feature('sec4').feature('sec2').label('Data Sets');
model.result.report('rpt3').feature('sec4').feature('sec2').feature('sec1').label('Study 1/Solution 1');
model.result.report('rpt3').feature('sec4').feature('sec2').feature('sec1').set('source', 'firstchild');
model.result.report('rpt3').feature('sec4').feature('sec2').feature('sec2').label('Study 1/Parametric Solutions 1');
model.result.report('rpt3').feature('sec4').feature('sec2').feature('sec2').set('source', 'firstchild');
model.result.report('rpt3').feature('sec4').feature('sec2').feature('sec2').feature('dset1').set('noderef', 'dset2');
model.result.report('rpt3').feature('sec4').feature('sec2').feature('sec3').label('Ray 1');
model.result.report('rpt3').feature('sec4').feature('sec2').feature('sec3').set('source', 'firstchild');
model.result.report('rpt3').feature('sec4').feature('sec2').feature('sec3').feature('dset1').set('noderef', 'ray1');
model.result.report('rpt3').feature('sec4').feature('sec3').label('Derived Values');
model.result.report('rpt3').feature('sec4').feature('sec3').feature('sec1').label('Ray Evaluation 1');
model.result.report('rpt3').feature('sec4').feature('sec3').feature('sec1').set('source', 'firstchild');
model.result.report('rpt3').feature('sec4').feature('sec3').feature('sec2').label('Ray Evaluation 2');
model.result.report('rpt3').feature('sec4').feature('sec3').feature('sec2').set('source', 'firstchild');
model.result.report('rpt3').feature('sec4').feature('sec3').feature('sec2').feature('num1').set('noderef', 'ray2');
model.result.report('rpt3').feature('sec4').feature('sec4').label('Tables');
model.result.report('rpt3').feature('sec4').feature('sec4').feature('sec1').label('Accumulated Probe Table 1');
model.result.report('rpt3').feature('sec4').feature('sec4').feature('sec1').set('source', 'firstchild');
model.result.report('rpt3').feature('sec4').feature('sec4').feature('sec2').label('Accumulated Probe Table 1.1');
model.result.report('rpt3').feature('sec4').feature('sec4').feature('sec2').set('source', 'firstchild');
model.result.report('rpt3').feature('sec4').feature('sec4').feature('sec3').label('Accumulated Probe Table 1.1');
model.result.report('rpt3').feature('sec4').feature('sec4').feature('sec3').set('source', 'firstchild');
model.result.report('rpt3').feature('sec4').feature('sec4').feature('sec4').label('Accumulated Probe Table 1.1');
model.result.report('rpt3').feature('sec4').feature('sec4').feature('sec4').set('source', 'firstchild');
model.result.report('rpt3').feature('sec4').feature('sec5').label('Plot Groups');
model.result.report('rpt3').feature('sec4').feature('sec5').feature('sec1').label('No Wave retarder');
model.result.report('rpt3').feature('sec4').feature('sec5').feature('sec1').set('source', 'firstchild');
model.result.report('rpt3').feature('sec4').feature('sec5').feature('sec2').label('1D Plot Group 3');
model.result.report('rpt3').feature('sec4').feature('sec5').feature('sec2').set('source', 'firstchild');
model.result.report('rpt3').feature('sec4').feature('sec5').feature('sec2').feature('pg1').set('noderef', 'pg3');
model.result.report('rpt3').feature('sec4').feature('sec5').feature('sec3').label('1D Plot Group 4');
model.result.report('rpt3').feature('sec4').feature('sec5').feature('sec3').set('source', 'firstchild');
model.result.report('rpt3').feature('sec4').feature('sec5').feature('sec3').feature('pg1').set('noderef', 'pg4');
model.result.report('rpt3').feature('sec4').feature('sec5').feature('sec4').label('1D Plot Group 5');
model.result.report('rpt3').feature('sec4').feature('sec5').feature('sec4').set('source', 'firstchild');
model.result.report('rpt3').feature('sec4').feature('sec5').feature('sec4').feature('pg1').set('noderef', 'pg5');

model.sol('sol1').clearSolutionData;
model.sol('sol2').clearSolutionData;
model.sol('sol3').clearSolutionData;
model.sol('sol4').clearSolutionData;
model.sol('sol5').clearSolutionData;
model.sol('sol6').clearSolutionData;
model.sol('sol7').clearSolutionData;
model.sol('sol8').clearSolutionData;
model.sol('sol9').clearSolutionData;
model.sol('sol10').clearSolutionData;
model.sol('sol11').clearSolutionData;
model.sol('sol12').clearSolutionData;
model.sol('sol13').clearSolutionData;
model.sol('sol14').clearSolutionData;
model.sol('sol15').clearSolutionData;
model.sol('sol16').clearSolutionData;
model.sol('sol17').clearSolutionData;
model.sol('sol18').clearSolutionData;
model.sol('sol19').clearSolutionData;
model.sol('sol20').clearSolutionData;
model.sol('sol21').clearSolutionData;
model.sol('sol22').clearSolutionData;
model.sol('sol23').clearSolutionData;
model.sol('sol24').clearSolutionData;
model.sol('sol25').clearSolutionData;
model.sol('sol26').clearSolutionData;
model.sol('sol27').clearSolutionData;
model.sol('sol28').clearSolutionData;
model.sol('sol29').clearSolutionData;
model.sol('sol30').clearSolutionData;
model.sol('sol31').clearSolutionData;
model.sol('sol32').clearSolutionData;
model.sol('sol33').clearSolutionData;
model.sol('sol34').clearSolutionData;
model.sol('sol35').clearSolutionData;
model.sol('sol36').clearSolutionData;
model.sol('sol37').clearSolutionData;
model.sol('sol38').clearSolutionData;
model.sol('sol39').clearSolutionData;
model.sol('sol40').clearSolutionData;
model.sol('sol41').clearSolutionData;
model.sol('sol42').clearSolutionData;
model.sol('sol43').clearSolutionData;
model.sol('sol44').clearSolutionData;
model.sol('sol45').clearSolutionData;
model.sol('sol46').clearSolutionData;
model.sol('sol47').clearSolutionData;
model.sol('sol48').clearSolutionData;
model.sol('sol49').clearSolutionData;
model.sol('sol50').clearSolutionData;
model.sol('sol51').clearSolutionData;
model.sol('sol52').clearSolutionData;
model.sol('sol53').clearSolutionData;
model.sol('sol54').clearSolutionData;
model.sol('sol55').clearSolutionData;
model.sol('sol56').clearSolutionData;
model.sol('sol57').clearSolutionData;
model.sol('sol58').clearSolutionData;
model.sol('sol59').clearSolutionData;
model.sol('sol60').clearSolutionData;
model.sol('sol61').clearSolutionData;
model.sol('sol62').clearSolutionData;
model.sol('sol63').clearSolutionData;
model.sol('sol64').clearSolutionData;
model.sol('sol65').clearSolutionData;
model.sol('sol66').clearSolutionData;
model.sol('sol67').clearSolutionData;
model.sol('sol68').clearSolutionData;
model.sol('sol69').clearSolutionData;
model.sol('sol70').clearSolutionData;
model.sol('sol71').clearSolutionData;
model.sol('sol72').clearSolutionData;
model.sol('sol73').clearSolutionData;
model.sol('sol74').clearSolutionData;
model.sol('sol75').clearSolutionData;
model.sol('sol76').clearSolutionData;
model.sol('sol77').clearSolutionData;
model.sol('sol78').clearSolutionData;
model.sol('sol79').clearSolutionData;
model.sol('sol80').clearSolutionData;
model.sol('sol81').clearSolutionData;
model.sol('sol82').clearSolutionData;
model.sol('sol83').clearSolutionData;
model.sol('sol84').clearSolutionData;
model.sol('sol85').clearSolutionData;
model.sol('sol86').clearSolutionData;
model.sol('sol87').clearSolutionData;
model.sol('sol88').clearSolutionData;
model.sol('sol89').clearSolutionData;
model.sol('sol90').clearSolutionData;
model.sol('sol91').clearSolutionData;
model.sol('sol92').clearSolutionData;
model.sol('sol93').clearSolutionData;
model.sol('sol94').clearSolutionData;
model.sol('sol95').clearSolutionData;
model.sol('sol96').clearSolutionData;
model.sol('sol97').clearSolutionData;
model.sol('sol98').clearSolutionData;
model.sol('sol99').clearSolutionData;
model.sol('sol100').clearSolutionData;
model.sol('sol101').clearSolutionData;
model.sol('sol102').clearSolutionData;
model.sol('sol103').clearSolutionData;
model.sol('sol104').clearSolutionData;
model.sol('sol105').clearSolutionData;
model.sol('sol106').clearSolutionData;
model.sol('sol107').clearSolutionData;
model.sol('sol108').clearSolutionData;
model.sol('sol109').clearSolutionData;
model.sol('sol110').clearSolutionData;
model.sol('sol111').clearSolutionData;
model.sol('sol112').clearSolutionData;
model.sol('sol113').clearSolutionData;
model.sol('sol114').clearSolutionData;
model.sol('sol115').clearSolutionData;
model.sol('sol116').clearSolutionData;
model.sol('sol117').clearSolutionData;
model.sol('sol118').clearSolutionData;
model.sol('sol119').clearSolutionData;
model.sol('sol120').clearSolutionData;
model.sol('sol121').clearSolutionData;
model.sol('sol122').clearSolutionData;
model.sol('sol123').clearSolutionData;
model.sol('sol124').clearSolutionData;
model.sol('sol125').clearSolutionData;
model.sol('sol126').clearSolutionData;
model.sol('sol127').clearSolutionData;
model.sol('sol128').clearSolutionData;
model.sol('sol129').clearSolutionData;
model.sol('sol130').clearSolutionData;
model.sol('sol131').clearSolutionData;
model.sol('sol132').clearSolutionData;
model.sol('sol133').clearSolutionData;
model.sol('sol134').clearSolutionData;
model.sol('sol135').clearSolutionData;
model.sol('sol136').clearSolutionData;
model.sol('sol137').clearSolutionData;
model.sol('sol138').clearSolutionData;
model.sol('sol139').clearSolutionData;
model.sol('sol140').clearSolutionData;
model.sol('sol141').clearSolutionData;
model.sol('sol142').clearSolutionData;
model.sol('sol143').clearSolutionData;
model.sol('sol144').clearSolutionData;
model.sol('sol145').clearSolutionData;
model.sol('sol146').clearSolutionData;
model.sol('sol147').clearSolutionData;
model.sol('sol148').clearSolutionData;
model.sol('sol149').clearSolutionData;
model.sol('sol150').clearSolutionData;
model.sol('sol151').clearSolutionData;
model.sol('sol152').clearSolutionData;
model.sol('sol153').clearSolutionData;
model.sol('sol154').clearSolutionData;
model.sol('sol155').clearSolutionData;
model.sol('sol156').clearSolutionData;
model.sol('sol157').clearSolutionData;
model.sol('sol158').clearSolutionData;
model.sol('sol159').clearSolutionData;
model.sol('sol160').clearSolutionData;
model.sol('sol161').clearSolutionData;
model.sol('sol162').clearSolutionData;
model.sol('sol163').clearSolutionData;
model.sol('sol164').clearSolutionData;
model.sol('sol165').clearSolutionData;
model.sol('sol166').clearSolutionData;
model.sol('sol167').clearSolutionData;
model.sol('sol168').clearSolutionData;
model.sol('sol169').clearSolutionData;
model.sol('sol170').clearSolutionData;
model.sol('sol171').clearSolutionData;
model.sol('sol172').clearSolutionData;
model.sol('sol173').clearSolutionData;
model.sol('sol174').clearSolutionData;
model.sol('sol175').clearSolutionData;
model.sol('sol176').clearSolutionData;
model.sol('sol177').clearSolutionData;
model.sol('sol178').clearSolutionData;
model.sol('sol179').clearSolutionData;
model.sol('sol180').clearSolutionData;
model.sol('sol181').clearSolutionData;
model.sol('sol182').clearSolutionData;
model.sol('sol183').clearSolutionData;
model.sol('sol184').clearSolutionData;
model.sol('sol185').clearSolutionData;
model.sol('sol186').clearSolutionData;
model.sol('sol187').clearSolutionData;
model.sol('sol188').clearSolutionData;
model.sol('sol189').clearSolutionData;
model.sol('sol190').clearSolutionData;
model.sol('sol191').clearSolutionData;
model.sol('sol192').clearSolutionData;
model.sol('sol193').clearSolutionData;
model.sol('sol194').clearSolutionData;
model.sol('sol195').clearSolutionData;
model.sol('sol196').clearSolutionData;
model.sol('sol197').clearSolutionData;
model.sol('sol198').clearSolutionData;
model.sol('sol199').clearSolutionData;
model.sol('sol200').clearSolutionData;
model.sol('sol201').clearSolutionData;
model.sol('sol202').clearSolutionData;
model.sol('sol203').clearSolutionData;
model.sol('sol204').clearSolutionData;
model.sol('sol205').clearSolutionData;
model.sol('sol206').clearSolutionData;
model.sol('sol207').clearSolutionData;
model.sol('sol208').clearSolutionData;
model.sol('sol209').clearSolutionData;
model.sol('sol210').clearSolutionData;
model.sol('sol211').clearSolutionData;
model.sol('sol212').clearSolutionData;
model.sol('sol213').clearSolutionData;
model.sol('sol214').clearSolutionData;
model.sol('sol215').clearSolutionData;
model.sol('sol216').clearSolutionData;
model.sol('sol217').clearSolutionData;
model.sol('sol218').clearSolutionData;
model.sol('sol219').clearSolutionData;
model.sol('sol220').clearSolutionData;
model.sol('sol221').clearSolutionData;
model.sol('sol222').clearSolutionData;
model.sol('sol223').clearSolutionData;
model.sol('sol224').clearSolutionData;
model.sol('sol225').clearSolutionData;
model.sol('sol226').clearSolutionData;
model.sol('sol227').clearSolutionData;
model.sol('sol228').clearSolutionData;
model.sol('sol229').clearSolutionData;
model.sol('sol230').clearSolutionData;
model.sol('sol231').clearSolutionData;
model.sol('sol232').clearSolutionData;
model.sol('sol233').clearSolutionData;
model.sol('sol234').clearSolutionData;
model.sol('sol235').clearSolutionData;
model.sol('sol236').clearSolutionData;
model.sol('sol237').clearSolutionData;
model.sol('sol238').clearSolutionData;
model.sol('sol239').clearSolutionData;
model.sol('sol240').clearSolutionData;
model.sol('sol241').clearSolutionData;
model.sol('sol242').clearSolutionData;
model.sol('sol243').clearSolutionData;
model.sol('sol244').clearSolutionData;
model.sol('sol245').clearSolutionData;
model.sol('sol246').clearSolutionData;
model.sol('sol247').clearSolutionData;
model.sol('sol248').clearSolutionData;
model.sol('sol249').clearSolutionData;
model.sol('sol250').clearSolutionData;
model.sol('sol251').clearSolutionData;
model.sol('sol252').clearSolutionData;
model.sol('sol253').clearSolutionData;
model.sol('sol254').clearSolutionData;
model.sol('sol255').clearSolutionData;
model.sol('sol256').clearSolutionData;
model.sol('sol257').clearSolutionData;
model.sol('sol258').clearSolutionData;
model.sol('sol259').clearSolutionData;
model.sol('sol260').clearSolutionData;
model.sol('sol261').clearSolutionData;
model.sol('sol262').clearSolutionData;
model.sol('sol263').clearSolutionData;
model.sol('sol264').clearSolutionData;
model.sol('sol265').clearSolutionData;
model.sol('sol266').clearSolutionData;
model.sol('sol267').clearSolutionData;
model.sol('sol268').clearSolutionData;
model.sol('sol269').clearSolutionData;
model.sol('sol270').clearSolutionData;
model.sol('sol271').clearSolutionData;
model.sol('sol272').clearSolutionData;
model.sol('sol273').clearSolutionData;
model.sol('sol274').clearSolutionData;
model.sol('sol275').clearSolutionData;
model.sol('sol276').clearSolutionData;
model.sol('sol277').clearSolutionData;
model.sol('sol278').clearSolutionData;
model.sol('sol279').clearSolutionData;
model.sol('sol280').clearSolutionData;
model.sol('sol281').clearSolutionData;
model.sol('sol282').clearSolutionData;
model.sol('sol283').clearSolutionData;
model.sol('sol284').clearSolutionData;
model.sol('sol285').clearSolutionData;
model.sol('sol286').clearSolutionData;
model.sol('sol287').clearSolutionData;
model.sol('sol288').clearSolutionData;
model.sol('sol289').clearSolutionData;
model.sol('sol290').clearSolutionData;
model.sol('sol291').clearSolutionData;
model.sol('sol292').clearSolutionData;
model.sol('sol293').clearSolutionData;
model.sol('sol294').clearSolutionData;
model.sol('sol295').clearSolutionData;
model.sol('sol296').clearSolutionData;

model.label('linearOpticsTutorial.mph');

model.study('std1').feature('param3').setIndex('plistarr', '-12*pi/180', 0);
model.study('std1').feature('param3').setIndex('plistarr', '2e-6', 1);

model.component('comp1').physics('gop').feature('lwav2').active(false);

model.sol('sol1').study('std1');

model.study('std1').feature('rtrac').set('notlistsolnum', 1);
model.study('std1').feature('rtrac').set('notsolnum', '1');
model.study('std1').feature('rtrac').set('listsolnum', 1);
model.study('std1').feature('rtrac').set('solnum', '1');

model.sol('sol1').feature.remove('t1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
model.sol('sol1').create('st1', 'StudyStep');
model.sol('sol1').feature('st1').set('study', 'std1');
model.sol('sol1').feature('st1').set('studystep', 'rtrac');
model.sol('sol1').create('v1', 'Variables');
model.sol('sol1').feature('v1').set('control', 'rtrac');
model.sol('sol1').create('t1', 'Time');
model.sol('sol1').feature('t1').set('tlist', 'range(0,0.01,1)');
model.sol('sol1').feature('t1').set('plot', 'off');
model.sol('sol1').feature('t1').set('plotgroup', 'pg1');
model.sol('sol1').feature('t1').set('plotfreq', 'tout');
model.sol('sol1').feature('t1').set('probesel', 'all');
model.sol('sol1').feature('t1').set('probes', {});
model.sol('sol1').feature('t1').set('probefreq', 'tsteps');
model.sol('sol1').feature('t1').set('rtol', 1.0E-5);
model.sol('sol1').feature('t1').set('atolglobalvaluemethod', 'factor');
model.sol('sol1').feature('t1').set('tstepsgenalpha', 'strict');
model.sol('sol1').feature('t1').set('endtimeinterpolation', true);
model.sol('sol1').feature('t1').set('timemethod', 'genalpha');
model.sol('sol1').feature('t1').set('estrat', 'exclude');
model.sol('sol1').feature('t1').set('control', 'rtrac');
model.sol('sol1').feature('t1').create('fc1', 'FullyCoupled');
model.sol('sol1').feature('t1').feature('fc1').set('ntolfact', 0.1);
model.sol('sol1').feature('t1').create('i1', 'Iterative');
model.sol('sol1').feature('t1').feature('i1').set('linsolver', 'gmres');
model.sol('sol1').feature('t1').feature('i1').create('ja1', 'Jacobi');
model.sol('sol1').feature('t1').feature('fc1').set('linsolver', 'i1');
model.sol('sol1').feature('t1').feature('fc1').set('ntolfact', 0.1);
model.sol('sol1').feature('t1').feature.remove('fcDef');
model.sol('sol1').attach('std1');

model.batch('p1').feature.remove('so1');
model.batch('p1').create('so1', 'Solutionseq');
model.batch('p1').feature('so1').set('seq', 'sol1');
model.batch('p1').feature('so1').set('store', 'on');
model.batch('p1').feature('so1').set('clear', 'on');
model.batch('p1').feature('so1').set('psol', 'sol2');
model.batch('p1').set('pname', {'retAngle1' 'wallTkn' 'aAngle' 'wavelength' 'fracPolar'});
model.batch('p1').set('plistarr', {'-12*pi/180' '2e-6' 'range(0,0.1308996938995747,6.283185307179586)' 'range(4.0e-7,5.0e-8,6.5e-7)' '0'});
model.batch('p1').set('sweeptype', 'filled');
model.batch('p1').set('probesel', 'all');
model.batch('p1').set('probes', {});
model.batch('p1').set('plot', 'off');
model.batch('p1').set('err', 'on');
model.batch('p1').attach('std1');
model.batch('p1').set('control', 'param3');
model.batch('p1').run;

model.result('pg4').run;
model.result.table('tbl2').clearTableData;
model.result.numerical('ray2').set('table', 'tbl2');
model.result.numerical('ray2').setResult;

model.study('std1').feature('param3').setIndex('pname', 'pAngle', 5);
model.study('std1').feature('param3').setIndex('plistarr', '', 5);
model.study('std1').feature('param3').setIndex('punit', '', 5);
model.study('std1').feature('param3').setIndex('pname', 'pAngle', 5);
model.study('std1').feature('param3').setIndex('plistarr', '', 5);
model.study('std1').feature('param3').setIndex('punit', '', 5);
model.study('std1').feature('param3').setIndex('plistarr', '45*pi/180', 5);
model.study('std1').feature('param3').move('pname', [5], -1);
model.study('std1').feature('param3').move('plistarr', [5], -1);
model.study('std1').feature('param3').move('punit', [5], -1);
model.study('std1').feature('param3').move('pname', [4], -1);
model.study('std1').feature('param3').move('plistarr', [4], -1);
model.study('std1').feature('param3').move('punit', [4], -1);
model.study('std1').feature('param3').move('pname', [3], -1);
model.study('std1').feature('param3').move('plistarr', [3], -1);
model.study('std1').feature('param3').move('punit', [3], -1);
model.study('std1').feature('param3').move('pname', [2], -1);
model.study('std1').feature('param3').move('plistarr', [2], -1);
model.study('std1').feature('param3').move('punit', [2], -1);
model.study('std1').feature('param3').move('pname', [2], -1);
model.study('std1').feature('param3').move('plistarr', [2], -1);
model.study('std1').feature('param3').move('punit', [2], -1);
model.study('std1').feature('param3').setIndex('pname', '', 5);
model.study('std1').feature('param3').remove('pname', 5);
model.study('std1').feature('param3').remove('punit', 5);
model.study('std1').feature('param3').remove('plistarr', [5]);

model.sol('sol1').study('std1');

model.study('std1').feature('rtrac').set('notlistsolnum', 1);
model.study('std1').feature('rtrac').set('notsolnum', '1');
model.study('std1').feature('rtrac').set('listsolnum', 1);
model.study('std1').feature('rtrac').set('solnum', '1');

model.sol('sol1').feature.remove('t1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
model.sol('sol1').create('st1', 'StudyStep');
model.sol('sol1').feature('st1').set('study', 'std1');
model.sol('sol1').feature('st1').set('studystep', 'rtrac');
model.sol('sol1').create('v1', 'Variables');
model.sol('sol1').feature('v1').set('control', 'rtrac');
model.sol('sol1').create('t1', 'Time');
model.sol('sol1').feature('t1').set('tlist', 'range(0,0.01,1)');
model.sol('sol1').feature('t1').set('plot', 'off');
model.sol('sol1').feature('t1').set('plotgroup', 'pg1');
model.sol('sol1').feature('t1').set('plotfreq', 'tout');
model.sol('sol1').feature('t1').set('probesel', 'all');
model.sol('sol1').feature('t1').set('probes', {});
model.sol('sol1').feature('t1').set('probefreq', 'tsteps');
model.sol('sol1').feature('t1').set('rtol', 1.0E-5);
model.sol('sol1').feature('t1').set('atolglobalvaluemethod', 'factor');
model.sol('sol1').feature('t1').set('tstepsgenalpha', 'strict');
model.sol('sol1').feature('t1').set('endtimeinterpolation', true);
model.sol('sol1').feature('t1').set('timemethod', 'genalpha');
model.sol('sol1').feature('t1').set('estrat', 'exclude');
model.sol('sol1').feature('t1').set('control', 'rtrac');
model.sol('sol1').feature('t1').create('fc1', 'FullyCoupled');
model.sol('sol1').feature('t1').feature('fc1').set('ntolfact', 0.1);
model.sol('sol1').feature('t1').create('i1', 'Iterative');
model.sol('sol1').feature('t1').feature('i1').set('linsolver', 'gmres');
model.sol('sol1').feature('t1').feature('i1').create('ja1', 'Jacobi');
model.sol('sol1').feature('t1').feature('fc1').set('linsolver', 'i1');
model.sol('sol1').feature('t1').feature('fc1').set('ntolfact', 0.1);
model.sol('sol1').feature('t1').feature.remove('fcDef');
model.sol('sol1').attach('std1');

model.batch('p1').feature.remove('so1');
model.batch('p1').create('so1', 'Solutionseq');
model.batch('p1').feature('so1').set('seq', 'sol1');
model.batch('p1').feature('so1').set('store', 'on');
model.batch('p1').feature('so1').set('clear', 'on');
model.batch('p1').feature('so1').set('psol', 'sol2');
model.batch('p1').set('pname', {'retAngle1' 'wallTkn' 'pAngle' 'aAngle' 'wavelength'});
model.batch('p1').set('plistarr', {'-12*pi/180' '2e-6' '45*pi/180' 'range(0,0.1308996938995747,6.283185307179586)' 'range(4.0e-7,5.0e-8,6.5e-7)'});
model.batch('p1').set('sweeptype', 'filled');
model.batch('p1').set('probesel', 'all');
model.batch('p1').set('probes', {});
model.batch('p1').set('plot', 'off');
model.batch('p1').set('err', 'on');
model.batch('p1').attach('std1');
model.batch('p1').set('control', 'param3');
model.batch('p1').run;

model.result('pg4').run;
model.result.table('tbl2').clearTableData;
model.result.numerical('ray2').set('table', 'tbl2');
model.result.numerical('ray2').setResult;

model.study('std1').feature('param3').setIndex('plistarr', '', 3);
model.study('std1').feature('param3').setIndex('plistarr', 'range(0,0.1308996938995747,6.283185307179586)', 2);
model.study('std1').feature('param3').setIndex('plistarr', 'range(0,0.1308996938995747,6.283185307179586)', 2);
model.study('std1').feature('param3').setIndex('plistarr', '45*pi/180', 3);

model.sol('sol1').study('std1');

model.study('std1').feature('rtrac').set('notlistsolnum', 1);
model.study('std1').feature('rtrac').set('notsolnum', '1');
model.study('std1').feature('rtrac').set('listsolnum', 1);
model.study('std1').feature('rtrac').set('solnum', '1');

model.sol('sol1').feature.remove('t1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
model.sol('sol1').create('st1', 'StudyStep');
model.sol('sol1').feature('st1').set('study', 'std1');
model.sol('sol1').feature('st1').set('studystep', 'rtrac');
model.sol('sol1').create('v1', 'Variables');
model.sol('sol1').feature('v1').set('control', 'rtrac');
model.sol('sol1').create('t1', 'Time');
model.sol('sol1').feature('t1').set('tlist', 'range(0,0.01,1)');
model.sol('sol1').feature('t1').set('plot', 'off');
model.sol('sol1').feature('t1').set('plotgroup', 'pg1');
model.sol('sol1').feature('t1').set('plotfreq', 'tout');
model.sol('sol1').feature('t1').set('probesel', 'all');
model.sol('sol1').feature('t1').set('probes', {});
model.sol('sol1').feature('t1').set('probefreq', 'tsteps');
model.sol('sol1').feature('t1').set('rtol', 1.0E-5);
model.sol('sol1').feature('t1').set('atolglobalvaluemethod', 'factor');
model.sol('sol1').feature('t1').set('tstepsgenalpha', 'strict');
model.sol('sol1').feature('t1').set('endtimeinterpolation', true);
model.sol('sol1').feature('t1').set('timemethod', 'genalpha');
model.sol('sol1').feature('t1').set('estrat', 'exclude');
model.sol('sol1').feature('t1').set('control', 'rtrac');
model.sol('sol1').feature('t1').create('fc1', 'FullyCoupled');
model.sol('sol1').feature('t1').feature('fc1').set('ntolfact', 0.1);
model.sol('sol1').feature('t1').create('i1', 'Iterative');
model.sol('sol1').feature('t1').feature('i1').set('linsolver', 'gmres');
model.sol('sol1').feature('t1').feature('i1').create('ja1', 'Jacobi');
model.sol('sol1').feature('t1').feature('fc1').set('linsolver', 'i1');
model.sol('sol1').feature('t1').feature('fc1').set('ntolfact', 0.1);
model.sol('sol1').feature('t1').feature.remove('fcDef');
model.sol('sol1').attach('std1');

model.batch('p1').feature.remove('so1');
model.batch('p1').create('so1', 'Solutionseq');
model.batch('p1').feature('so1').set('seq', 'sol1');
model.batch('p1').feature('so1').set('store', 'on');
model.batch('p1').feature('so1').set('clear', 'on');
model.batch('p1').feature('so1').set('psol', 'sol2');
model.batch('p1').set('pname', {'retAngle1' 'wallTkn' 'pAngle' 'aAngle' 'wavelength'});
model.batch('p1').set('plistarr', {'-12*pi/180' '2e-6' 'range(0,0.1308996938995747,6.283185307179586)' '45*pi/180' 'range(4.0e-7,5.0e-8,6.5e-7)'});
model.batch('p1').set('sweeptype', 'filled');
model.batch('p1').set('probesel', 'all');
model.batch('p1').set('probes', {});
model.batch('p1').set('plot', 'off');
model.batch('p1').set('err', 'on');
model.batch('p1').attach('std1');
model.batch('p1').set('control', 'param3');
model.batch('p1').run;

model.result('pg4').run;
model.result.table('tbl2').clearTableData;
model.result.numerical('ray2').set('table', 'tbl2');
model.result.numerical('ray2').setResult;

model.study('std1').feature('param3').setIndex('pname', 'fracPolar', 5);
model.study('std1').feature('param3').setIndex('plistarr', '', 5);
model.study('std1').feature('param3').setIndex('punit', '', 5);
model.study('std1').feature('param3').setIndex('pname', 'fracPolar', 5);
model.study('std1').feature('param3').setIndex('plistarr', '', 5);
model.study('std1').feature('param3').setIndex('punit', '', 5);
model.study('std1').feature('param3').setIndex('plistarr', 0.4, 5);

model.sol('sol1').study('std1');

model.study('std1').feature('rtrac').set('notlistsolnum', 1);
model.study('std1').feature('rtrac').set('notsolnum', '1');
model.study('std1').feature('rtrac').set('listsolnum', 1);
model.study('std1').feature('rtrac').set('solnum', '1');

model.sol('sol1').feature.remove('t1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
model.sol('sol1').create('st1', 'StudyStep');
model.sol('sol1').feature('st1').set('study', 'std1');
model.sol('sol1').feature('st1').set('studystep', 'rtrac');
model.sol('sol1').create('v1', 'Variables');
model.sol('sol1').feature('v1').set('control', 'rtrac');
model.sol('sol1').create('t1', 'Time');
model.sol('sol1').feature('t1').set('tlist', 'range(0,0.01,1)');
model.sol('sol1').feature('t1').set('plot', 'off');
model.sol('sol1').feature('t1').set('plotgroup', 'pg1');
model.sol('sol1').feature('t1').set('plotfreq', 'tout');
model.sol('sol1').feature('t1').set('probesel', 'all');
model.sol('sol1').feature('t1').set('probes', {});
model.sol('sol1').feature('t1').set('probefreq', 'tsteps');
model.sol('sol1').feature('t1').set('rtol', 1.0E-5);
model.sol('sol1').feature('t1').set('atolglobalvaluemethod', 'factor');
model.sol('sol1').feature('t1').set('tstepsgenalpha', 'strict');
model.sol('sol1').feature('t1').set('endtimeinterpolation', true);
model.sol('sol1').feature('t1').set('timemethod', 'genalpha');
model.sol('sol1').feature('t1').set('estrat', 'exclude');
model.sol('sol1').feature('t1').set('control', 'rtrac');
model.sol('sol1').feature('t1').create('fc1', 'FullyCoupled');
model.sol('sol1').feature('t1').feature('fc1').set('ntolfact', 0.1);
model.sol('sol1').feature('t1').create('i1', 'Iterative');
model.sol('sol1').feature('t1').feature('i1').set('linsolver', 'gmres');
model.sol('sol1').feature('t1').feature('i1').create('ja1', 'Jacobi');
model.sol('sol1').feature('t1').feature('fc1').set('linsolver', 'i1');
model.sol('sol1').feature('t1').feature('fc1').set('ntolfact', 0.1);
model.sol('sol1').feature('t1').feature.remove('fcDef');
model.sol('sol1').attach('std1');

model.batch('p1').feature.remove('so1');
model.batch('p1').create('so1', 'Solutionseq');
model.batch('p1').feature('so1').set('seq', 'sol1');
model.batch('p1').feature('so1').set('store', 'on');
model.batch('p1').feature('so1').set('clear', 'on');
model.batch('p1').feature('so1').set('psol', 'sol2');
model.batch('p1').set('pname', {'retAngle1' 'wallTkn' 'pAngle' 'aAngle' 'wavelength' 'fracPolar'});
model.batch('p1').set('plistarr', {'-12*pi/180' '2e-6' 'range(0,0.1308996938995747,6.283185307179586)' '45*pi/180' 'range(4.0e-7,5.0e-8,6.5e-7)' '0.4'});
model.batch('p1').set('sweeptype', 'filled');
model.batch('p1').set('probesel', 'all');
model.batch('p1').set('probes', {});
model.batch('p1').set('plot', 'off');
model.batch('p1').set('err', 'on');
model.batch('p1').attach('std1');
model.batch('p1').set('control', 'param3');
model.batch('p1').run;

model.result('pg4').run;
model.result.table('tbl2').clearTableData;
model.result.numerical('ray2').set('table', 'tbl2');
model.result.numerical('ray2').setResult;
model.result.table('tbl2').removeColumn(5);
model.result.table('tbl2').clearTableData;

model.label('linearOpticsTutorial.mph');

model.sol('sol1').clearSolutionData;
model.sol('sol2').clearSolutionData;
model.sol('sol3').clearSolutionData;
model.sol('sol4').clearSolutionData;
model.sol('sol5').clearSolutionData;
model.sol('sol6').clearSolutionData;
model.sol('sol7').clearSolutionData;
model.sol('sol8').clearSolutionData;
model.sol('sol9').clearSolutionData;
model.sol('sol10').clearSolutionData;
model.sol('sol11').clearSolutionData;
model.sol('sol12').clearSolutionData;
model.sol('sol13').clearSolutionData;
model.sol('sol14').clearSolutionData;
model.sol('sol15').clearSolutionData;
model.sol('sol16').clearSolutionData;
model.sol('sol17').clearSolutionData;
model.sol('sol18').clearSolutionData;
model.sol('sol19').clearSolutionData;
model.sol('sol20').clearSolutionData;
model.sol('sol21').clearSolutionData;
model.sol('sol22').clearSolutionData;
model.sol('sol23').clearSolutionData;
model.sol('sol24').clearSolutionData;
model.sol('sol25').clearSolutionData;
model.sol('sol26').clearSolutionData;
model.sol('sol27').clearSolutionData;
model.sol('sol28').clearSolutionData;
model.sol('sol29').clearSolutionData;
model.sol('sol30').clearSolutionData;
model.sol('sol31').clearSolutionData;
model.sol('sol32').clearSolutionData;
model.sol('sol33').clearSolutionData;
model.sol('sol34').clearSolutionData;
model.sol('sol35').clearSolutionData;
model.sol('sol36').clearSolutionData;
model.sol('sol37').clearSolutionData;
model.sol('sol38').clearSolutionData;
model.sol('sol39').clearSolutionData;
model.sol('sol40').clearSolutionData;
model.sol('sol41').clearSolutionData;
model.sol('sol42').clearSolutionData;
model.sol('sol43').clearSolutionData;
model.sol('sol44').clearSolutionData;
model.sol('sol45').clearSolutionData;
model.sol('sol46').clearSolutionData;
model.sol('sol47').clearSolutionData;
model.sol('sol48').clearSolutionData;
model.sol('sol49').clearSolutionData;
model.sol('sol50').clearSolutionData;
model.sol('sol51').clearSolutionData;
model.sol('sol52').clearSolutionData;
model.sol('sol53').clearSolutionData;
model.sol('sol54').clearSolutionData;
model.sol('sol55').clearSolutionData;
model.sol('sol56').clearSolutionData;
model.sol('sol57').clearSolutionData;
model.sol('sol58').clearSolutionData;
model.sol('sol59').clearSolutionData;
model.sol('sol60').clearSolutionData;
model.sol('sol61').clearSolutionData;
model.sol('sol62').clearSolutionData;
model.sol('sol63').clearSolutionData;
model.sol('sol64').clearSolutionData;
model.sol('sol65').clearSolutionData;
model.sol('sol66').clearSolutionData;
model.sol('sol67').clearSolutionData;
model.sol('sol68').clearSolutionData;
model.sol('sol69').clearSolutionData;
model.sol('sol70').clearSolutionData;
model.sol('sol71').clearSolutionData;
model.sol('sol72').clearSolutionData;
model.sol('sol73').clearSolutionData;
model.sol('sol74').clearSolutionData;
model.sol('sol75').clearSolutionData;
model.sol('sol76').clearSolutionData;
model.sol('sol77').clearSolutionData;
model.sol('sol78').clearSolutionData;
model.sol('sol79').clearSolutionData;
model.sol('sol80').clearSolutionData;
model.sol('sol81').clearSolutionData;
model.sol('sol82').clearSolutionData;
model.sol('sol83').clearSolutionData;
model.sol('sol84').clearSolutionData;
model.sol('sol85').clearSolutionData;
model.sol('sol86').clearSolutionData;
model.sol('sol87').clearSolutionData;
model.sol('sol88').clearSolutionData;
model.sol('sol89').clearSolutionData;
model.sol('sol90').clearSolutionData;
model.sol('sol91').clearSolutionData;
model.sol('sol92').clearSolutionData;
model.sol('sol93').clearSolutionData;
model.sol('sol94').clearSolutionData;
model.sol('sol95').clearSolutionData;
model.sol('sol96').clearSolutionData;
model.sol('sol97').clearSolutionData;
model.sol('sol98').clearSolutionData;
model.sol('sol99').clearSolutionData;
model.sol('sol100').clearSolutionData;
model.sol('sol101').clearSolutionData;
model.sol('sol102').clearSolutionData;
model.sol('sol103').clearSolutionData;
model.sol('sol104').clearSolutionData;
model.sol('sol105').clearSolutionData;
model.sol('sol106').clearSolutionData;
model.sol('sol107').clearSolutionData;
model.sol('sol108').clearSolutionData;
model.sol('sol109').clearSolutionData;
model.sol('sol110').clearSolutionData;
model.sol('sol111').clearSolutionData;
model.sol('sol112').clearSolutionData;
model.sol('sol113').clearSolutionData;
model.sol('sol114').clearSolutionData;
model.sol('sol115').clearSolutionData;
model.sol('sol116').clearSolutionData;
model.sol('sol117').clearSolutionData;
model.sol('sol118').clearSolutionData;
model.sol('sol119').clearSolutionData;
model.sol('sol120').clearSolutionData;
model.sol('sol121').clearSolutionData;
model.sol('sol122').clearSolutionData;
model.sol('sol123').clearSolutionData;
model.sol('sol124').clearSolutionData;
model.sol('sol125').clearSolutionData;
model.sol('sol126').clearSolutionData;
model.sol('sol127').clearSolutionData;
model.sol('sol128').clearSolutionData;
model.sol('sol129').clearSolutionData;
model.sol('sol130').clearSolutionData;
model.sol('sol131').clearSolutionData;
model.sol('sol132').clearSolutionData;
model.sol('sol133').clearSolutionData;
model.sol('sol134').clearSolutionData;
model.sol('sol135').clearSolutionData;
model.sol('sol136').clearSolutionData;
model.sol('sol137').clearSolutionData;
model.sol('sol138').clearSolutionData;
model.sol('sol139').clearSolutionData;
model.sol('sol140').clearSolutionData;
model.sol('sol141').clearSolutionData;
model.sol('sol142').clearSolutionData;
model.sol('sol143').clearSolutionData;
model.sol('sol144').clearSolutionData;
model.sol('sol145').clearSolutionData;
model.sol('sol146').clearSolutionData;
model.sol('sol147').clearSolutionData;
model.sol('sol148').clearSolutionData;
model.sol('sol149').clearSolutionData;
model.sol('sol150').clearSolutionData;
model.sol('sol151').clearSolutionData;
model.sol('sol152').clearSolutionData;
model.sol('sol153').clearSolutionData;
model.sol('sol154').clearSolutionData;
model.sol('sol155').clearSolutionData;
model.sol('sol156').clearSolutionData;
model.sol('sol157').clearSolutionData;
model.sol('sol158').clearSolutionData;
model.sol('sol159').clearSolutionData;
model.sol('sol160').clearSolutionData;
model.sol('sol161').clearSolutionData;
model.sol('sol162').clearSolutionData;
model.sol('sol163').clearSolutionData;
model.sol('sol164').clearSolutionData;
model.sol('sol165').clearSolutionData;
model.sol('sol166').clearSolutionData;
model.sol('sol167').clearSolutionData;
model.sol('sol168').clearSolutionData;
model.sol('sol169').clearSolutionData;
model.sol('sol170').clearSolutionData;
model.sol('sol171').clearSolutionData;
model.sol('sol172').clearSolutionData;
model.sol('sol173').clearSolutionData;
model.sol('sol174').clearSolutionData;
model.sol('sol175').clearSolutionData;
model.sol('sol176').clearSolutionData;
model.sol('sol177').clearSolutionData;
model.sol('sol178').clearSolutionData;
model.sol('sol179').clearSolutionData;
model.sol('sol180').clearSolutionData;
model.sol('sol181').clearSolutionData;
model.sol('sol182').clearSolutionData;
model.sol('sol183').clearSolutionData;
model.sol('sol184').clearSolutionData;
model.sol('sol185').clearSolutionData;
model.sol('sol186').clearSolutionData;
model.sol('sol187').clearSolutionData;
model.sol('sol188').clearSolutionData;
model.sol('sol189').clearSolutionData;
model.sol('sol190').clearSolutionData;
model.sol('sol191').clearSolutionData;
model.sol('sol192').clearSolutionData;
model.sol('sol193').clearSolutionData;
model.sol('sol194').clearSolutionData;
model.sol('sol195').clearSolutionData;
model.sol('sol196').clearSolutionData;
model.sol('sol197').clearSolutionData;
model.sol('sol198').clearSolutionData;
model.sol('sol199').clearSolutionData;
model.sol('sol200').clearSolutionData;
model.sol('sol201').clearSolutionData;
model.sol('sol202').clearSolutionData;
model.sol('sol203').clearSolutionData;
model.sol('sol204').clearSolutionData;
model.sol('sol205').clearSolutionData;
model.sol('sol206').clearSolutionData;
model.sol('sol207').clearSolutionData;
model.sol('sol208').clearSolutionData;
model.sol('sol209').clearSolutionData;
model.sol('sol210').clearSolutionData;
model.sol('sol211').clearSolutionData;
model.sol('sol212').clearSolutionData;
model.sol('sol213').clearSolutionData;
model.sol('sol214').clearSolutionData;
model.sol('sol215').clearSolutionData;
model.sol('sol216').clearSolutionData;
model.sol('sol217').clearSolutionData;
model.sol('sol218').clearSolutionData;
model.sol('sol219').clearSolutionData;
model.sol('sol220').clearSolutionData;
model.sol('sol221').clearSolutionData;
model.sol('sol222').clearSolutionData;
model.sol('sol223').clearSolutionData;
model.sol('sol224').clearSolutionData;
model.sol('sol225').clearSolutionData;
model.sol('sol226').clearSolutionData;
model.sol('sol227').clearSolutionData;
model.sol('sol228').clearSolutionData;
model.sol('sol229').clearSolutionData;
model.sol('sol230').clearSolutionData;
model.sol('sol231').clearSolutionData;
model.sol('sol232').clearSolutionData;
model.sol('sol233').clearSolutionData;
model.sol('sol234').clearSolutionData;
model.sol('sol235').clearSolutionData;
model.sol('sol236').clearSolutionData;
model.sol('sol237').clearSolutionData;
model.sol('sol238').clearSolutionData;
model.sol('sol239').clearSolutionData;
model.sol('sol240').clearSolutionData;
model.sol('sol241').clearSolutionData;
model.sol('sol242').clearSolutionData;
model.sol('sol243').clearSolutionData;
model.sol('sol244').clearSolutionData;
model.sol('sol245').clearSolutionData;
model.sol('sol246').clearSolutionData;
model.sol('sol247').clearSolutionData;
model.sol('sol248').clearSolutionData;
model.sol('sol249').clearSolutionData;
model.sol('sol250').clearSolutionData;
model.sol('sol251').clearSolutionData;
model.sol('sol252').clearSolutionData;
model.sol('sol253').clearSolutionData;
model.sol('sol254').clearSolutionData;
model.sol('sol255').clearSolutionData;
model.sol('sol256').clearSolutionData;
model.sol('sol257').clearSolutionData;
model.sol('sol258').clearSolutionData;
model.sol('sol259').clearSolutionData;
model.sol('sol260').clearSolutionData;
model.sol('sol261').clearSolutionData;
model.sol('sol262').clearSolutionData;
model.sol('sol263').clearSolutionData;
model.sol('sol264').clearSolutionData;
model.sol('sol265').clearSolutionData;
model.sol('sol266').clearSolutionData;
model.sol('sol267').clearSolutionData;
model.sol('sol268').clearSolutionData;
model.sol('sol269').clearSolutionData;
model.sol('sol270').clearSolutionData;
model.sol('sol271').clearSolutionData;
model.sol('sol272').clearSolutionData;
model.sol('sol273').clearSolutionData;
model.sol('sol274').clearSolutionData;
model.sol('sol275').clearSolutionData;
model.sol('sol276').clearSolutionData;
model.sol('sol277').clearSolutionData;
model.sol('sol278').clearSolutionData;
model.sol('sol279').clearSolutionData;
model.sol('sol280').clearSolutionData;
model.sol('sol281').clearSolutionData;
model.sol('sol282').clearSolutionData;
model.sol('sol283').clearSolutionData;
model.sol('sol284').clearSolutionData;
model.sol('sol285').clearSolutionData;
model.sol('sol286').clearSolutionData;
model.sol('sol287').clearSolutionData;
model.sol('sol288').clearSolutionData;
model.sol('sol289').clearSolutionData;
model.sol('sol290').clearSolutionData;
model.sol('sol291').clearSolutionData;
model.sol('sol292').clearSolutionData;
model.sol('sol293').clearSolutionData;
model.sol('sol294').clearSolutionData;
model.sol('sol295').clearSolutionData;
model.sol('sol296').clearSolutionData;

model.label('linearOpticsTutorial.mph');

model.component('comp1').physics('gop').feature('lwav1').active(false);

model.sol('sol1').study('std1');

model.study('std1').feature('rtrac').set('notlistsolnum', 1);
model.study('std1').feature('rtrac').set('notsolnum', '1');
model.study('std1').feature('rtrac').set('listsolnum', 1);
model.study('std1').feature('rtrac').set('solnum', '1');

model.sol('sol1').feature.remove('t1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
model.sol('sol1').create('st1', 'StudyStep');
model.sol('sol1').feature('st1').set('study', 'std1');
model.sol('sol1').feature('st1').set('studystep', 'rtrac');
model.sol('sol1').create('v1', 'Variables');
model.sol('sol1').feature('v1').set('control', 'rtrac');
model.sol('sol1').create('t1', 'Time');
model.sol('sol1').feature('t1').set('tlist', 'range(0,0.01,1)');
model.sol('sol1').feature('t1').set('plot', 'off');
model.sol('sol1').feature('t1').set('plotgroup', 'pg1');
model.sol('sol1').feature('t1').set('plotfreq', 'tout');
model.sol('sol1').feature('t1').set('probesel', 'all');
model.sol('sol1').feature('t1').set('probes', {});
model.sol('sol1').feature('t1').set('probefreq', 'tsteps');
model.sol('sol1').feature('t1').set('rtol', 1.0E-5);
model.sol('sol1').feature('t1').set('atolglobalvaluemethod', 'factor');
model.sol('sol1').feature('t1').set('tstepsgenalpha', 'strict');
model.sol('sol1').feature('t1').set('endtimeinterpolation', true);
model.sol('sol1').feature('t1').set('timemethod', 'genalpha');
model.sol('sol1').feature('t1').set('estrat', 'exclude');
model.sol('sol1').feature('t1').set('control', 'rtrac');
model.sol('sol1').feature('t1').create('fc1', 'FullyCoupled');
model.sol('sol1').feature('t1').feature('fc1').set('ntolfact', 0.1);
model.sol('sol1').feature('t1').create('i1', 'Iterative');
model.sol('sol1').feature('t1').feature('i1').set('linsolver', 'gmres');
model.sol('sol1').feature('t1').feature('i1').create('ja1', 'Jacobi');
model.sol('sol1').feature('t1').feature('fc1').set('linsolver', 'i1');
model.sol('sol1').feature('t1').feature('fc1').set('ntolfact', 0.1);
model.sol('sol1').feature('t1').feature.remove('fcDef');
model.sol('sol1').attach('std1');

model.batch('p1').feature.remove('so1');
model.batch('p1').create('so1', 'Solutionseq');
model.batch('p1').feature('so1').set('seq', 'sol1');
model.batch('p1').feature('so1').set('store', 'on');
model.batch('p1').feature('so1').set('clear', 'on');
model.batch('p1').feature('so1').set('psol', 'sol2');
model.batch('p1').set('pname', {'retAngle1' 'wallTkn' 'pAngle' 'aAngle' 'wavelength' 'fracPolar'});
model.batch('p1').set('plistarr', {'-12*pi/180' '2e-6' 'range(0,0.1308996938995747,6.283185307179586)' '45*pi/180' 'range(4.0e-7,5.0e-8,6.5e-7)' '0.4'});
model.batch('p1').set('sweeptype', 'filled');
model.batch('p1').set('probesel', 'all');
model.batch('p1').set('probes', {});
model.batch('p1').set('plot', 'off');
model.batch('p1').set('err', 'on');
model.batch('p1').attach('std1');
model.batch('p1').set('control', 'param3');
model.batch('p1').run;

model.result('pg4').run;

out = model;
