%% WATER FILTER + IRREGULAR FOOD PARTICLES + OILY WATER ANIMATION
% MATLAB R2026a; base MATLAB only; no external CAD import or toolboxes.
%
% Combines:
% 1) Geometry from the supplied previous MATLAB model
% 2) Hydrostatic / inlet-flow calculations
% 3) Three mesh stages: 10 mm -> 8 mm -> 2 mm
% 4) Irregular food particles represented as rigid ellipsoids
% 5) Visually oily water represented by colored oil droplets
% 6) 3-D schematic animation
% 7) Particle passage / retention statistics and plots
% 8) Preliminary sheet stress calculation (NOT a structural safety certification)
%
% IMPORTANT:
% - Animation is schematic, not CFD or a real fluid solver.
% - Food-particle dimensions and oil-droplet sizes are illustrative.
% - Mesh passage is a simplified rigid-ellipsoid geometric fit test.
% - Oil droplets are visual markers; oil separation/emulsification is NOT solved.
% - The original geometry has a 200 x 350 mm upper chamber and 300 x 160 mm
%   filter plates. The 200 x 350 mm wall example is not necessarily a final
%   validated screen size. Confirm all dimensions against final CAD.
% - Pressure losses Kfilter are assumed. Real losses require measured mesh
%   open area, flow distribution, clogging and actual pump characteristics.

clc; clear; close all;
rng(10);

%% 1. USER INPUTS: WATER AND FLOW
totalWater_L = 3;
flowRate_Lmin = 3;
rho = 998;                    % kg/m^3
g = 9.81;                     % m/s^2
mu = 0.001;                   % Pa.s
inletDiameter_mm = 30;

%% 2. SHEET-METAL MATERIAL / PRELIMINARY STRUCTURAL CHECK
sheetThickness_mm = 1.2;
materialName = 'Mild Steel (assumed)';
E = 200e9;                    % Pa
yieldStrength = 250e6;        % Pa
requiredFOS = 2.0;

% If using SS304 instead, revise to suitable certified material values:
% materialName = 'SS304 (verify grade/certificate)';
% E = 193e9;
% yieldStrength = 215e6;

%% 3. GEOMETRY FROM USER'S PREVIOUS CODE (mm)
baseL = 458.4; baseW = 200; baseH = 200;
upperL = 350; upperW = 200; upperH = 350;
springGap = 80;
sheet = sheetThickness_mm;

upperX = (baseL-upperL)/2;
upperY = 0;
upperZ = baseH + springGap;

filterL = 300; filterW = 160; filterT = 1.2;
filterX = upperX + (upperL-filterL)/2;
filterY = upperY + (upperW-filterW)/2;
filterZ = [upperZ+280, upperZ+175, upperZ+70]; % TOP=10 mm, MIDDLE=8 mm, BOTTOM=2 mm

% Mesh aperture labels, coarse -> fine
meshApertures_mm = [10 8 2];
meshNames = {'10 mm top','8 mm middle','2 mm bottom'};

%% 4. OILY-WATER VISUAL SETTINGS
% This is a visual/particle marker representation, not an oil-water solver.
oilDropletCount = 90;
oilDropletDiameter_mm = [0.5 3.0];  % illustrative visual droplet diameter
oilColor = [0.96 0.55 0.08];       % amber/orange
waterColor = [0.05 0.42 0.95];

%% 5. HYDRAULIC CALCULATIONS
waterHead_m = upperH/1000;
Q_m3s = flowRate_Lmin/1000/60;
D_m = inletDiameter_mm/1000;
inletArea_m2 = pi*D_m^2/4;
inletVelocity = Q_m3s/inletArea_m2;
dynamicPressure = 0.5*rho*inletVelocity^2;
hydrostaticPressure = rho*g*waterHead_m;
totalPressureBeforeFilters = hydrostaticPressure + dynamicPressure;
Re = rho*inletVelocity*D_m/mu;

Kfilter = [1.5 2.0 3.0]; % assumed local-loss coefficients
filterPressureLoss = Kfilter*dynamicPressure;
totalFilterLoss = sum(filterPressureLoss);
systemPressure = totalPressureBeforeFilters + totalFilterLoss;
flowTime_s = totalWater_L/flowRate_Lmin*60;

% Approximate panel stress estimate from the previous script.
% This is only a simplified plate estimate; support conditions are unknown.
plateSpan_m = upperL/1000;
t_m = sheetThickness_mm/1000;
plateCoefficient = 0.30;
bendingStress_Pa = plateCoefficient*systemPressure*plateSpan_m^2/t_m^2;
deflectionCoefficient = 0.00406;
deflection_m = deflectionCoefficient*systemPressure*plateSpan_m^4/(E*t_m^3);
FOS = yieldStrength/max(bendingStress_Pa,eps);
requiredThickness_m = sqrt(plateCoefficient*systemPressure*plateSpan_m^2*requiredFOS/yieldStrength);

fprintf('\n====================================================\n');
fprintf('WATER FILTER + FOOD PARTICLE + OILY WATER ANALYSIS\n');
fprintf('====================================================\n');
fprintf('Water volume              : %.2f L\n',totalWater_L);
fprintf('Flow rate                 : %.2f L/min\n',flowRate_Lmin);
fprintf('Nominal flow duration     : %.1f s\n',flowTime_s);
fprintf('Inlet diameter            : %.1f mm\n',inletDiameter_mm);
fprintf('Inlet velocity             : %.4f m/s\n',inletVelocity);
fprintf('Reynolds number            : %.1f\n',Re);
fprintf('Hydrostatic pressure       : %.3f kPa\n',hydrostaticPressure/1000);
fprintf('Dynamic pressure           : %.5f kPa\n',dynamicPressure/1000);
fprintf('Pressure before filters    : %.3f kPa\n',totalPressureBeforeFilters/1000);
fprintf('Assumed filter losses      : %.3f Pa total\n',totalFilterLoss);
fprintf('System pressure estimate   : %.3f kPa\n',systemPressure/1000);
fprintf('\n--- PRELIMINARY SHEET ESTIMATE (NOT CERTIFICATION) ---\n');
fprintf('Material                  : %s\n',materialName);
fprintf('Thickness                 : %.2f mm\n',sheetThickness_mm);
fprintf('Estimated bending stress  : %.3f MPa\n',bendingStress_Pa/1e6);
fprintf('Estimated deflection      : %.4f mm\n',deflection_m*1000);
fprintf('Estimated FOS             : %.2f\n',FOS);
fprintf('Target FOS                : %.2f\n',requiredFOS);
fprintf('Calculated thickness for target FOS (simplified) : %.3f mm\n',...
    requiredThickness_m*1000);
fprintf('WARNING: simplified plate equation cannot certify housing safety.\n');

%% 6. GENERATE SYNTHETIC IRREGULAR FOOD PARTICLES
Nfood = 600;       % particles used for quantitative passage model
NfoodAnim = 150;   % food particles shown in animation
classNames = {'Chunks','Peels/flakes','Rice/fragments','Fibres'};
classFractions = [0.35 0.25 0.25 0.15];
classFractions = classFractions/sum(classFractions);

% [length range; width range; thickness range], in mm.
% Illustrative only; replace with measured food-waste dimensions.
dimRanges = cat(3, ...
    [3 20; 2 12; 1 8], ...       % chunks
    [5 30; 2 10; 0.2 1.5], ...   % peels/flakes
    [4 8; 1.5 3; 1 2], ...        % rice-like fragments
    [5 25; 0.3 2; 0.3 1.5]);      % fibrous pieces

[foodType,foodDims] = makeParticles(Nfood,classFractions,dimRanges);
[foodPass,retainedAt] = screenParticles(foodDims,meshApertures_mm);

fprintf('\n--- IDEALIZED FOOD PARTICLE PASSAGE ---\n');
fprintf('Synthetic food particles: %d\n',Nfood);
fprintf('Dimensions/classes are assumptions, not measured waste data.\n');
nEntering=zeros(1,3); nPassed=zeros(1,3); nRetained=zeros(1,3);
for s=1:3
    if s==1, active=true(Nfood,1); else, active=foodPass(:,s-1); end
    nEntering(s)=sum(active);
    nPassed(s)=sum(foodPass(:,s));
    nRetained(s)=sum(active & ~foodPass(:,s));
    fprintf('%s: entering=%d, passed=%d (%.1f%%), retained=%d (%.1f%%)\n',...
        meshNames{s},nEntering(s),nPassed(s),...
        100*nPassed(s)/max(nEntering(s),1),nRetained(s),...
        100*nRetained(s)/max(nEntering(s),1));
end
fprintf('Passed all stages: %.2f%% of particles by count.\n',...
    100*mean(foodPass(:,3)));
fprintf('These are geometric estimates, not validated real separation efficiencies.\n');

%% 7. FIGURE: 3D SYSTEM GEOMETRY
figure('Color','w','Name','Water Filter System with Food and Oily Water');
ax = axes; hold(ax,'on'); grid(ax,'on'); axis(ax,'equal');
xlabel('X (mm)'); ylabel('Y (mm)'); zlabel('Z (mm)');
title('Multi-Stage Water Filter: 3 L Flow, Irregular Solids and Oil Markers');
view(35,25); camlight; lighting gouraud;

% Lower collection tank
drawBox(0,0,0,baseL,baseW,baseH,[0.40 0.42 0.45],0.20);

% Upper housing walls and top cover. Open front for visibility.
metalColor = [0.62 0.65 0.69];
% Back wall
drawBox(upperX,upperY+upperW-sheet,upperZ,upperL,sheet,upperH,metalColor,0.45);
% Left and right walls
drawBox(upperX,upperY,upperZ,sheet,upperW,upperH,metalColor,0.35);
drawBox(upperX+upperL-sheet,upperY,upperZ,sheet,upperW,upperH,metalColor,0.35);
% Top cover with inlet opening not cut out in this simplified visualization
drawBox(upperX,upperY,upperZ+upperH-sheet,upperL,upperW,sheet,metalColor,0.25);

% Inlet pipe: vertical and horizontal sections
inletX = upperX+upperL/2;
inletY = upperY+upperW/2;
inletTop = upperZ+upperH;
drawCylinderZ(inletX,inletY,inletTop, inletDiameter_mm,40,[0.30 0.30 0.32]);
drawCylinderBetween(inletX,inletY,inletTop+40,...
    inletX+70,inletY,inletTop+40,inletDiameter_mm,[0.30 0.30 0.32]);

% Outlet pipe at lower tank (schematic)
outletDiameter = 30;
drawCylinderBetween(baseL/2,-40,60,baseL/2,0,60,outletDiameter,[0.30 0.30 0.32]);

% Four spring supports
springOD=22; springH=60; springTurns=7;
springX=[upperX+35 upperX+upperL-35];
springY=[30 upperW-30];
for i=1:2
    for j=1:2
        sx=springX(i); sy=springY(j);
        drawCylinderZ(sx,sy,baseH,30,12,[0.30 0.30 0.30]);
        drawSpring(sx,sy,baseH+12,springH,springOD,springTurns);
        drawCylinderZ(sx,sy,baseH+12+springH,30,12,[0.30 0.30 0.30]);
    end
end

% Three filter plates with visible grid; aperture labels are conceptual
for k=1:3
    drawFilter(filterX,filterY,filterZ(k),filterL,filterW,meshApertures_mm(k));
    text(filterX+filterL+5,filterY+filterW/2,filterZ(k)+5,meshNames{k},...
        'FontSize',9,'FontWeight','bold');
end

% Water in collection tank: translucent blue lower layer
drawBox(5,5,5,baseL-10,baseW-10,35,waterColor,0.25);

% Legend for particle markers
legendFood = scatter3(nan,nan,nan,30,[0.75 0.20 0.15],'filled');
legendOil = scatter3(nan,nan,nan,30,oilColor,'filled');
legendWater = scatter3(nan,nan,nan,30,waterColor,'filled');
legend([legendFood legendOil legendWater],{'Food solids','Oil droplets (visual markers)','Water flow markers'},...
    'Location','northeastoutside');

%% 8. ANIMATION PARTICLE INITIALIZATION
% The particles are displayed in the upper chamber and move downward.
% Their screen passage outcome comes from the geometric model.
[foodTypeA,foodDimsA] = makeParticles(NfoodAnim,classFractions,dimRanges);
[foodPassA,~] = screenParticles(foodDimsA,meshApertures_mm);

% Normalize XY coordinates to the screen area for animation.
x0 = filterX + 5 + (filterL-10)*rand(NfoodAnim,1);
y0 = filterY + 5 + (filterW-10)*rand(NfoodAnim,1);
x = x0; y = y0;
z = (upperZ+upperH-15)*ones(NfoodAnim,1);

% Oil droplet markers: visual representation of dispersed/free oil.
oilX0 = filterX + 5 + (filterL-10)*rand(oilDropletCount,1);
oilY0 = filterY + 5 + (filterW-10)*rand(oilDropletCount,1);
oilZ = (upperZ+upperH-10)*ones(oilDropletCount,1);
oilDiam = oilDropletDiameter_mm(1) + ...
    diff(oilDropletDiameter_mm)*rand(oilDropletCount,1);
oilMarkerSize = max(8,min(65,oilDiam*12));

% Water markers represent bulk flow, not individual physical water molecules.
NwaterMarkers = 280;
waterX0 = filterX + 5 + (filterL-10)*rand(NwaterMarkers,1);
waterY0 = filterY + 5 + (filterW-10)*rand(NwaterMarkers,1);
waterZ = (upperZ+upperH-5)*ones(NwaterMarkers,1);

hFood = scatter3(x,y,z,28,foodTypeA,'filled');
colormap(ax,[0.78 0.20 0.12; 0.88 0.48 0.12; 0.55 0.35 0.20; 0.35 0.22 0.12]);
hOil = scatter3(oilX0,oilY0,oilZ,oilMarkerSize,oilColor,'filled');
hWater = scatter3(waterX0,waterY0,waterZ,10,waterColor,'filled');

%% 9. ANIMATION
animationTime = flowTime_s;
dt = 0.05;
frames = max(1,round(animationTime/dt));
visualSpeed = upperH/animationTime*8; % visual scaling, not physical velocity
fprintf('\nStarting schematic animation of food particles, water and oil droplets...\n');

for frame=1:frames
    % Approximate bulk downward movement of the water markers
    waterZ = waterZ - visualSpeed*dt;
    waterX0 = waterX0 + 0.25*sin(frame/13);
    waterY0 = waterY0 + 0.20*cos(frame/17);

    % Recycle water markers at top after they reach the bottom tank
    lowWater = waterZ < baseH+15;
    if any(lowWater)
        n=sum(lowWater);
        waterZ(lowWater)=upperZ+upperH-5;
        waterX0(lowWater)=filterX+5+(filterL-10)*rand(n,1);
        waterY0(lowWater)=filterY+5+(filterW-10)*rand(n,1);
    end

    % Food particles descend; at each screen, idealized pass/retain outcomes apply.
    z = z - visualSpeed*dt;
    x = x + 0.12*sin(frame/11 + (1:NfoodAnim)');
    y = y + 0.10*cos(frame/13 + (1:NfoodAnim)');

    % Keep markers inside housing/screen planform
    x = max(filterX+2,min(filterX+filterL-2,x));
    y = max(filterY+2,min(filterY+filterW-2,y));

    % Handle particles crossing screen planes: if retained, park above that screen;
    % if passed, continue down toward the next screen.
    for s=1:3
        zPlane=filterZ(s)+2;
        crossed = z < zPlane & z > zPlane-visualSpeed*dt-1;
        for i=find(crossed(:))'
            if foodPassA(i,s)
                z(i)=filterZ(s)-2;
            else
                z(i)=filterZ(s)+3;
            end
        end
    end

    % Reset food markers that have reached the lower collection region
    lowFood = z < baseH+10;
    if any(lowFood)
        n=sum(lowFood);
        ids=find(lowFood);
        x(ids)=filterX+5+(filterL-10)*rand(n,1);
        y(ids)=filterY+5+(filterW-10)*rand(n,1);
        z(ids)=upperZ+upperH-15;
    end

    % Oil droplets follow the water downward visually. Some are shown lingering
    % near screens to suggest that separation is not guaranteed.
    oilZ = oilZ - visualSpeed*dt*0.92;
    oilX0 = oilX0 + 0.16*sin(frame/15 + (1:oilDropletCount)');
    oilY0 = oilY0 + 0.12*cos(frame/18 + (1:oilDropletCount)');
    oilX0=max(filterX+2,min(filterX+filterL-2,oilX0));
    oilY0=max(filterY+2,min(filterY+filterW-2,oilY0));
    lowOil = oilZ < baseH+15;
    if any(lowOil)
        n=sum(lowOil);
        oilZ(lowOil)=upperZ+upperH-10;
        oilX0(lowOil)=filterX+5+(filterL-10)*rand(n,1);
        oilY0(lowOil)=filterY+5+(filterW-10)*rand(n,1);
    end

    set(hFood,'XData',x,'YData',y,'ZData',z);
    set(hOil,'XData',oilX0,'YData',oilY0,'ZData',oilZ);
    set(hWater,'XData',waterX0,'YData',waterY0,'ZData',waterZ);

    elapsed = frame*dt;
    volumePassed = min(flowRate_Lmin*elapsed/60,totalWater_L);
    title(ax,sprintf('3 L batch | %.1f L/min | nominal volume passed %.2f L | oil shown schematically',...
        flowRate_Lmin,volumePassed));
    drawnow;
    pause(dt);
end
fprintf('Animation completed.\n');

%% 10. PRESSURE GRAPH
figure('Color','w','Name','Pressure Distribution');
depth_mm=linspace(0,upperH,100);
pressure_kPa=rho*g*(depth_mm/1000)/1000;
plot(depth_mm,pressure_kPa,'LineWidth',2);
xlabel('Water depth (mm)'); ylabel('Hydrostatic pressure (kPa)');
title('Hydrostatic Pressure Distribution'); grid on;

%% 11. FOS GRAPH (PRELIMINARY ONLY)
figure('Color','w','Name','Factor of Safety Estimate');
bar(FOS); hold on; yline(requiredFOS,'--','Required FOS');
ylabel('Estimated factor of safety');
title('Simplified sheet-metal FOS estimate (not certification)'); grid on;

%% 12. SUMMARY ANALYSIS DISPLAY (FORMATTED LIKE THE REFERENCE IMAGE)
% A report-style summary panel showing the main calculated values.
% Flow duration is shown correctly in seconds and minutes:
% 3 L / 3 L/min = 1 minute = 60 seconds.

figure('Color','w','Name','Water Filter Analysis Summary',...
    'Position',[180 100 760 760]);
axis off;

if FOS >= requiredFOS
    safetyLabel = 'PRELIMINARY PASS';
else
    safetyLabel = 'REVIEW REQUIRED';
end

summaryText = sprintf([ ...
    'WATER FILTER ANALYSIS\n\n' ...
    'Total water             : %.2f L\n' ...
    'Flow rate                : %.2f L/min\n' ...
    'Flow duration            : %.1f s (%.2f min)\n\n' ...
    'Hydrostatic P             : %.3f kPa\n' ...
    'Dynamic P                 : %.5f kPa\n' ...
    'Total estimated P         : %.3f kPa\n' ...
    'Estimated filter loss     : %.2f Pa\n\n' ...
    'Sheet thickness           : %.2f mm\n' ...
    'Estimated stress          : %.2f MPa\n' ...
    'Estimated deflection      : %.3f mm\n' ...
    'Factor of Safety          : %.2f\n' ...
    'Required FOS              : %.2f\n\n' ...
    'RESULT: %s\n\n' ...
    'Particle model: 10 mm -> 8 mm -> 2 mm\n' ...
    'Synthetic particles passed all stages: %.1f%% (count-based)\n\n' ...
    'NOTE: Preliminary estimates only. Confirm material, supports,\n' ...
    'mesh open area, particle sizes and test results experimentally.'], ...
    totalWater_L, flowRate_Lmin, flowTime_s, flowTime_s/60, ...
    hydrostaticPressure/1000, dynamicPressure/1000, ...
    systemPressure/1000, totalFilterLoss, ...
    sheetThickness_mm, bendingStress_Pa/1e6, deflection_m*1000, ...
    FOS, requiredFOS, safetyLabel, 100*mean(foodPass(:,3)));

text(0.06,0.96,summaryText,...
    'Units','normalized',...
    'FontName','Arial',...
    'FontSize',13,...
    'VerticalAlignment','top',...
    'Interpreter','none');

%% 13. PARTICLE PASSAGE GRAPHS
figure('Color','w','Name','Particle passage by stage');
bar([nRetained(:),nPassed(:)]);
set(gca,'XTickLabel',meshNames);
ylabel('Particle count'); legend('Retained at stage','Passed stage','Location','best');
title('Idealized geometric particle passage'); grid on;

retByClass=zeros(4,3); passPct=nan(4,3);
for k=1:4
    idx=foodType==k;
    for s=1:3
        if s==1, entering=idx; else, entering=idx & foodPass(:,s-1); end
        retByClass(k,s)=sum(entering & ~foodPass(:,s));
        if sum(entering)>0
            passPct(k,s)=100*sum(foodPass(entering,s))/sum(entering);
        end
    end
end
figure('Color','w','Name','Retention by food class');
bar(retByClass,'grouped');
set(gca,'XTickLabel',classNames); ylabel('Particles retained');
legend(meshNames,'Location','best'); title('Predicted retention by particle class'); grid on;

%% 14. EXPORT PARTICLE RESULTS
T=table((1:Nfood)',foodType,foodDims(:,1),foodDims(:,2),foodDims(:,3),...
    foodPass(:,1),foodPass(:,2),foodPass(:,3),retainedAt,...
    'VariableNames',{'ParticleID','ClassID','Length_mm','Width_mm','Thickness_mm',...
    'Pass10mm','Pass8mm','Pass2mm','RetainedAtStage'});
writetable(T,'water_filter_oily_food_particle_results.csv');
fprintf('Particle-level CSV saved as water_filter_oily_food_particle_results.csv\n');
fprintf('Complete. Review all assumptions before using results in your report.\n');

%% LOCAL FUNCTIONS
function [type,dims] = makeParticles(N,fractions,ranges)
    type=zeros(N,1); dims=zeros(N,3); cumulative=cumsum(fractions);
    for i=1:N
        k=find(rand<=cumulative,1,'first');
        if isempty(k), k=numel(fractions); end
        type(i)=k;
        for j=1:3
            lo=ranges(j,1,k); hi=ranges(j,2,k);
            dims(i,j)=lo+(hi-lo)*rand;
        end
    end
end

function [pass,retainedAt] = screenParticles(dims,apertures)
    % Rigid ellipsoid approximation and random 3D orientation.
    N=size(dims,1); ns=numel(apertures);
    pass=false(N,ns); retainedAt=zeros(N,1); active=true(N,1);
    for s=1:ns
        for i=1:N
            if active(i)
                L=dims(i,1); W=dims(i,2); T=dims(i,3);
                u1=rand; u2=rand; u3=rand;
                qx=sqrt(1-u1)*sin(2*pi*u2);
                qy=sqrt(1-u1)*cos(2*pi*u2);
                qz=sqrt(u1)*sin(2*pi*u3);
                qw=sqrt(u1)*cos(2*pi*u3);
                R=[1-2*(qy^2+qz^2),2*(qx*qy-qz*qw),2*(qx*qz+qy*qw);...
                   2*(qx*qy+qz*qw),1-2*(qx^2+qz^2),2*(qy*qz-qx*qw);...
                   2*(qx*qz-qy*qw),2*(qy*qz+qx*qw),1-2*(qx^2+qy^2)];
                a=L/2; b=W/2; c=T/2;
                px=2*sqrt((a*R(1,1))^2+(b*R(1,2))^2+(c*R(1,3))^2);
                py=2*sqrt((a*R(2,1))^2+(b*R(2,2))^2+(c*R(2,3))^2);
                fits=(px<=apertures(s)) && (py<=apertures(s));
                pass(i,s)=fits;
                if ~fits
                    active(i)=false;
                    retainedAt(i)=s;
                end
            end
        end
    end
end

function drawBox(x,y,z,L,W,H,C,A)
    V=[x y z; x+L y z; x+L y+W z; x y+W z; ...
       x y z+H; x+L y z+H; x+L y+W z+H; x y+W z+H];
    F=[1 2 3 4;5 6 7 8;1 2 6 5;2 3 7 6;3 4 8 7;4 1 5 8];
    patch('Vertices',V,'Faces',F,'FaceColor',C,'FaceAlpha',A,...
        'EdgeColor',[0.15 0.15 0.15]);
end

function drawCylinderZ(x,y,z,D,H,C)
    [X,Y,Z]=cylinder(D/2,24);
    surf(X+x,Y+y,Z*H+z,'FaceColor',C,'EdgeColor','none');
end

function drawCylinderBetween(x1,y1,z1,x2,y2,z2,D,C)
    [X,Y,Z]=cylinder(D/2,24);
    p1=[x1;y1;z1]; p2=[x2;y2;z2];
    v=p2-p1; L=norm(v);
    if L<eps, return; end
    Z=Z*L; v=v/L; k=[0;0;1];
    axisRot=cross(k,v); s=norm(axisRot); c=dot(k,v);
    if s<1e-10
        if c>0, R=eye(3); else, R=diag([1 -1 -1]); end
    else
        axisRot=axisRot/s;
        K=[0 -axisRot(3) axisRot(2);axisRot(3) 0 -axisRot(1);...
           -axisRot(2) axisRot(1) 0];
        R=eye(3)+K*s+K*K*(1-c);
    end
    P=R*[X(:)';Y(:)';Z(:)'];
    X=reshape(P(1,:),size(X))+x1;
    Y=reshape(P(2,:),size(Y))+y1;
    Z=reshape(P(3,:),size(Z))+z1;
    surf(X,Y,Z,'FaceColor',C,'EdgeColor','none');
end

function drawSpring(x,y,z,H,OD,turns)
    theta=linspace(0,2*pi*turns,350);
    r=OD/2;
    plot3(x+r*cos(theta),y+r*sin(theta),z+H*theta/(2*pi*turns),...
        'Color',[0.15 0.15 0.15],'LineWidth',1.5);
end

function drawFilter(x,y,z,L,W,aperture)
    % Frame and schematic mesh grid; grid spacing is visual only.
    drawBox(x,y,z,L,W,1.2,[0.15 0.45 0.80],0.22);
    nx=30; ny=16;
    for i=1:nx
        xx=x+i*L/nx;
        plot3([xx xx],[y y+W],[z+1.5 z+1.5],...
            'Color',[0.05 0.20 0.50],'LineWidth',0.25);
    end
    for j=1:ny
        yy=y+j*W/ny;
        plot3([x x+L],[yy yy],[z+1.5 z+1.5],...
            'Color',[0.05 0.20 0.50],'LineWidth',0.25);
    end
    text(x+L/2,y+W/2,z+5,sprintf('%g mm aperture',aperture),...
        'HorizontalAlignment','center','FontSize',8,'Color',[0.05 0.1 0.3]);
end
