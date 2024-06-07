Sets
i ciudades /1*26/
t vehículos /1*3/
w escenarios /1*5/
;

alias(j,i);

$include carreteras_cortadas.txt

Parameters
cl(i)  coste de construir el centro en la ciudad i /1 19000,2 16000,3 11000,4 14000,5 16000,6 16000,7 17000,8 12000,9 13000,10 18000,11 16000,12 17000,13 12000,14 15000,15 10000,16 14000,17 20000,18 18000,19 12000,20 15000,21 20000,22 15000,23 13000,24 10000,25 19000,26 19000/
q(t) capacidad del vehículo t /1 10000,2 5000, 3 3000/
k(t) coste por kilómetro del vehículo t /1 0.4, 2 0.2, 3 1/
ca(t) coste de alquiler del vehículo t /1 100, 2 200, 3 1000/
p(w) probabilidad del escenario w /1 0.02552415679124886,2 0.0911577028258888,3 0.10847766636280766,4 0.1340018231540565,5 0.6408386508659981/
qm(i) capacidad máxima de kits en cada ciudad /1 17000,2 10000,3 19000,4 19000,5 16000,6 10000,7 11000,8 11000,9 17000,10 11000,11 11000,12 10000,13 11000,14 12000,15 17000,16 10000,17 18000,18 14000,19 11000,20 15000,21 12000,22 11000,23 13000,24 13000,25 10000,26 12000/
;

scalar
mn cantidad mínima de centros a construir /2/
mx cantidad mínima de centros a construir /3/
;

scalar
Pt presupuesto total /1000000/
v variación del precio del mercado /0/
;

Table m(i,t) máximo número de vehículos del tipo t en la ciudad i
;
$include vehiculos.txt

Table dem(i,w) demanda en la ciudad i en el escenario w
;
$include demandas.txt

Table l(i,j) distancia entre las ciudades i y j
;
$include distancias.txt

variables
Z objetivo
X(i) si se construye o no centro en la ciudad i
Y(i,j,w) cantidad de kits que se mandan de i a j en w
Z1(i,j,t,w) cantidad de vehículos t que viajan de i a j en w
D(i,w) cantidad de demanda que se satisface en i desde otra ciudad en w
Ct(i,t,w) cantidad de transportes t que se alquilan en i en w
U(i,w) orden en el que se reparte a la ciudad i en w
;

integer variables Y,Z1,D,Ct;
binary variables X;
positive variables U;


Equations
objetivo funcion objetivo
minNumCentros cota inferior al número de centros construidos
maxNumCentros cota superior al número de centros construidos
presupuesto(w) cota superior al presupuesto de la operacion
demanda(i,w) cota superior a la cantidad repartida por ciudad
alquileres(i,t,w) restriccion de donde se puede alquilar
carreteras1 restriccion de carreteras cortadas esc 1
carreteras2 restriccion de carreteras cortadas esc 2
carreteras3 restriccion de carreteras cortadas esc 3
carreteras4 restriccion de carreteras cortadas esc 4
carreteras5 restriccion de carreteras cortadas esc 5
conexion(i,j,w) restriccion que conecta ambos grafos
flujoDem(i,w) condicion de flujo del grafo de kits
flujoVeh(i,t,w) condicion de flujo del grafo de transportes
*seguridad(i)
;

objetivo.. sum(w,p(w)*sum(i,D(i,w))) =e= Z;
minNumCentros.. sum(i,X(i)) =g= mn;
maxNumCentros.. sum(i,X(i)) =l= mx;
presupuesto(w).. (1+v)*(sum(i,cl(i)*X(i))+sum(t,ca(t)*sum(i,Ct(i,t,w))+k(t)*sum(i,sum(j,l(i,j)*Z1(i,j,t,w))))) =l= Pt;
demanda(i,w).. D(i,w) =l= dem(i,w);
alquileres(i,t,w).. Ct(i,t,w) =l= Pt/ca(t)*X(i);
carreteras1.. sum(cortadas_camiones_esc_1(i,j),Z1(i,j,'1','1')) + sum(cortadas_barcos_esc_1(i,j),Z1(i,j,'2','1')) =e= 0;
carreteras2.. sum(cortadas_camiones_esc_2(i,j),Z1(i,j,'1','2')) + sum(cortadas_barcos_esc_2(i,j),Z1(i,j,'2','2')) =e= 0;
carreteras3.. sum(cortadas_camiones_esc_3(i,j),Z1(i,j,'1','3')) + sum(cortadas_barcos_esc_3(i,j),Z1(i,j,'2','3')) =e= 0;
carreteras4.. sum(cortadas_camiones_esc_4(i,j),Z1(i,j,'1','4')) + sum(cortadas_barcos_esc_4(i,j),Z1(i,j,'2','4')) =e= 0;
carreteras5.. sum(cortadas_camiones_esc_5(i,j),Z1(i,j,'1','5')) + sum(cortadas_barcos_esc_5(i,j),Z1(i,j,'2','5')) =e= 0;
conexion(i,j,w).. Y(i,j,w) =l= sum(t,q(t)*Z1(i,j,t,w));
flujoDem(i,w).. qm(i)*X(i)+sum(j,Y(j,i,w)) =g= D(i,w)+sum(j,Y(i,j,w));
flujoVeh(i,t,w).. m(i,t)*X(i)+Ct(i,t,w)+sum(j,Z1(j,i,t,w)) =g= sum(j,Z1(i,j,t,w));
*seguridad(i).. X(i)*sum(w,dem(i,w)) =e= 0;


model modelo /all/;
solve modelo maximizing Z using MIP;

Parameter
    sol,
    xsol(i),
    ysol(i,j,w),
    zsol(i,j,t,w),
    dsol(i,w),
    csol(i,t,w)
    ;

sol=z.l;
xsol(i) = x.l(i);
ysol(i,j,w)=y.l(i,j,w);
zsol(i,j,t,w)=z1.l(i,j,t,w);
dsol(i,w)=d.l(i,w);
csol(i,t,w)=ct.l(i,t,w);

execute_unload 'solution.gdx', sol,xsol,ysol,zsol,dsol,csol;

execute 'export_to_excel.bat';