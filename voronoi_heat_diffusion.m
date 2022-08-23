size = 20;                       % 1m divide by size
heat_source_x = 0.5;             %on meter scale
heat_source_y = 0.5;
no_of_it = 300;

ht_x = heat_source_x/size;
ht_y = heat_source_y/size;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% generate random numbers %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

b = '_';
c = '\';

pick = 0;
random_no = zeros(100,1);
for i = 1:1000
    random_no(i,1) = rand(1);
    random_no(i,1) = random_no(i,1)*10;
    random_no(i,1) = floor(random_no(i,1));
end

l = 0;
for i = 2:100
    if random_no(i-l,1) == random_no(i-1-l,1)
        random_no(i-l,:) = [];
        l = l+1;
    end
end

random_no = random_no*10;

ran_no = length(random_no);

for n = 7:15
    no_cells = num2str(n);
    x_it = zeros(no_of_it,n);
    y_it = zeros(no_of_it,n);
    for i = 1:no_of_it
        x_it(i,:) = rand([1 n]);
        y_it(i,:) = rand([1 n]);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%% create directory %%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    for iteration = 1:no_of_it
        itr = num2str(iteration);
        folder_name = strcat(no_cells,b,itr);
        folder = mkdir(folder_name);
        path1 = 'C:\Users\Nishi\Desktop\New folder\';
        path2 = folder_name;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%% import model %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        import com.comsol.model.*
        import com.comsol.model.util.*
        
        model = ModelUtil.create('Model17');
        
        model.modelPath('D:\comsol');
        
        model.component.create('comp1', true);
        
        model.component('comp1').geom.create('geom1', 2);
        
        model.component('comp1').mesh.create('mesh1');
        
        model.component('comp1').physics.create('ht', 'HeatTransfer', 'geom1');
        
        model.study.create('std1');
        model.study('std1').setGenConv(true);
        model.study('std1').create('time', 'Transient');
        model.study('std1').feature('time').activate('ht', true);
        rng default;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%% Geometry %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        x = x_it(iteration,:);
        y = y_it(iteration,:);
        voronoi(x,y);
        axis equal
        [vx,vy] = voronoi(x,y);
        
        a1 = vx';
        a = length(a1);
        
        for i = 1:a
            for j = 1:2
                if vx(j,i) < 0 || vx(j,i) > 1 || vy(j,i) < 0 || vy(j,i) > 1
                    it = [];
                    it(1,1) = 0;
                    it(1,2) = ((vy(1,i)-vy(2,i))*(-1*(vx(1,i)))/(vx(1,i)-vx(2,i)))+vy(1,i);
                    it(2,1) = ((vx(1,i)-vx(2,i))*(-1*(vy(1,i)))/(vy(1,i)-vy(2,i)))+vx(1,i);
                    it(2,2) = 0;
                    it(3,1) = 1;
                    it(3,2) = ((vy(1,i)-vy(2,i))*(1-(vx(1,i)))/(vx(1,i)-vx(2,i)))+vy(1,i);
                    it(4,1) = ((vx(1,i)-vx(2,i))*(1-(vy(1,i)))/(vy(1,i)-vy(2,i)))+vx(1,i);
                    it(4,2) = 1;
                    dist = [];
                    for k = 1:4
                        dist(1,k) = sqrt((vx(j,i) - it(k,1))^2 + (vy(j,i) - it(k,2))^2);
                    end
                    
                    for k =1:4
                        if it(k,1)< 0 || it(k,1) >1 || it(k,2)<0 || it(k,2)>1
                            dist(1,k) = 100000;
                        end
                    end
                    
                    if dist(1,1) ==100000 && dist(1,2) == 100000 && dist(1,3) == 100000 && dist(1,4) ==100000
                        vx(:,i) = 0;
                        vy(:,i) = 0;
                        
                    end
                    
                    min = 1000;
                    for k = 1:4
                        if dist(1,k) < min
                            min = dist(1,k);
                            change = k;
                            vx(j,i) = it(change,1);
                            vy(j,i) = it(change,2);
                        end
                    end
                end
            end
        end
        
        l = 0;
        for i = 1:a
            if vx(1,i-l) == 0 && vx(2,i-l) == 0
                vx(:,i-l) = [];
                vy(:,i-l) = [];
                l = l+1;
            end
        end
        
        a1 = vx';
        a = length(a1);
        l = 0;
        for i = 1:a
            if vx(1,i-l) == vx(2,i-l) || vy(1,i-l) == vy(2,i-l)
                vx(:,i-l) = [];
                vy(:,i-l) = [];
                l = l+1;
            end
        end
        a1 = vx';
        a = length(a1);
        next = 1;
        points =[];
        for i = 1:a
            points(next,1) = vx(1,i);
            points(next,2) = vy(1,i);
            points(next+1,1) = vx(2,i);
            points(next+1,2) = vy(2,i);
            next = next+2;
        end
        
        a1 = length(points);
        points_copy = points;
        
        points = zeros(a1,2);
        
        for i = 1:a1
            min = points_copy(i,1);
            
            for j = 1:a1
                if points_copy(j,1) <= min
                    min = points_copy(j,1);
                    asd = j;
                end
            end
            points(i,:) = points_copy(asd,:);
            points_copy(asd,1) = 10;
        end
        points_copy = points;
        
        p_c(1,1) = 0;
        p_c(1,2) = 0;
        for i = 1:a1
            p_c(i+1,:) = points(i,:);
        end
        
        p_c(a1+2,:) =0;
        
        a1 = length(p_c);
        
        for i = 2:a1-1
            if p_c(i,1)~= 0 && p_c(i,1)~= 1
                if p_c(i,2)~=0 && p_c(i,2) ~= 1
                    if p_c(i,1) ~= p_c(i-1,1) && p_c(i,2) ~= p_c(i+1,2)
                        for j = 1:a
                            for m = 1:2
                                if p_c(i,1) == vx(m,j)
                                    it = [];
                                    it(1,1) = 0;
                                    it(1,2) = ((vy(1,j)-vy(2,j))*(-1*(vx(1,j)))/(vx(1,j)-vx(2,j)))+vy(1,j);
                                    it(2,1) = ((vx(1,j)-vx(2,j))*(-1*(vy(1,j)))/(vy(1,j)-vy(2,j)))+vx(1,j);
                                    it(2,2) = 0;
                                    it(3,1) = 1;
                                    it(3,2) = ((vy(1,j)-vy(2,j))*(1-(vx(1,j)))/(vx(1,j)-vx(2,j)))+vy(1,j);
                                    it(4,1) = ((vx(1,j)-vx(2,j))*(1-(vy(1,j)))/(vy(1,j)-vy(2,j)))+vx(1,j);
                                    it(4,2) = 1;
                                    dist = [];
                                    for k = 1:4
                                        dist(1,k) = sqrt((vx(m,j) - it(k,1))^2 + (vy(m,j) - it(k,2))^2);
                                    end
                                    
                                    for k =1:4
                                        if it(k,1)< 0 || it(k,1) >1 || it(k,2)<0 || it(k,2)>1
                                            dist(1,k) = 1000000;
                                        end
                                    end                      
                                    
                                    min = 1000;
                                    for k = 1:4
                                        if dist(1,k) < min
                                            min = dist(1,k);
                                            change = k;
                                            vx(m,j) = it(change,1);
                                            vy(m,j) = it(change,2);
                                        end
                                    end
                                    
                                end
                            end
                        end
                    end
                end
            end
        end
               
        vx = vx/size;
        vy = vy/size;
        
        a1 = vx';
        a = length(a1);
        
        model.component('comp1').geom('geom1').create('sq1', 'Square');
        model.component('comp1').geom('geom1').feature('sq1').set('type', 'solid');
        model.component('comp1').geom('geom1').feature('sq1').set('base', 'corner');
        model.component('comp1').geom('geom1').feature('sq1').set('pos', [0 0]);
        model.component('comp1').geom('geom1').feature('sq1').set('size', 1/size);
        model.component('comp1').geom('geom1').run('sq1');
        model.component('comp1').geom('geom1').create('pt1', 'Point');
        
        model.component('comp1').geom('geom1').feature('pt1').setIndex('p', ht_x, 0);
        model.component('comp1').geom('geom1').feature('pt1').setIndex('p', ht_y, 1);
        
        next = 1;
        points =[];
        for i = 1:a
            points(next,1) = vx(1,i);
            points(next,2) = vy(1,i);
            points(next+1,1) = vx(2,i);
            points(next+1,2) = vy(2,i);
            next = next+2;
        end
        
        a1 = length(points);
        points(a1+1,1) = ht_x;
        points(a1+1,2) = ht_y;
        points_copy = points;
        
        points = zeros(a1+1,2);
        
        for i = 1:a1+1
            min = points_copy(i,1);
            
            for j = 1:a1+1
                if points_copy(j,1) <= min
                    min = points_copy(j,1);
                    asd = j;
                end
            end
            points(i,:) = points_copy(asd,:);
            points_copy(asd,1) = 10;
        end
        points_copy = points;
        
        
        a1 = length(points);
        
        for i = 2:a1
            if points_copy(i,1) == points_copy(i-1,1)
                if points_copy(i,2) == points_copy(i-1,2)
                    
                    points(i,:) = 0;
                end
            end
        end
        
        l = 0;
        for i = 1:a1
            if points(i-l,1) == 0
                if points(i-l,2) == 0
                    points(i-l,:) =[];
                    l = l+1;
                end
            end
        end
        
        a1 = length(points);
        for i = 1:a1
            if ht_x == points(i,1)
                ht_source = i+2;
            end
        end
      
        model.component('comp1').geom('geom1').run('pt1');
        
        initial = 'a';
        for i = 1:a
            line_no = num2str(i);
            abc = strcat(initial,line_no);
            x1 = vx(1,i);
            x2 = vx(2,i);
            y1 = vy(1,i);
            y2 = vy(2,i);
            model.component('comp1').geom('geom1').feature.create(abc, 'BezierPolygon');
            model.component('comp1').geom('geom1').feature(abc).set('type', 'solid');
            model.component('comp1').geom('geom1').feature(abc).set('p', [x1 x2; y1 y2]);
            model.component('comp1').geom('geom1').feature(abc).set('w', [1 1]);
            model.component('comp1').geom('geom1').feature(abc).set('degree', 1);
            model.component('comp1').geom('geom1').run(abc);
            model.component('comp1').geom('geom1').run;
        end
        
        model.component('comp1').physics('ht').create('solid2', 'SolidHeatTransferModel', 2);
        model.component('comp1').geom('geom1').run;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%% Define cord systems %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        for i = 0:10:90
            angle = num2str(i);
            nishi = strcat(initial,angle);
            
            model.component('comp1').coordSystem.create(nishi, 'Rotated');
            model.component('comp1').coordSystem(nishi).set('angle', {angle});
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%% create solid and physics %%%%%%%%%%%%%%%%%%%%%%%%%%$
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        for i = 1:n
            solid_no = num2str(i);
            abc = strcat(initial,solid_no);
            
            model.component('comp1').physics('ht').create(abc, 'SolidHeatTransferModel', 2);
            model.component('comp1').physics('ht').feature(abc).selection.set([i]);
            
            pick = pick+1;
            if pick == ran_no+1
                pick =1;
            end
            pick1 = random_no(pick,1);
            pick_str = num2str(pick1);
            nishi1 = strcat(initial,pick_str);
            
            model.component('comp1').physics('ht').feature(abc).set('coordinateSystem', nishi1);
            model.component('comp1').physics('ht').feature(abc).set('k_mat', 'userdef');
            model.component('comp1').physics('ht').feature(abc).set('k', [50 0 0 0 200 0 0 0 0]);
            model.component('comp1').physics('ht').feature(abc).set('rho_mat', 'userdef');
            model.component('comp1').physics('ht').feature(abc).set('rho', 7850);
            model.component('comp1').physics('ht').feature(abc).set('Cp_mat', 'userdef');
            model.component('comp1').physics('ht').feature(abc).set('Cp', 445);
        end
        
        model.component('comp1').physics('ht').create('lihs1', 'LineHeatSource', 0);
        model.component('comp1').physics('ht').feature('lihs1').selection.set([ht_source]);
        model.component('comp1').physics('ht').feature('lihs1').set('Ql', 10000);
        
        model.component('comp1').mesh('mesh1').run;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%% solution %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        model.study('std1').feature('time').set('tunit', 's'); % time unit
        model.study('std1').feature('time').set('tlist', 'range(0,0.05,10)'); %time range
        
        model.sol.create('sol1');
        model.sol('sol1').study('std1');
        
        model.study('std1').feature('time').set('notlistsolnum', 1);
        model.study('std1').feature('time').set('notsolnum', '1');
        model.study('std1').feature('time').set('listsolnum', 1);
        model.study('std1').feature('time').set('solnum', '1');
        
        model.sol('sol1').create('st1', 'StudyStep');
        model.sol('sol1').feature('st1').set('study', 'std1');
        model.sol('sol1').feature('st1').set('studystep', 'time');
        model.sol('sol1').create('v1', 'Variables');
        model.sol('sol1').feature('v1').set('control', 'time');
        model.sol('sol1').create('t1', 'Time');
        model.sol('sol1').feature('t1').set('tlist', 'range(0,0.05,10)');
        model.sol('sol1').feature('t1').set('plot', 'off');
        model.sol('sol1').feature('t1').set('plotgroup', 'Default');
        model.sol('sol1').feature('t1').set('plotfreq', 'tout');
        model.sol('sol1').feature('t1').set('probesel', 'all');
        model.sol('sol1').feature('t1').set('probes', {});
        model.sol('sol1').feature('t1').set('probefreq', 'tsteps');
        model.sol('sol1').feature('t1').set('atolglobalvaluemethod', 'factor');
        model.sol('sol1').feature('t1').set('atolmethod', {'comp1_T' 'global'});
        model.sol('sol1').feature('t1').set('atol', {'comp1_T' '1e-3'});
        model.sol('sol1').feature('t1').set('atolvaluemethod', {'comp1_T' 'factor'});
        model.sol('sol1').feature('t1').set('estrat', 'exclude');
        model.sol('sol1').feature('t1').set('maxorder', 2);
        model.sol('sol1').feature('t1').set('control', 'time');
        model.sol('sol1').feature('t1').create('fc1', 'FullyCoupled');
        model.sol('sol1').feature('t1').feature('fc1').set('jtech', 'once');
        model.sol('sol1').feature('t1').feature('fc1').set('damp', 0.9);
        model.sol('sol1').feature('t1').feature('fc1').set('maxiter', 5);
        model.sol('sol1').feature('t1').feature('fc1').set('stabacc', 'aacc');
        model.sol('sol1').feature('t1').feature('fc1').set('aaccdim', 5);
        model.sol('sol1').feature('t1').feature('fc1').set('aaccmix', 0.9);
        model.sol('sol1').feature('t1').feature('fc1').set('aaccdelay', 1);
        model.sol('sol1').feature('t1').create('d1', 'Direct');
        model.sol('sol1').feature('t1').feature('d1').set('linsolver', 'pardiso');
        model.sol('sol1').feature('t1').feature('d1').set('pivotperturb', 1.0E-13);
        model.sol('sol1').feature('t1').feature('d1').label('PARDISO (ht)');
        model.sol('sol1').feature('t1').create('i1', 'Iterative');
        model.sol('sol1').feature('t1').feature('i1').set('linsolver', 'gmres');
        model.sol('sol1').feature('t1').feature('i1').set('prefuntype', 'left');
        model.sol('sol1').feature('t1').feature('i1').set('rhob', 400);
        model.sol('sol1').feature('t1').feature('i1').label('Algebraic Multigrid (ht)');
        model.sol('sol1').feature('t1').feature('i1').create('mg1', 'Multigrid');
        model.sol('sol1').feature('t1').feature('i1').feature('mg1').set('prefun', 'saamg');
        model.sol('sol1').feature('t1').feature('i1').feature('mg1').set('usesmooth', false);
        model.sol('sol1').feature('t1').feature('i1').feature('mg1').set('saamgcompwise', true);
        model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('pr').create('so1', 'SOR');
        model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('pr').feature('so1').set('iter', 2);
        model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('pr').feature('so1').set('relax', 0.9);
        model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('po').create('so1', 'SOR');
        model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('po').feature('so1').set('iter', 2);
        model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('po').feature('so1').set('relax', 0.9);
        model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('cs').create('d1', 'Direct');
        model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('cs').feature('d1').set('linsolver', 'pardiso');
        model.sol('sol1').feature('t1').create('i2', 'Iterative');
        model.sol('sol1').feature('t1').feature('i2').set('linsolver', 'gmres');
        model.sol('sol1').feature('t1').feature('i2').set('prefuntype', 'left');
        model.sol('sol1').feature('t1').feature('i2').set('rhob', 20);
        model.sol('sol1').feature('t1').feature('i2').label('Geometric Multigrid (ht)');
        model.sol('sol1').feature('t1').feature('i2').create('mg1', 'Multigrid');
        model.sol('sol1').feature('t1').feature('i2').feature('mg1').set('prefun', 'gmg');
        model.sol('sol1').feature('t1').feature('i2').feature('mg1').set('mcasegen', 'any');
        model.sol('sol1').feature('t1').feature('i2').feature('mg1').feature('pr').create('so1', 'SOR');
        model.sol('sol1').feature('t1').feature('i2').feature('mg1').feature('pr').feature('so1').set('iter', 2);
        model.sol('sol1').feature('t1').feature('i2').feature('mg1').feature('po').create('so1', 'SOR');
        model.sol('sol1').feature('t1').feature('i2').feature('mg1').feature('po').feature('so1').set('iter', 2);
        model.sol('sol1').feature('t1').feature('i2').feature('mg1').feature('cs').create('d1', 'Direct');
        model.sol('sol1').feature('t1').feature('i2').feature('mg1').feature('cs').feature('d1').set('linsolver', 'pardiso');
        model.sol('sol1').feature('t1').feature('fc1').set('linsolver', 'd1');
        model.sol('sol1').feature('t1').feature('fc1').set('jtech', 'once');
        model.sol('sol1').feature('t1').feature('fc1').set('damp', 0.9);
        model.sol('sol1').feature('t1').feature('fc1').set('maxiter', 5);
        model.sol('sol1').feature('t1').feature('fc1').set('stabacc', 'aacc');
        model.sol('sol1').feature('t1').feature('fc1').set('aaccdim', 5);
        model.sol('sol1').feature('t1').feature('fc1').set('aaccmix', 0.9);
        model.sol('sol1').feature('t1').feature('fc1').set('aaccdelay', 1);
        model.sol('sol1').feature('t1').feature.remove('fcDef');
        model.sol('sol1').attach('std1');
        
        model.result.create('pg1', 'PlotGroup2D');
        model.result('pg1').label('Temperature (ht)');
        model.result('pg1').set('data', 'dset1');
        model.result('pg1').feature.create('surf1', 'Surface');
        model.result('pg1').feature('surf1').label('Surface');
        model.result('pg1').feature('surf1').set('colortable', 'ThermalLight');
        model.result('pg1').feature('surf1').set('data', 'parent');
        model.result.create('pg2', 'PlotGroup2D');
        model.result('pg2').label('Isothermal Contours (ht)');
        model.result('pg2').set('data', 'dset1');
        model.result('pg2').feature.create('con1', 'Contour');
        model.result('pg2').feature('con1').label('Contour');
        model.result('pg2').feature('con1').set('colortable', 'ThermalLight');
        model.result('pg2').feature('con1').set('smooth', 'internal');
        model.result('pg2').feature('con1').set('data', 'parent');
        
        model.sol('sol1').runAll;
        
        model.result('pg1').run;
        model.result('pg2').run;
        path1 = 'C:\Users\Nishi\Desktop\New folder\';
        png = '.png';
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%% image export %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        a = 'a_';
        for i = 1:200
            
            seq = num2str(i);
            xyz = strcat(a,seq);
            abc = strcat(a,no_cells,itr,b,seq);
            path = strcat(path1,path2,c,abc,png);
            
            model.result('pg1').run;
            model.result('pg1').setIndex('looplevel', i, 0);
            model.result('pg1').run;
            model.result('pg1').feature('surf1').set('colortable', 'Rainbow');
            model.result('pg1').feature('surf1').set('colortablerev', false);
            model.result('pg1').feature('surf1').set('rangecoloractive', true);
            model.result('pg1').feature('surf1').set('rangecolormax', 330);
            model.result.export.create(xyz, 'Image2D');
            model.result.export(xyz).set('printunit', 'mm');
            model.result.export(xyz).set('webunit', 'px');
            model.result.export(xyz).set('printheight', '50');
            model.result.export(xyz).set('webheight', '128');
            model.result.export(xyz).set('printwidth', '50');
            model.result.export(xyz).set('webwidth', '128');
            model.result.export(xyz).set('printlockratio', 'off');
            model.result.export(xyz).set('weblockratio', 'off');
            model.result.export(xyz).set('printresolution', '200');
            model.result.export(xyz).set('webresolution', '96');
            model.result.export(xyz).set('size', 'manualweb');
            model.result.export(xyz).set('antialias', 'on');
            model.result.export(xyz).set('zoomextents', 'off');
            model.result.export(xyz).set('title', 'on');
            model.result.export(xyz).set('legend', 'on');
            model.result.export(xyz).set('logo', 'on');
            model.result.export(xyz).set('options', 'off');
            model.result.export(xyz).set('fontsize', '9');
            model.result.export(xyz).set('customcolor', [1 1 1]);
            model.result.export(xyz).set('width', 128);
            model.result.export(xyz).set('height', 128);
            model.result.export(xyz).set('background', 'color');
            model.result.export(xyz).set('axes', 'on');
            model.result.export(xyz).set('qualitylevel', '92');
            model.result.export(xyz).set('qualityactive', 'off');
            model.result.export(xyz).set('imagetype', 'png');
            model.result.export(xyz).set('pngfilename', path);
            model.result.export(xyz).run;
        end
    end
end
