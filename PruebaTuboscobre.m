clear all
num = xlsread('PortExcel.xlsx');
tiempos_traker = num(:,1);
valores_traker= num(:,2);
tiempos_flujo = num(:,3);
valores_flujo = num(:,4);
tiempos_voltaje = num(:,5);
valores_voltaje= num(:,6);

valores_flujo = valores_flujo*20;
valores_voltaje = valores_voltaje*20;

tiempo_traslado_flujo = 25;
tiempo_traslado_voltaje = 25;

i = 1;
while(tiempos_flujo(i) < tiempo_traslado_flujo)
i = i+1;
end

valor_inicial = tiempos_flujo(i);
tiempos_flujo = tiempos_flujo(i:end);
tiempos_flujo = tiempos_flujo - valor_inicial;
valores_flujo = valores_flujo(i:end);

i2 = 1;
while(tiempos_voltaje(i2) < tiempo_traslado_voltaje)
i2 = i2+1;
end

valor_inicial = tiempos_voltaje(i2);
tiempos_voltaje = tiempos_voltaje(i2:end);
tiempos_voltaje = tiempos_voltaje - valor_inicial;
valores_voltaje = valores_voltaje(i2:end);

i = 1;
j = 0;
k = 1;
integral_flujo = valores_flujo;

while(i<size(valores_flujo,1))
    
    while(tiempos_flujo(i)> tiempos_voltaje(k))
        k = k +1;
    end
    
    j = valores_flujo(i) + j ;
    integral_flujo(i) = j;
    
    if(abs(valores_voltaje(k+1)-valores_voltaje(k)) < 0.1)
        j = j*0.87;
    end
    
    if integral_flujo(i) < 0
        integral_flujo(i) = 0;
    end
    
    i = i+1;
end

integral_flujo = integral_flujo * 0.065;

tiempo_recorte_derecha = 120;

i = 1;
while(tiempos_flujo(i) < tiempo_recorte_derecha)
i = i+1;
end

tiempos_flujo = tiempos_flujo(1:i); 
integral_flujo = integral_flujo(1:i);

j = 1;
while(tiempos_traker(j) < tiempo_recorte_derecha)
j = j+1;
end

tiempos_traker = tiempos_traker(1:j);
valores_traker = valores_traker(1:j);


resolucion = 40;

i = floor(size(valores_traker,1)/resolucion);
j = floor(size(integral_flujo,1)/resolucion);

integ_trak = [];
integ_flujo = [];

n = 1;
while n < ((size(valores_traker,1) -n) )
q = trapz(tiempos_traker(n:n+i),valores_traker(n:n+i));
integ_trak = [integ_trak, q]
n = n + i;
end

m = 1;
while m < ((size(integral_flujo,1)- m))
p = trapz(tiempos_flujo(m:m+j),integral_flujo(m:m+j));
integ_flujo = [integ_flujo, p]
m = m + j;
end


valores_traker = valores_traker +6;
integral_flujo = integral_flujo +6;

plot(tiempos_traker,valores_traker)
hold on
plot(tiempos_flujo,integral_flujo,'LineWidth',3)
title('Medición Ordeñadora 2 Mayo (CIMTEC)')
xlabel('Tiempo (s)') % x-axis label
ylabel('Litros/min') % y-axis label
legend('Medición flujómetro mecánico','Datos Sensor')



